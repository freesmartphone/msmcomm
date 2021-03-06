/**
 * This file is part of msmcommd.
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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

using Msmcomm.HciLinkLayer;

namespace Msmcomm.Daemon
{
    public enum ModemPowerState
    {
        SUSPEND,
        RESUME
    }

    public class ModemControl : AbstractObject
    {
        private FsoFramework.Transport transport;
        private LinkLayerControl llc;
        private Gee.HashMap<string,string> modem_config;
        private LowLevelControl lowlevel;
        private bool use_lowlevel;
        private GLib.ByteArray in_buffer;
        private HciModemChannel channel;
        private bool in_link_setup;
        private int lockCount;

        public bool active { get; private set; default = false; }

        //
        // private API
        //

        private void onTransportReadyToRead(FsoFramework.Transport t)
        {
            int bread = 0;
            var data = new uint8[4096];

            bread = t.read(data, data.length);

            if (in_link_setup || active)
            {
                 llc.processIncomingData(data[0:bread]);
            }
            else
            {
                logger.debug("Could not read to any data from modem, as we are in in-active mode!");
                return;
            }
        }

        private void onTransportHangup(FsoFramework.Transport t)
        {
            logger.error("[HUP] Modem transport closed from other side");
            stop();
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
                transport = new FsoFramework.SocketTransport("tcp", modem_config["ip"], int.parse(modem_config["port"]));
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
            if (in_link_setup || active)
            {
                channel.handleIncommingData(data);
            }
        }

        /*
         * Take data from llc and send it to the modem
         */
        private void handleModemRequestSendData(uint8[] data)
        {
            if (in_link_setup || active)
            {
                transport.write(data, data.length);
            }
            else
            {
                logger.debug("Could not send to any data to modem, as we are in in-active mode!");
                return;
            }
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
            active = true;
            in_link_setup = false;
            statusUpdate(Msmcomm.ModemStatus.ACTIVE);
        }

        //
        // public API
        //

        public ModemControl()
        {
            modem_config = new Gee.HashMap<string,string>();
            lowlevel = new LowLevelControl();
            in_buffer = new GLib.ByteArray();
            in_link_setup = false;
            lockCount = 0;

            statusUpdate.connect(handleStatusUpdate);
        }

        /*
         * Setup every other component we need to start working.
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

            var settings = LinkLayerSettings();
            settings.window_size = (uint8) config.intValue("hll", "window_size", 8);
            settings.max_send_attempts = config.intValue("hll", "max_send_attempts", 10);

            llc = new LinkLayerControl(settings);
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
        public void sendData(uint8[] data)
        {
            if (in_link_setup || active)
                llc.sendDataFrame(data);
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

            in_link_setup = true;
            llc.start();

            return true;
        }

        /*
         * Stop modem controller: closes the modem transport and stops
         * the link layer control
         */
        public void stop()
        {
            logger.debug("Someone wants the modem controller to be stopped ...");

            if (!active)
            {
                logger.debug("Modem should be stopped but is not in active mode.");
                return;
            }

            active = false;
            closeModemTransport();
            llc.stop();
            statusUpdate(Msmcomm.ModemStatus.INACTIVE);
        }

        public void handleStatusUpdate(Msmcomm.ModemStatus status)
        {
            logger.debug(@"Modem control switched to status '$(modemStatusToString(status))'");
        }

        /*
         * Combines start and stop methods
         */
        public bool reset()
        {
            stop();
            return start();
        }

        /**
         * Handle different power states of the modem. For example when the system wants
         * to go into suspend state we need to prepare the modem communication layer for
         * this. It's same when we are comming out of a suspend and start working again.
         **/
        public async bool handlePowerState(ModemPowerState state)
        {
            FsoFramework.HsuartTransport hsuartTransport = null;

            // First forward power state to all connected channels
            channel.handlePowerState(state);

            if (state == ModemPowerState.SUSPEND)
            {
                if (!active)
                {
                    assert(logger.debug(@"We're not active so we don't need to handle power state $(state)."));
                    return false;
                }

                yield waitUntilUnlocked();

                // Ok, as now all pending messages are send to the modem, we can go into
                // suspend state.
                active = false;
                llc.sendAllFramesNow();
                transport.flush();
                transport.freeze();
                statusUpdate(Msmcomm.ModemStatus.INACTIVE);

                // When we have a high speed uart as transport we need to suspend it
                hsuartTransport = transport as FsoFramework.HsuartTransport;
                if (hsuartTransport != null)
                {
                    assert(logger.debug("Suspending hsuart transport ..."));
                    if (!hsuartTransport.suspend())
                    {
                        logger.error("Failed to suspend the hsuart transport!");
                        return false;
                    }
                }
            }
            else if (state == ModemPowerState.RESUME)
            {
                // If we have a hsuart transport we need to resume it first
                hsuartTransport = transport as FsoFramework.HsuartTransport;
                if (hsuartTransport != null)
                {
                    assert(logger.debug("Resuming the hsuart transport ..."));
                    hsuartTransport.resume();
                }

                transport.thaw();
                active = true;
                statusUpdate(Msmcomm.ModemStatus.ACTIVE);
            }

            return true;
        }

        public void registerChannel(HciModemChannel channel)
        {
            this.channel = channel;
            channel.requestHandleUnsolicitedResponse.connect((message) => { requestHandleUnsolicitedResponse(message); });
        }

        public HciModemChannel retrieveChannel()
        {
            return channel;
        }

        /**
         * Lock the modem. The lock will only avoid suspending the modem when we're told
         * to do so but there are still operations pending.
         **/
        public void lock()
        {
            lockCount++;
        }

        /**
         * Unlock the modem as a operation has finished.
         **/
        public void unlock()
        {
            if (lockCount == 0)
            {
                logger.error("Lock count is already zero! Can't unlock ...");
                return;
            }

            lockCount--;
        }

        /**
         * Wait until the modem gets unlocked.
         **/
        public async void waitUntilUnlocked()
        {
            if (isLocked())
            {
                Timeout.add(200, () => {
                    // When we're unlocked now we can return to the caller
                    if (!isLocked())
                        return false;

                    // We're still locked so try again
                    return true;
                });
                yield;
            }
        }

        /**
         * Check if modem is locked or not.
         **/
        public bool isLocked()
        {
            return lockCount > 0;
        }

        public override string repr()
        {
            return "<>";
        }

        public signal void requestHandleUnsolicitedResponse(Msmcomm.LowLevel.BaseMessage message);
        public signal void statusUpdate(Msmcomm.ModemStatus status);
    }
} // namespace Msmcomm

