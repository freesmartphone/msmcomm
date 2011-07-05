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
 
namespace Msmcomm.HciLinkLayer
{
    public class FlowControlHandler : AbstractLinkHandler
    {
        // 
        // public API
        //

        public FlowControlHandler(LinkContext context, ILinkControl control)
        {
            base(context, control);
            
            context.ack_timer.requestHandleEvent.connect(handleAckTimerEvent);
        }

        public override void stop()
        {
            context.ack_queue.clear();
            context.ack_timer.stop();
        }
        
        public override bool handleFrame(Frame frame)
        {
            int count = 0;
            bool frameHandled = false;
            
            if (context.state == LinkStateType.ACTIVE && 
                (frame.fr_type == FrameType.ACK || frame.fr_type == FrameType.DATA))
            {
                // handle both type of frames which includes a acknowledge number
                // in a different way
                if (frame.fr_type == FrameType.ACK)
                {
                    debug("Recieve ACK frame in ACTIVE state => frame handled!");
                    frameHandled = true;
                }
                else if (frame.fr_type == FrameType.DATA)
                {
                    // We should even check if the sequence number of this
                    // data frame is the one we expect to be send from the modem
                    if (frame.seq != context.expected_seq)
                    {
                        // Drop this frame!
                        return true;
                    }
                    
                    // ack the recieved frame so the modem knows we recieved the 
                    // frame, but only if the frame is valid otherwise we drop it
                    if (frame.crc_result)
                    {
                        var fr = new Frame();
                        fr.fr_type = FrameType.ACK;
                        fr.ack = context.nextAcknowledgeNumber();
                        sendFrame(fr);
                        
                        context.expected_seq = fr.ack;
                    }
                    else 
                    {
                        return true;
                    }
                }
                
                //
                // below we do several things, which are the same for every frame
                // which includes a acknowledge number
                //

                // count of frames which are not acknowledged should be less or equal than
                // the max window size
                if (context.ack_queue.size > context.window_size)
                {
                    debug("Resending all frames stored in ack queue cause ack_queue.size > window_size");
                    var framesToRemove = new Gee.ArrayList<Frame>();
                    foreach (Frame fr in context.ack_queue)
                    {
                        if (count == context.window_size)
                            break;
                        
                        framesToRemove.add(fr);
                        sendFrame(fr);
                        count++;
                    }
                    
                    foreach (Frame fr in framesToRemove)
                    {
                        context.ack_queue.remove(fr);
                    }
                }

                // check which frames are acknowledged with this ack and mark
                // them for a later remove
                debug(@"FlowControlHandler: check which frames are acknowledged with this ack");
                debug(@"ack_queue.size = $(context.ack_queue.size)");
                var framesToRemove = new Gee.ArrayList<Frame>();
                foreach (Frame fr in context.ack_queue)
                {
                    debug(@"last_ack = $(context.last_ack) fr.seq = $(fr.seq) frame.ack = $(frame.ack)");
                    if (!isValidAcknowledge(context.last_ack, fr.seq, frame.ack)) 
                    {
                        break;
                    }

                    debug("Found frame which is aknowledged with this ack");
                    framesToRemove.add(fr);
                }

                debug(@"framesToRemove.size $(framesToRemove.size)");
                context.ack_queue.remove_all(framesToRemove);

                // check wether ack queue is empty. If it is empty, stop the
                // ack timer as we recieve a acknowledge for every frame we 
                // waiting for one
                if (context.ack_queue.size == 0)
                {
                    context.ack_timer.stop();
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
            debug("ack timer event occured => resend all frames in ack queue");

            // ack timer event occured, so one or more frames are not acknowledged
            // in time, so we have to resend these frames
            var framesToRemove = new Gee.ArrayList<Frame>();
            foreach (Frame frame in context.ack_queue)
            {
                sendFrame(frame);

                // Remove frame from ack queue, send frame logic will add it again later
                framesToRemove.add(frame);
            }

            context.ack_queue.remove_all(framesToRemove);

            // Reschedule ack timer as we are still waiting for the right acknowledge
            // FIXME Currently the ack timer is running as long as someone stops it

            return true;
        }
    }
} // namespace Msmcomm
