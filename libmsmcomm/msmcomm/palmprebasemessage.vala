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

namespace Msmcomm.PalmPre
{
    public static const uint16 COMMAND_ID_INVALID = 0xffff;
    public static const uint32 REFERENCE_ID_INITIAL = 1;
    public static const uint32 REFERENCE_ID_INVALID = 0;

    public abstract class Message : Common.BaseMessage
    {
        public uint8 group_id { get; set;  }
        public uint16 message_id { get; set; }
        public uint32 ref_id { get; set; default = REFERENCE_ID_INVALID; }
        public uint16 command_id { get; set; default = COMMAND_ID_INVALID; }
        public MessageType message_type { get; set; }
        public MessageResult result { get; protected set; default = MessageResult.OK; }
        public MessageFlavour message_class { get; protected set; default = MessageFlavour.UNKNOWN; }

        protected unowned uint8[] _payload;

        public static bool validate_size(uint8[] data)
        {
            return (data.length >= MESSAGE_HEADER_SIZE);
        }

        public static uint8 unpack_group_id(uint8[] data)
        {
            return data[0];
        }

        public static uint16 unpack_message_id(uint8[] data)
        {
            return (data[1] | (data[2] << 8));
        }

        public override uint8[] pack()
        {
            uint8[] buffer;

            prepare_data();

            buffer = new uint8[MESSAGE_HEADER_SIZE + _payload.length];

            // append group and message id to the buffer
            buffer[0] = group_id;
            buffer[1] = (uint8) (message_id & 0x00ff);
            buffer[2] = (uint8) ((message_id & 0xff00) >> 8);

            // append message payload to the buffer
            Memory.copy(((uint8*) buffer) + 3, _payload, _payload.length);

            return buffer;
        }

        protected virtual void prepare_data()
        {
        }

        protected virtual bool check_size(int size, int payload_size)
        {
            assert( logger.debug(@"size = $size, payload_size = $payload_size") );
            return (size == payload_size);
        }

        public override bool unpack(uint8[] data)
        {
            if (validate_size(data) || !check_size(data.length - MESSAGE_HEADER_SIZE, _payload.length))
                return false;

            group_id = unpack_group_id(data);
            message_id = unpack_message_id(data);

            Memory.copy(_payload, data[MESSAGE_HEADER_SIZE:data.length], _payload.length);

            evaluate_data();

            return true;
        }

        protected virtual void evaluate_data()
        {
        }

        protected void set_payload(uint8[] payload)
        {
            _payload = payload;
        }

        protected void set_description(uint8 group_id, uint16 message_id, MessageType message_type, MessageFlavour message_class)
        {
            this.group_id = group_id;
            this.message_id = message_id;
            this.message_type = message_type;
            this.message_class = message_class;
        }
    }
}
