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
    public abstract class AbstractLinkHandler
    {
        protected LinkContext context;
        protected FsoFramework.Logger logger;

        //
        // public API
        //

        public AbstractLinkHandler(LinkContext context)
        {
            this.context = context;
            this.logger = FsoFramework.theLogger;
        }
        
        public abstract bool handleFrame(Frame frame);
        public abstract void reset();

        //
        // private API
        //

        protected void sendFrame(Frame frame)
        {
            requestSendFrame(frame);
            frame.attempts++;
        }

        protected void prepareFrame(Frame frame, FrameType type)
        {
            if (type == FrameType.DATA || type == FrameType.ACK)
            {
                frame.ack = context.nextAcknowledgeNumber();
                
            }
            
            if (type == FrameType.DATA)
            {
                frame.seq = context.nextSequenceNumber();
            }
            
    
            // Handle different frame types
            if (type == FrameType.CONFIG_RESP)
            {
                frame.payload = new uint8[1];
                frame.payload[0] = 0x11;
            }
    
            
            frame.fr_type = type;
        }
    
        protected void prepareAndSendFrame(Frame frame, FrameType type)
        {
            prepareFrame(frame, type);
            requestSendFrame(frame);
        }

        protected void createAndSendFrame(FrameType type)
        {
            var frame = new Frame();
            prepareAndSendFrame(frame, type);
        }

        //
        // Signals
        //

        public signal void requestReset();
        public signal void requestSendFrame(Frame frame);
    }
} // namespace Msmcomm
