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
    public class SetupLinkHandler : AbstractLinkHandler
    {
        private Timer sync_timer;
        private const uint MAX_SYNC_RETRIES = 10;

        //
        // private API
        //

        private bool syncTimerCallback(Timer timer)
        {
            if (context.state != LinkStateType.NULL)
            {
                return false;
            }

            // If the timer overlaps more than we expected it to do than we tell the modem
            // control layer to reset the modem and start again
            if (timer.occurence > MAX_SYNC_RETRIES)
            {
                requestModemReset();
            }

            createAndSendFrame(FrameType.SYNC); 
            return true;
        }

        // 
        // public API
        //

        public SetupLinkHandler(LinkContext context, ILinkControl control)
        {
            base(context, control);

            sync_timer = new Timer();
            sync_timer.interval = 1000;
            sync_timer.requestHandleEvent.connect(syncTimerCallback);
        }

        public override void stop()
        {
            sync_timer.stop();
        }

        public override void start()
        {
            sync_timer.start();
        }

        public override bool handleFrame(Frame frame)
        {
            bool frameHandled = true;

            debug(@"received $(frameTypeToString(frame.fr_type)) frame");

            switch (context.state)
            {
                case LinkStateType.NULL:
                    if (frame.fr_type == FrameType.SYNC)
                    {
                        createAndSendFrame(FrameType.SYNC_RESP);
                    }
                    else if (frame.fr_type == FrameType.SYNC_RESP)
                    {
                        context.changeState(LinkStateType.INIT);
                        createAndSendFrame(FrameType.CONFIG);
                        sync_timer.stop();
                    }
                    break;
                case LinkStateType.INIT:
                    if (frame.fr_type == FrameType.SYNC)
                    {
                        createAndSendFrame(FrameType.SYNC_RESP);
                    }
                    else if (frame.fr_type == FrameType.CONFIG)
                    {
                        createAndSendFrame(FrameType.CONFIG_RESP);
                    }
                    else if (frame.fr_type == FrameType.CONFIG_RESP)
                    {
                        context.changeState(LinkStateType.ACTIVE);
                    }
                    else
                    {
                        debug(@"recieve $(frameTypeToString(frame.fr_type)) frame in $(linkStateTypeToString(context.state)) state ... discard frame!");
                    }
                    break;
                case LinkStateType.ACTIVE:
                    if (frame.fr_type == FrameType.SYNC)
                    {
                        debug("got SYNC FRAME in ACTIVE state -> restart link!");
                        // The spec tolds us to restart the whole stack if we receive
                        // a sync message in ACTIVE state
                        requestLinkReset();
                    }
                    else if (frame.fr_type == FrameType.CONFIG)
                    {
                        // If we receive a CONFIG message in ACTIVE state we send out a
                        // CONFIG RESP with our currrent configuration settings
                        // FIXME how to include current configuration settings?
                        createAndSendFrame(FrameType.CONFIG_RESP);
                    }
                    else
                    {
                        debug(@"SetupLinkHandler: recieve $(frameTypeToString(frame.fr_type)) frame in ACTIVE state ... discarding frame!");
                        frameHandled = false;
                    }
                    break;
                default:
                    warning("arrived in invalid state ... assuming restart!");
                    requestLinkReset();
                    break;
            }

            return frameHandled;
        }
    }
}
