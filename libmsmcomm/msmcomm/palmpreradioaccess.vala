/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

using Msmcomm.HciLinkLayer;

namespace Msmcomm
{
    public const uint READ_BUFFER_SIZE = 4096;

    public class PalmPre.RadioAccess : BaseRadioAccess
    {
        private LinkLayerControl llctrl;
        private bool active;
        private bool in_link_setup;
        private GLib.ByteArray inbuffer;

        public PalmPre.CommandQueue commandqueue { get; private set; }

        //
        // private
        //

        private void handle_transport_read(FsoFramework.Transport t)
        {
            int bread = 0;
            uint8[] data = new uint8[READ_BUFFER_SIZE];

            bread = t.read(data, data.length);
            llctrl.processIncomingData(data[0:bread]);
        }

        private void handle_transport_hangup(FsoFramework.Transport t)
        {
            logger.error("[HUP] modem transport closed from remote side");
        }

        private void handle_frame_content(uint8[] data)
        {
            if (!in_link_setup && active)
                incoming_data(data);
        }

        private void handle_send_data(uint8[] data)
        {
            if (in_link_setup || active)
            {
                transport.write(data, data.length);
            }
            else
            {
                logger.debug("Could not send data to remote side as we are not in active mode!");
                return;
            }
        }

        private void handle_modem_reset_request()
        {
            llctrl.stop();
            transport.close();
            transport.open();
            llctrl.start();
        }

        //
        // signals
        //

        public signal void setup_complete();

        //
        // public API
        //

        public RadioAccess(FsoFramework.BaseTransport transport)
        {
            base(transport);
            in_link_setup = false;
            inbuffer = new GLib.ByteArray();
            commandqueue = new PalmPre.CommandQueue(this);
        }

        public override async bool open()
        {
            assert( logger.debug(@"Initializing palmpre radio access ...") );

            transport.setDelegates(handle_transport_read, handle_transport_hangup);
            if (!transport.isOpen())
                transport.open();

            var settings = LinkLayerSettings();
            settings.window_size = (uint8) config.intValue("hll", "window_size", 8);
            settings.max_send_attempts = config.intValue("hll", "max_send_attempts", 10);

            assert( logger.debug(@"Configuring hll with window_size = $(settings.window_size)"
                + @", max_send_attempts = $(settings.max_send_attempts)") );

            in_link_setup = true;
            llctrl = new LinkLayerControl(settings);
            llctrl.requestHandleSendData.connect(handle_send_data);
            llctrl.requestHandleFrameContent.connect(handle_frame_content);
            llctrl.requestModemReset.connect(handle_modem_reset_request);
            llctrl.requestHandleLinkSetupComplete.connect(() => {
                in_link_setup = false;
                active = true;
                // tell all clients that link setup method has finished
                Idle.add(() => { setup_complete(); return false; });
            });

            llctrl.start();

            return true;
        }

        public override void close()
        {
            if (transport.isOpen())
                transport.close();
        }

        public override bool is_active()
        {
            return active;
        }

        public override async void send(uint8[] data)
        {
            if (!in_link_setup && active)
                llctrl.sendDataFrame(data);
        }

        public override async bool suspend()
        {
            if (!active)
            {
                assert( logger.debug(@"We're not active so we don't need to suspend") );
                return false;
            }

            if (base.is_locked())
                return false;

            // Ok, as now all pending messages are send to the modem, we can go into
            // suspend state.
            active = false;
            llctrl.sendAllFramesNow();
            llctrl.stop();
            transport.flush();
            transport.freeze();
            transport.suspend();

            return true;
        }

        public override async void resume()
        {
            transport.resume();
            in_link_setup = true;
            transport.thaw();
            llctrl.start();
        }
    }
}
