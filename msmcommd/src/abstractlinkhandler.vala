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
        protected ILinkControl control;
        protected FsoFramework.Logger logger;

        //
        // public API
        //

        public AbstractLinkHandler(LinkContext context, ILinkControl control)
        {
            this.context = context;
            this.control = control;
            this.logger = FsoFramework.theLogger;
        }
        
        public abstract bool handleFrame(Frame frame);
        
        public virtual void reset()
        {
            stop();
            start();
        }
        
        public virtual void start()
        {
        }
        
        public virtual void stop()
        {
        }

        //
        // private API
        //
        
        protected void requestLinkReset()
        {
            control.reset();
        }

        protected void requestModemReset()
        {
            control.requestModemReset();
        }

        protected void sendFrame(Frame frame)
        {
            control.sendFrame(frame);
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
                frame.payload.append(new uint8[] { 0x11 });
            }
    
            
            frame.fr_type = type;
        }
    
        protected void prepareAndSendFrame(Frame frame, FrameType type)
        {
            prepareFrame(frame, type);
            control.sendFrame(frame);
        }

        protected void createAndSendFrame(FrameType type)
        {
            var frame = new Frame();
            prepareAndSendFrame(frame, type);
        }
    }
} // namespace Msmcomm
