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

using Msmcomm.Common;

namespace Msmcomm
{
    public struct HpVeer.HciHeader
    {
        public uint32 sequence_nr;
        public uint32 ref_id;
        public uint32 subsys_id;
        public uint32 command_id;
        public uint32 unknown0;
        public uint32 unknown1;
    }

    public class HpVeer.RadioAccess : BaseRadioAccess
    {
        private Msmrpc.OemRapiClient oemrapi;

        //
        // private
        //

        private bool handle_hci_events(uint8[] data)
        {
            return true;
        }

        //
        // public API
        //

        public RadioAccess(FsoFramework.BaseTransport transport)
        {
            base(transport);
            oemrapi = new Msmrpc.OemRapiClient(transport);
        }

        public override async bool open()
        {
            oemrapi.initialize();

            // NOTE we need to send this command to be able to retrieve remote calls also
            // known as hci events
            yield oemrapi.send(new uint8[] {}, Msmrpc.OEM_RAPI_EVENT_HCI_EVENT, (uint32) 0x2de98);

            return true;
        }

        public override void close()
        {
            oemrapi.shutdown();
        }

        public override async void send(BaseMessage message)
        {
        }

        public override async bool suspend()
        {
            return true;
        }

        public override async void resume()
        {
        }

        public override bool is_active()
        {
            return false;
        }

        public override string repr()
        {
            return @"<>";
        }
    }
}
