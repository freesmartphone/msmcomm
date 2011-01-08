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

        private void *_payload;
        private ulong _payload_size;

        construct
        {
            this.group_id = group_id;
            this.message_id = message_id;
            this.message_type = message_type;
        }

        public uint8[] pack()
        {
            uint8[] buffer = new uint8[_payload_size];

            prepare_data();
            Memory.copy(buffer, _payload, _payload_size);

            return buffer;
        }

        public void unpack(void *data, int size)
        {
            assert(size == _payload_size);
            assert(_payload != null);

            Memory.copy(_payload, data, size);
            evaluate_data();
        }

        protected virtual void evaluate_data()
        {
        }

        protected virtual void prepare_data()
        {
        }

        protected void set_payload(void *payload, ulong payload_size)
        {
            _payload = payload;
            _payload_size = payload_size;
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
