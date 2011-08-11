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

namespace Msmcomm.HpVeer
{
    public static const uint16 COMMAND_ID_INVALID = 0xffff;
    public static const uint32 REFERENCE_ID_INITIAL = 1;
    public static const uint32 REFERENCE_ID_INVALID = 0;

    public static const int HCI_MESSAGE_HEADER_SIZE = 24;

    public abstract class Message : Common.BaseMessage
    {
        public uint32 sequence_nr;
        public uint32 ref_id;
        public uint32 subsys_id;
        public uint32 command_id;
        public uint32 unknown0;
        public uint32 unknown1;

        protected unowned uint8[] _payload;

        public static bool validate_size(uint8[] data)
        {
            return (data.length >= HCI_MESSAGE_HEADER_SIZE);
        }

        public override uint8[] pack()
        {
            var buffer = new FsoFramework.BinBuilder();
            prepare_data();

            buffer.append_uint32(sequence_nr);
            buffer.append_uint32(ref_id);
            buffer.append_uint32(subsys_id);
            buffer.append_uint32(command_id);
            buffer.append_uint32(unknown0);
            buffer.append_uint32(unknown1);
            buffer.append_data(_payload);

            return buffer.data;
        }

        protected virtual void prepare_data() { }

        protected virtual bool check_size(int size, int payload_size)
        {
            assert( logger.debug(@"size = $size, payload_size = $payload_size") );
            return (size == payload_size);
        }

        public override bool unpack(uint8[] data)
        {
            if (validate_size(data) || !check_size(data.length - HCI_MESSAGE_HEADER_SIZE, _payload.length))
                return false;

            try
            {
                var buffer = new FsoFramework.BinReader(data);
                sequence_nr = buffer.get_uint32(0);
                ref_id = buffer.get_uint32(4);
                subsys_id = buffer.get_uint32(8);
                command_id = buffer.get_uint32(12);
                unknown0 = buffer.get_uint32(16);
                unknown1 = buffer.get_uint32(20);
            }
            catch (GLib.Error error)
            {
                return false;
            }

            Memory.copy(_payload, data[HCI_MESSAGE_HEADER_SIZE:data.length], _payload.length);

            evaluate_data();

            return true;
        }

        protected virtual void evaluate_data() { }

        protected void set_payload(uint8[] payload)
        {
            _payload = payload;
        }
    }
}
