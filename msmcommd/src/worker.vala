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

// FIXME rename this class, as we need a more impressive name
public class Worker
{
    private FsoFramework.Transport transport;
    private FsoFramework.Logger logger;
    private FsoFramework.SmartKeyFile config;
    private LinkLayerControl llc;
    private Gee.HashMap<string,string> modem_config;
    private RemoteClientHandler remote_handler;
    private LowLevelControl lowlevel;

    public bool active { get; private set; default = false; }

    //
    // private API
    //

    private void onTransportReadyToRead(FsoFramework.Transport t)
    {
        int bread = 0;
        var data = new uint8[4096];
        
        bread = t.read(data, data.length);
        
        if (active)
            return;

        llc.processIncommingData(data[0:bread]);
    }

    private void onTransportHangup(FsoFramework.Transport t)
    {
        logger.error("[HUP] Modem transport closed from other side");
        // FIXME block everything until modem transport comes back
    }

    private void handleSendDataRequest(uint8[] data)
    {
        if (active)
            return;

        transport.write(data, data.length);
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
    }
    
    private void handleDataFromClient(uint8[] data, int size)
    {
        if (!active)
            return;

        llc.sendDataFrame(data, size);
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
        if (transport.isOpen())
        {
            transport.close();
        }
    }

    private void handleDataFromModem(uint8[] data)
    {
        if (!active)
            return;

        remote_handler.handleDataFromModem(data);
    }

    //
    // public API
    //
    
    public Worker()
    {
        logger = FsoFramework.theLogger;
        config = FsoFramework.theConfig;
        modem_config = new Gee.HashMap<string,string>();
        lowlevel = new LowLevelControl();
    }

    public bool setup()
    {
        logger.debug("Setup the daemon ...");

        configure();
        if (!setupModemTransport())
            return false;

        // setup link layer control
        logger.debug("Initialize link layer control ...");
        llc = new LinkLayerControl();
        llc.requestHandleSendData.connect(handleSendDataRequest);
        llc.requestHandleFrameContent.connect(handleDataFromModem);
        
        // setup remote client handler
        logger.debug("Initialize remote client handler ...");
        remote_handler = new RemoteClientHandler();
        remote_handler.requestHandleDataFromClient.connect(handleDataFromClient);

        // We are starting the remote service already here as we are accepting incomming
        // connections already while we don't have an connection to the modem. The clients
        // can already register but should wait until the start/reset dbus functions
        // returns without an error
        logger.debug("Start accepting incomming client connections ...");
        remote_handler.setup();

        logger.debug("Worker setup finished ... waiting for start command!");

        return true; 
    }

    public bool start()
    {
        // FIXME try more than one time to open the modem port. Do that in a specific time
        // interval
        if (!openModemTransport()) 
            return false;

        llc.reset();
        remote_handler.reset();

        active = true;

        return true;
    }
    

    public void stop()
    {
        active = false;
        closeModemTransport();
    }

    public bool reset()
    {
        stop();
        return start();
    }

}

} // namespace Msmcomm
