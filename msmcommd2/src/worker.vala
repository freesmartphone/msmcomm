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
    private LinkLayerControl llc;

    public Worker()
    {
        logger = FsoFramework.theLogger;
    }

    //
    // private API
    //

    private void onTransportReadyToRead(FsoFramework.Transport t)
    {
        int bread = 0;
        var data = new uint8[4096];
        
        bread = t.read(data, data.length);
        llc.processIncommingData(data);
    }

    public void onTransportHangup(FsoFramework.Transport t)
    {
        // FIXME
    }

    public void handleSendDataRequest(uint8[] data)
    {
        // hexdump(true, data, data.length, FsoFramework.theLogger);
        transport.write(data, data.length);
    }

    //
    // public API
    //

    public bool setup()
    {
        logger.info("setup everything we need ...");

        // setup transport
        // FIXME read ip + port from configuration
        transport = new FsoFramework.SocketTransport("tcp", "192.168.0.202", 3001);
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
        // FIXME llc.handleFrameContent += ...

        llc.reset();

        return false;
    }
}

} // namespace Msmcomm
