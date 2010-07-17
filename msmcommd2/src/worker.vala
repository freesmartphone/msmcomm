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

    //
    // private API
    //

    private void onTransportReadyToRead(FsoFramework.Transport t)
    {
        int bread = 0;
        var data = new uint8[4096];
        
        bread = t.read(data, data.length);
        
        logger.debug(@"onTransportReadyToRead: Read $(bread) bytes from modem");
        hexdump(false, data[0:bread], bread, logger);
        
        llc.processIncommingData(data[0:bread]);
    }

    private void onTransportHangup(FsoFramework.Transport t)
    {
        // FIXME
    }

    private void handleSendDataRequest(uint8[] data)
    {
        hexdump(true, data, data.length, FsoFramework.theLogger);
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
        llc.sendDataFrame(data, size);
    }

    //
    // public API
    //
    
    public Worker()
    {
        logger = FsoFramework.theLogger;
        config = FsoFramework.theConfig;
        modem_config = new Gee.HashMap<string,string>();
        remote_handler = new RemoteClientHandler();
    }

    public bool setup()
    {
        configure();

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

        // Some the transport could not create, log error and abort mainloop
        if ( !transport.open() )
        {
            logger.error("Could not open transport");
            loop.quit();
            return false;
        }

        // setup link layer control
        llc = new LinkLayerControl();
        llc.requestHandleSendData.connect(handleSendDataRequest);
        llc.requestHandleFrameContent.connect(remote_handler.handleDataFromModem);
        llc.reset();
        
        remote_handler.requestHandleDataFromClient.connect(handleDataFromClient);
        remote_handler.setup();

        return false;
    }
}

} // namespace Msmcomm
