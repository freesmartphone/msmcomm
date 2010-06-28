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
    public class FlowControlHandler : AbstractLinkHandler
    {
        private Timer timer;

        // 
        // public API
        //

        public FlowControlHandler(LinkContext context, ILinkControl control)
        {
            base(context, control);
            
            timer = new Timer();
            timer.interval = 1000;
            timer.requestHandleEvent.connect(handleAckTimerEvent);
        }

        public override void reset()
        {
            context.ack_queue.clear();
            timer.stop();
        }
        
        public override bool handleFrame(Frame frame)
        {
            int count = 0;
            bool frameHandled = false;
            
            if (context.state == LinkStateType.ACTIVE && 
                frame.fr_type == FrameType.ACK || frame.fr_type == FrameType.DATA)
            {
                // handle both type of frames which includes a acknowledge number
                // in a different way
                if (frame.fr_type == FrameType.ACK)
                {
                    frameHandled = true;
                }
                else if (frame.fr_type == FrameType.DATA)
                {
                    // We got a DATA frame which we be add to the ack_queue by the
                    // ActiveLinkHandler later, we will start the ack timer for it
                    timer.start();
                    
                    // We should even check if the sequence number of this
                    // data frame is the one we expect to be send from the modem
                    if (frame.seq != context.expected_seq)
                    {
                        // Drop this frame!
                        return true;
                    }
                }
                
                // below we do several things, which are the same for every frame
                // which includes a acknowledge number

                // count of frames which are not acknowledged should be less or equal than
                // the max window size
                if (context.ack_queue.size > context.window_size)
                {
                    var framesToRemove = new Gee.ArrayList<Frame>();
                    foreach (Frame fr in context.ack_queue)
                    {
                        if (count == context.window_size)
                            break;
                        
                        framesToRemove.add(fr);
                        sendFrame(fr);
                        count++;
                    }
                    context.ack_queue.remove_all(framesToRemove);
                }

                // check which frames are acknowledged with this ack and mark
                // them for a later remove
                var framesToRemove = new Gee.ArrayList<Frame>();
                foreach (Frame fr in context.ack_queue)
                {
                    if (!isValidAcknowledge(context.last_ack, fr.seq, frame.ack))
                        break;
                    
                    framesToRemove.add(frame);
                }
                context.ack_queue.remove_all(framesToRemove);

                // check wether ack queue is empty. If it is empty, stop the
                // ack timer as we recieve a acknowledge for every frame we 
                // waiting for one
                if (context.ack_queue.size == 0)
                {
                    timer.stop();
                }

                // set current frame ack number as the last one we handled
                context.last_ack = frame.ack;
            }
            
            return frameHandled;
        }

        // 
        // private API
        //
        
        private bool isValidAcknowledge(uint8 a, uint8 b, uint8 c)
        {
            // same as: a <= b < c (modulo)
            return (((a <= b) && (b < c)) || ((c < a) && (a <= b)) || ((b < c) && (c < a)));
        }

        private bool handleAckTimerEvent()
        {
            // ack timer event occured, so one or more frames are not acknowledged
            // in time, so we have to resend these frames
            foreach (Frame frame in context.ack_queue)
            {
                sendFrame(frame);
                
                // Remove frame from ack queue, send frame logic will add it again later
                // FIXME we should not change ack_queue content while
                // iterating over it ...
                context.ack_queue.remove(frame);
            }

            // Reschedule ack timer as we are still waiting for the right acknowledge
            // FIXME Currently the ack timer is running as long as someone stops it
            return true;
        }
    }
     
} // namespace Msmcomm
