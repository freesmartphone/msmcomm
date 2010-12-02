/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm
{
    public class ModemControl : AbstractObject
    {
        private FsoFramework.Transport transport;
        private LinkLayerControl llc;
        private Gee.HashMap<string,string> modem_config;
        private LowLevelControl lowlevel;
        private bool use_lowlevel;
        private GLib.ByteArray in_buffer;
        private ModemChannel channel;
        
        public bool active { get; private set; default = false; }

        //
        // private API
        //

        private void onTransportReadyToRead(FsoFramework.Transport t)
        {
            int bread = 0;
            var data = new uint8[4096];

            bread = t.read(data, data.length);

            if (!active)
            {
                logger.debug("Could not read to any data from modem, as we are in in-active mode!");
                return;
            }

            llc.processIncommingData(data[0:bread]);
        }

        private void onTransportHangup(FsoFramework.Transport t)
        {
            logger.error("[HUP] Modem transport closed from other side");
            // FIXME block everything until modem transport comes back
        }
        
        private void configure()
        {
            modem_config["connection_type"] = config.stringValue("connection", "type", "serial");
            
            if (modem_config["connection_type"] == "serial")
            {   
                modem_config["path"] = config.stringValue("connection", "path", "/dev/modemuart");
            }
            else if (modem_config["connection_type"] == "network")
            {
                modem_config["ip"] = config.stringValue("connection", "ip", "192.168.0.202");
                modem_config["port"] = config.stringValue("connection", "port", "3001");
            }
            
            use_lowlevel = config.hasSection("lowlevel");
        }

        private bool setupModemTransport()
        {
            if (modem_config["connection_type"] == "network") 
            {
                transport = new FsoFramework.SocketTransport("tcp", modem_config["ip"], modem_config["port"].to_int());
            }
            else if (modem_config["connection_type"] == "serial") 
            {
                transport = new FsoFramework.HsuartTransport(modem_config["path"]);
            }
            else
            {
                logger.error("Could not create transport. Wrong transport type '%s' specified in configuration. Please go and fix this!".printf(modem_config["connection_type"]));
                return false;
            }
            
            transport.setDelegates(onTransportReadyToRead, onTransportHangup);

            return true;
        }

        private bool openModemTransport()
        {
            if (!transport.isOpen())
            {
                logger.debug("Trying to open modem transport ...");
                
                // Some the transport could not create, log error and abort mainloop
                if ( !transport.open() )
                {
                    logger.error("Could not open transport");
                    return false;
                }
            }

            return true;
        }

        private void closeModemTransport()
        {
            logger.debug("Trying to close modem transport ...");
            if (transport.isOpen())
            {
                transport.close();
            }
        }

        /*
         * Take data from llc and send it to the user
         */ 
        private void handleModemRequestFrameContent(uint8[] data)
        {
            if (active)
            {
                channel.handleIncommingData(data);
            }
        }
        
        /*
         * Take data from llc and send it to the modem
         */
        private void handleModemRequestSendData(uint8[] data)
        {
            if (!active) 
            {
                logger.debug("Could not send to any data to modem, as we are in in-active mode!");
                return;
            }
            
            transport.write(data, data.length);
        }
        
        /*
         * Something within the link layer went wrong and we should restart 
         * the whole stack - this includes a hard reset of the modem. This is different
         * from what does inside when something went wrong. The link restarts itself
         * when it detects that it runs out of sync with the modem and tries to resync.
         */
        private void handleRequestModemReset()
        {
            llc.stop();
            closeModemTransport();

            if (use_lowlevel)
            {
                lowlevel.reset();
            }
        
            openModemTransport();
            llc.start();
        }

        private void handleLinkSetupComplete()
        {
            statusUpdate(Msmcomm.ModemControlStatus.ACTIVE);
        }

        //
        // public API
        //
        
        public ModemControl()
        {
            modem_config = new Gee.HashMap<string,string>();
            lowlevel = new LowLevelControl();
            in_buffer = new GLib.ByteArray();
        }

        /*
         * Setup every other component we need to work probably
         */
        public bool setup()
        {
            logger.debug("Setup the daemon ...");

            configure();
            if (!setupModemTransport())
            {
                logger.error("Setup modem transport failed!");
                return false;
            }
            
            
            /* setup our link layer control and connect our handlers for different
             * signals provided by the llc */
            logger.debug("Initialize link layer control ...");
            llc = new LinkLayerControl();
            llc.requestHandleSendData.connect(handleModemRequestSendData);
            llc.requestHandleFrameContent.connect(handleModemRequestFrameContent);
            llc.requestModemReset.connect(handleRequestModemReset);
            llc.requestHandleLinkSetupComplete.connect(() => { handleLinkSetupComplete(); });
            
            logger.debug("Worker setup finished!");

            return true; 
        }
        
        /*
         * Send a data package to the attached modem
         */
        public void send(uint8[] data, int length)
        {
            if (active)
            {
                llc.sendDataFrame(data, length);
            }
        }

        /*
         * Start the modem controller: opens the modem transport and 
         * starts the link layer control.
         */ 
        public bool start()
        {
            if (active) 
            {
                logger.debug("Modem was started, but it is already in active mode! We ignore this ...");
                return false;
            }   
            
            // low-level reset of the modem
            if (use_lowlevel)
                lowlevel.reset();
            
            // FIXME try more than one time to open the modem port. Do that in a specific time
            // interval
            if (!openModemTransport()) 
            {
                logger.debug("Worker::openModemTransport() failed!");
                return false;
            }
            
            llc.start();
            active = true;
        
            return true;
        }

        /*
         * Stop modem controller: closes the modem transport and stops
         * the link layer control
         */
        public void stop()
        {
            if (!active)
            {
                logger.debug("Modem should be stopped but is not in active mode.");
                return;
            }
                
            active = false;
            closeModemTransport();
            llc.stop();
            statusUpdate(Msmcomm.ModemControlStatus.INACTIVE);
        }

        /*
         * Combines start and stop methods
         */
        public bool reset()
        {
            stop();
            return start();
        }
        
        public void registerChannel(ModemChannel channel)
        {
            this.channel = channel;
            channel.requestHandleUnsolicitedResponse.connect((type, msg) => { requestHandleUnsolicitedResponse(type, msg); } );
        }
        
        public async void processCommand(BaseCommand command) throws Msmcomm.Error
        {
            command.channel = channel;
            yield command.run();
        }
        
        public override string repr()
        {
            return "<>";
        }
        
        public signal void requestHandleUnsolicitedResponse(Msmcomm.MessageType type, Msmcomm.Message message);
        public signal void statusUpdate(Msmcomm.ModemControlStatus status);
    }
} // namespace Msmcomm
