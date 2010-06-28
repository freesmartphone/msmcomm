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
    public class ActiveLinkHandler : AbstractLinkHandler
    {
        //
        // public API
        //

        public ActiveLinkHandler(LinkContext context, ILinkControl control)
        {
            base(context, control);
        }
        
        public override void reset()
        {
        }
        
        public override bool handleFrame(Frame frame)
        {
            bool frameHandled = false;

            switch (context.state)
            {
                case LinkStateType.ACTIVE:
                    if (frame.fr_type == FrameType.DATA)
                    {
                        // FIXME ack_handler.isSequenceNumberExpected(frame.seq)
                        // Our frame is not the frame with the expected sequence nr
                        //if (frame.seq != expected_seq)
                            // FIXME Should we really drop this frame?
                        //    return;

                        // in debug mode we should log the frame for bug
                        // hunting ...
                        logger.debug("receive data from modem (seq=0x%x, ack=0x%x)".printf(frame.seq, frame.ack));
                        logger.debug("payload is: FIXME");
                        // FIXME implement hexdump
                        // var data = frame.pack();
                        //hexdump(true, data, data.length, logger);

                        // we have new data for our registered data handlers
                        control.requestHandleFrameContent(frame.payload);
                        
                        frameHandled = true;
                    }
                    break;
                default:
                    logger.error("recieve frame in wrong state ... discard frame!");
                    break;
            }
            
            return frameHandled;
        }
    }
} // namespace Msmcomm

