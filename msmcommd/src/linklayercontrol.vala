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

public class LinkLayerControl : ILinkControl, ITransmissionControl, GLib.Object
{
    private FsoFramework.Logger logger;
    private LinkContext context;
    private Gee.ArrayList<AbstractLinkHandler> handlers;
    private TransmissionHandler transmission_handler;
    private FsoFramework.SmartKeyFile config;
    private ByteArray in_buffer;

    //
    // public API
    //

    public LinkLayerControl()
    {
        logger = FsoFramework.theLogger;
        config = FsoFramework.theConfig;
        context = new LinkContext();

        Crc16.setup();
                
        handlers = new Gee.ArrayList<AbstractLinkHandler>();
        handlers.add(new SetupLinkHandler(context, this));
        handlers.add(new FlowControlHandler(context, this));
        handlers.add(new ActiveLinkHandler(context, this));
        
        transmission_handler = new TransmissionHandler(context, this);
        
        in_buffer = new ByteArray();
        
        configure();
    }
    
    public void start()
    {
        context.reset();
        foreach (AbstractLinkHandler handler in handlers)
        {
            handler.start();
        }
    }

    public void stop()
    {
        foreach (AbstractLinkHandler handler in handlers)
        {
            handler.stop();
        }
    }
    
    public void reset()
    {
        stop();
        start();
    }

    public void processIncommingData(uint8[] data)
    {
        uint start = 0;
        uint n = 0;
        
        in_buffer.append(data);
        
        var tmp = new uint8[in_buffer.len];
        Memory.copy(tmp, in_buffer.data, in_buffer.len);
        
        // try to find a valid frame within the incomming data
        foreach (var byte in tmp)
        {
            n++;
            
            // search for the frame end byte, if we found it then we
            // have found a valid frame
            if (byte == 0x7e)
            {
                // We have found a valid frame, first unpack it 
                var frame = new Frame();
                // FIXME implement exception to get a better error handling
                if (!frame.unpack(tmp[start:n]))
                {
                    logger.error("processIncommingData: Could not unpack valid frame! crc error?");

                    // Continue with searching for next valid frame in buffer
                    start = n + 1;
                    continue;
                }
                
                handleIncommingFrame(frame);
                start = n + 1;
            }
        }
        
        // Append not handled bytes to input buffer so we can handle 
        // them later together with some additional arrived data
        in_buffer = new ByteArray();
        if (start < tmp.length)
        {
			// FIXME vala does not like sth. like in_buffer.append(tmp[start:tmp.length]). Why?
			var tmp2 = tmp[start:tmp.length];
			in_buffer.append(tmp2);
		}
    }
    
    public void sendDataFrame(uint8[] data, int size)
    {
        Frame frame = new Frame();
        frame.fr_type = FrameType.DATA;
        
        frame.payload.append(data);
        logger.debug(@"send a DATA frame to modem (length = $(size))");
    
        transmission_handler.enequeFrame(frame);
    }
    
    public void sendFrame(Frame frame)
    {
        transmission_handler.enequeFrame(frame);
    }

    //
    // private API
    //
    
    private void configure()
    {
        context.window_size = (uint8) config.intValue("flowcontrol", "window_size", 8);
        context.max_send_attempts = (uint8) config.intValue("flowcontrol", "max_send_attempts", 10);
    }

    private void handleIncommingFrame(Frame frame)
    {
        logger.debug(@"Got a $(frameTypeToString(frame.fr_type)) frame from modem");

        foreach (AbstractLinkHandler handler in handlers)
        {
            // If the handler decides that no other handler should take a look at this
            // frame, we stop iterating over the last handlers.
            if (handler.handleFrame(frame))
            {   
                break;
            }
        }
    }
}

} // namespace Msmcomm
