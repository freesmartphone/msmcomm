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

        public FlowControlHandler(LinkContext context)
        {
            base(context);
            
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
            
            if (context.state != LinkStateType.ACTIVE)
                return false;
            
            if (frame.fr_type == FrameType.ACK)
                frameHandled = true;

            // FIXME move this to ack_timer_cb as we only should handle acknowledging of
            // frames and not resending them!

            // count of frames which are not acknowledged should be less or equal than
            // the max window size
            if (context.ack_queue.size > context.window_size)
            {
                /* resend and remove them from ack_queue */
                foreach (Frame fr in context.ack_queue)
                {
                    if (count == context.window_size)
                        break;

                    context.ack_queue.remove(fr);
                    requestSendFrame(fr);
                    
                    count++;
                }
            }

            // check which frames are acknowledged with this ack
            foreach (Frame fr in context.ack_queue)
            {
                if (!isValidAcknowledge(context.last_ack, fr.seq, frame.ack))
                    break;
                
                // FIXME we should not change ack_queue content while
                // iterating over it ...
                context.ack_queue.remove(fr);
            }

            if (context.ack_queue.size == 0)
            {
                 // ack_queue is empty so stop ack timer
                timer.stop();
            }

            context.last_ack = frame.ack;
            
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
                requestSendFrame(frame);
                
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
