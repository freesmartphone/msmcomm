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

        public override uint8[] pack()
        {
            prepare_data();
            return _payload;
        }

        protected virtual void prepare_data()
        {
        }

        protected virtual void check_size(int size, int payload_size)
        {
            debug(@"size = $size, payload_size = $payload_size");
            assert(size == payload_size);
        }

        public override void unpack(uint8[] payload)
        {
            check_size(payload.length, _payload.length);
            Memory.copy(_payload, payload, _payload.length);
            evaluate_data();
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
