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
    public class TransmissionHandler 
    {
        private LinkContext context;
        private Gee.LinkedList<Frame> queue;
        private FsoFramework.Logger logger;
        private Timer timer;
        
        // 
        // public API
        //
        
        public TransmissionHandler(LinkContext context)
        {
            this.context = context;
            logger = FsoFramework.theLogger;
            timer = new Timer();
            timer.interval = 50;
            timer.requestHandleEvent.connect(handleFrameTransmissionRequest);
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
                requestSendData(frame.pack());
                queue.remove(frame);
                context.ack_queue.add(frame);
            }
            
            return false;
        }
        
        //
        // Signals
        //
        
        public signal void requestSendData(uint8[] data);
    }

} // namespace Msmcomm
