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
    public const uint8 DEFAULT_WINDOW_SIZE = 8;
    public const uint DEFAULT_MAX_SEND_ATTEMPTS = 10;

    public struct LinkLayerSettings
    {
        public uint8 window_size;
        public uint max_send_attempts;

        public LinkLayerSettings(uint8 window_size = DEFAULT_WINDOW_SIZE,
                                 uint max_send_attempts = DEFAULT_MAX_SEND_ATTEMPTS)
        {
            this.window_size = window_size;
            this.max_send_attempts = max_send_attempts;
        }
    }

    public class LinkLayerControl : ILinkControl, ITransmissionControl, GLib.Object
    {
        private LinkContext context;
        private Gee.ArrayList<AbstractLinkHandler> handlers;
        private TransmissionHandler transmission_handler;
        private ByteArray in_buffer;

        //
        // public API
        //

        public LinkLayerControl(LinkLayerSettings settings)
        {
            context = new LinkContext();
            context.stateChanged.connect(onStateChanged);

            Crc16.setup();

            handlers = new Gee.ArrayList<AbstractLinkHandler>();
            handlers.add(new SetupLinkHandler(context, this));
            handlers.add(new FlowControlHandler(context, this));
            handlers.add(new ActiveLinkHandler(context, this));

            transmission_handler = new TransmissionHandler(context, this);

            in_buffer = new ByteArray();

            configure(settings);
        }

        public void start()
        {
            debug("starting up the link layer");

            context.reset();
            foreach (AbstractLinkHandler handler in handlers)
            {
                handler.start();
            }
        }

        public void stop()
        {
            debug("shutting down the link layer");

            foreach (AbstractLinkHandler handler in handlers)
            {
                handler.stop();
            }
        }

        public void reset()
        {
            stop();
            start();
        }

        public void processIncomingData(uint8[] data)
        {
            uint start = 0;
            uint n = 0;

            in_buffer.append(data);

            var tmp = new uint8[in_buffer.len];
            Memory.copy(tmp, in_buffer.data, in_buffer.len);

            // try to find a valid frame within the incoming data
            foreach (var byte in tmp)
            {
                n++;

                // search for the frame end byte, if we found it then we
                // have found a valid frame
                if (byte == 0x7e)
                {
                    // We have found a valid frame, first unpack it 
                    var frame = new Frame();
                    // FIXME implement exception to get a better error handling
                    if (!frame.unpack(tmp[start:n]))
                    {
                        warning("processIncomingData: Could not unpack valid frame! crc error?");

                        // Continue with searching for next valid frame in buffer
                        start = n + 1;
                        continue;
                    }

                    handleIncomingFrame(frame);
                    start = n + 1;
                }
            }

            // Append not handled bytes to input buffer so we can handle 
            // them later together with some additional arrived data
            in_buffer = new ByteArray();
            if (start < tmp.length)
            {
                // FIXME vala does not like sth. like in_buffer.append(tmp[start:tmp.length]). Why?
                var tmp2 = tmp[start:tmp.length];
                in_buffer.append(tmp2);
            }
        }

        public void sendDataFrame(uint8[] data)
        {
            Frame frame = new Frame();
            frame.fr_type = FrameType.DATA;

            frame.payload.append(data);
            debug(@"send a DATA frame to modem (length = $(data.length))");

            transmission_handler.enequeFrame(frame);
        }

        public void sendAllFramesNow()
        {
            transmission_handler.waitForAllFramesAreSend();
        }

        public void sendFrame(Frame frame)
        {
            transmission_handler.enequeFrame(frame);
        }

        //
        // private API
        //

        private void onStateChanged(LinkStateType new_state)
        {
            if (new_state == LinkStateType.ACTIVE)
            {
                requestHandleLinkSetupComplete();
            }
        }

        private void configure(LinkLayerSettings settings)
        {
            context.window_size = settings.window_size;
            context.max_send_attempts = settings.max_send_attempts;
        }

        private void handleIncomingFrame(Frame frame)
        {
            debug(@"Got a $(frame.fr_type) frame from modem");

            foreach (AbstractLinkHandler handler in handlers)
            {
                // If the handler decides that no other handler should take a look at this
                // frame, we stop iterating over the last handlers.
                if (handler.handleFrame(frame))
                {
                    break;
                }
            }
        }
    }
} // namespace Msmcomm
