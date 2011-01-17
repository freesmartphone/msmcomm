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

namespace Msmcomm.LowLevel
{
    public abstract class BaseMessage : GLib.Object
    {
        public uint8 group_id { get; set;  }
        public uint16 message_id { get; set; }
        public uint32 ref_id { get; set; default = 0x0; }
        public MessageType message_type { get; set; }
        public MessageResultType result { get; protected set; default = MessageResultType.RESULT_OK; }
        public MessageClass message_class { get; protected set; default = MessageClass.UNKNOWN; }

        private uint8[] _payload;

        public uint8[] pack()
        {
            prepare_data();
            return _payload;
        }

        public void unpack(uint8[] data)
        {
            check_size(data.length, (int) _payload.length);
            _payload = data;
            evaluate_data();
        }

        protected virtual void check_size(int size, int payload_size)
        {
            assert(size == payload_size);
        }

        protected virtual void evaluate_data()
        {
        }

        protected virtual void prepare_data()
        {
        }

        protected void set_payload(uint8[] payload)
        {
            _payload = payload;
        }

        protected void set_description(uint8 group_id, uint16 message_id, MessageType message_type, MessageClass message_class)
        {
            this.group_id = group_id;
            this.message_id = message_id;
            this.message_type = message_type;
            this.message_class = message_class;
        }

    }
}
