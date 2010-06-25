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

public class LinkLayerControl : GLib.Object
{
    private FsoFramework.Logger logger;
    private LinkContext context;
    private Gee.ArrayList<AbstractLinkHandler> handlers;
    private TransmissionHandler transmission_handler;

    //
    // public API
    //

    public LinkLayerControl()
    {
        logger = FsoFramework.theLogger;
        context = new LinkContext();

        Crc16.setup();
        
        handlers = new Gee.ArrayList<AbstractLinkHandler>();
        appendAndPrepareLinkHandler(new SetupLinkHandler(context));
        appendAndPrepareLinkHandler(new FlowControlHandler(context));
        appendAndPrepareLinkHandler(new ActiveLinkHandler(context));
        
        transmission_handler = new TransmissionHandler(context);
    }

    public void reset()
    {
        context.reset();
        
        foreach (AbstractLinkHandler handler in handlers)
        {
            handler.reset();
        }
    }

    public void processIncommingData(uint8[] data)
    {
        uint n = 0;
        uint start = 0;
        
        logger.debug("Start to search for a valid frame in incomming data ...");

        // try to find a valid frame within the incomming data
        foreach (uint8 byte in data)
        {
            n++;
            // search for the frame end byte, if we found it then we
            // have found a valid frame
            if (byte == 0x7e)
            {
                logger.debug("Yeah, found a valid frame !!!");

                var tmp = data[start:n];
                hexdump(false, tmp, tmp.length, FsoFramework.theLogger);
                
                // We have found a valid frame, first unpack it 
                var frame = new Frame();
                // FIXME implement exception to get a better error handling
                if (!frame.unpack(data[start:n]))
                {
                    logger.error("Could not unpack valid frame frame! crc error?");

                    // Continue with searching for next valid frame in buffer
                    start = n + 1;
                    continue;
                }

                handleIncommingFrame(frame);
                start = n + 1;
            }
        }
    }

    //
    // private API
    //

    private void handleIncommingFrame(Frame frame)
    {
        logger.debug(@"Got new new $(frameTypeToString(frame.fr_type)) frame");

        foreach (AbstractLinkHandler handler in handlers)
        {
            // If the handler decides that no other handler should take a look at this
            // frame, we stop iterating over the last handlers.
            if (handler.handleFrame(frame))
                break;
        }
    }
    
    private void appendAndPrepareLinkHandler(AbstractLinkHandler handler)
    {
        handler.requestSendFrame.connect(handleFrameSendRequest);
        handler.requestReset.connect(handleResetRequest);
    }
    
    private void handleFrameSendRequest(Frame frame)
    {
        transmission_handler.enequeFrame(frame);
    }
    
    private void handleResetRequest()
    {
        reset();
    }

    //
    // Signals
    //

    public signal void handleDataSendRequest(uint8[] data);
    public signal void handleFrameContent(uint8[] data);
}

} // namespace Msmcomm
