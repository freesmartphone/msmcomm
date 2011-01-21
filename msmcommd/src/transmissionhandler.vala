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
 
namespace Msmcomm.Daemon
{
    public class TransmissionHandler 
    {
        private LinkContext context;
        private Gee.LinkedList<Frame> queue;
        private FsoFramework.Logger logger;
        private Timer timer;
        private ITransmissionControl control;

        // 
        // public API
        //

        public TransmissionHandler(LinkContext context, ITransmissionControl control)
        {
            this.context = context;
            this.control = control;
            logger = FsoFramework.theLogger;
            timer = new Timer();
            timer.interval = 50;
            timer.requestHandleEvent.connect(handleFrameTransmissionRequest);
            queue = new Gee.LinkedList<Frame>();
        }

        public void enequeFrame(Frame frame)
        {
            logger.debug(@"eneque $(frameTypeToString(frame.fr_type)) frame for sending");

            frame.attempts = 0;
            queue.add(frame);

            timer.start();
        }

        //
        // private API
        //

        private bool handleFrameTransmissionRequest(Timer timer)
        {
            foreach (Frame frame in queue)
            {
                // FIXME implement different exception for better error handling while
                // frame packing
                logger.debug(@"Send a $(frameTypeToString(frame.fr_type)) frame to modem");

                if (frame.fr_type == FrameType.DATA)
                {
                    frame.seq = context.nextSequenceNumber();
                    frame.ack = context.next_ack;
                }

                control.requestHandleSendData(frame.pack());
                frame.attempts++;

                if (frame.fr_type == FrameType.DATA)
                {
                    // Current frame is a DATA frame and should be acked by the
                    // other side, so we add it to the ack queue and start the
                    // ack timer
                    context.ack_queue.add(frame);
                    context.ack_timer.start();
                }
            }

            queue.clear();

            return false;
        }
    }
} // namespace Msmcomm
