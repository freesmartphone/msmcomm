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
 
using GLib;

namespace Msmcomm.HciLinkLayer
{
    public enum FrameType
    {
        SYNC = 0x1,
        SYNC_RESP = 0x2,
        CONFIG = 0x3,
        CONFIG_RESP = 0x4,
        ACK = 0x5,
        DATA = 0x6,
    }

    /**
    * @class Msmcomm.HciLinkLayer.Frame
    **/
    public class Frame
    {
        private ByteArray _payload;
        private const int CRC_MAGIC = 0xf0b8;

        public uint8 addr { get; set; default = 0xfa; }
        public uint8 seq { set; get; default = 0x0; }
        public uint8 ack { set; get; default = 0x0; }
        public uint16 crc { set; get; }
        public FrameType fr_type { set; get; }
        public uint8 flags { get; set; default = 0x0; }
        public ByteArray payload { get { return _payload; } }
        public uint attempts { get; set; default = 0; }
        public bool crc_result { get; set; default = true; }

        public Frame()
        {
            _payload = new ByteArray();
        }

        /**
        * Replace all occurences of 0x7d and 0x7e in the byte array with
        * 0x7d 0x5d resp. 0x7d 0x5e.
        *
        * @return byte array with encoded data
        **/
        private void encode(GLib.ByteArray buffer)
        {
            var data = buffer.data;

            buffer.remove_range(0, buffer.len);

            foreach (uint8 byte in data)
            {
                if (byte == 0x7d)
                {
                    buffer.append(new uint8[] { 0x7d, 0x5d });
                }
                else if (byte == 0x7e)
                {
                    buffer.append(new uint8[] { 0x7d, 0x5e });
                }
                else
                {
                    buffer.append(new uint8[] { byte });
                }
            }
        }

        /**
        * Replace all occurences of 0x7d 0x5d or 0x7d 0x5e in the byte array
        * with 0x7d resp. 0x7e.
        *
        * @return byte array with decoded data
        **/
        private void decode(GLib.ByteArray buffer)
        {
            var data = buffer.data;
            uint n = 0;
            bool not_add_next = false;

            buffer.remove_range(0, buffer.len);

            foreach (uint8 byte in data)
            {
                if (not_add_next)
                {
                    not_add_next = false;
                    n++;
                    continue;
                }

                if (byte == 0x7d && (n+1 < data.length && data[n+1] == 0x5d))
                {
                    buffer.append(new uint8[] { 0x7d });
                    not_add_next = true;
                }
                else if (byte == 0x7d && (n+1 < data.length && data[n+1] == 0x5e))
                {
                    buffer.append(new uint8[] { 0x7e });
                    not_add_next = true;
                }
                else
                {
                    buffer.append(new uint8[] { byte });
                }

                n++;
            }
        }

        /**
        * Pack all frame properties into a byte array for additional
        * processing
        *
        * @return the packed byte array for the frame
        **/
        // FIXME add better error handling through different exceptions
        public uint8[] pack()
        {
            var buffer = new GLib.ByteArray.sized(3 + payload.len + 2 + 1);
            uint16 crc = 0x0;

            // create header for this frame
            var header = new uint8[3];
            header[0] = addr;
            header[1] = (((uint8) fr_type) << 4) | flags;
            header[2] = (seq << 4) | ack;
            buffer.append(header);

            // append payload
            if (payload.len > 0)
            {
                buffer.append(payload.data);
            }

            // compute and append crc checksum
            uint8[] tmp = buffer.data;

            crc = Crc16.calculate(tmp);
            crc ^= 0xffff;
            // FIXME find a better way to add the crc to the byte array ... this one is ugly ...
            buffer.append(new uint8[] { (uint8)(crc & 0xff), (uint8)((crc & 0xff00) >> 8) });

            // encode frame data and add trailing frame byte
            encode(buffer);
            buffer.append(new uint8[] { 0x7e });

            return buffer.data;
        }

        /**
        * Unpack a frame from a byte array
        **/
        public bool unpack(uint8[] data)
        {
            uint16 crc = 0x0;

            // check data length, should be a least the header + crc + end byte
            if (data.length < 5)
            {
                return false;
            }

            // decode frame data first!
            var buffer = new GLib.ByteArray();
            buffer.append(data);

            decode(buffer);

            // calculate crc16 checksum
            crc = Crc16.calculate(buffer.data[0:buffer.len-1]);
            if (crc != CRC_MAGIC)
            {
                this.crc_result = false;
                return false;
            }

            // fill header properties from data
            addr = data[0];
            fr_type = (FrameType) ((buffer.data[1] & 0xf0) >> 4);
            flags = buffer.data[1] & 0x0f;
            seq = (buffer.data[2] & 0xf0) >> 4;
            ack = buffer.data[2] & 0x0f;

            if (buffer.len > 5)
            {
                var tmp = new uint8[buffer.len-6];
                Memory.copy(tmp, buffer.data[3:buffer.len-6], buffer.len-6);
                payload.append(tmp);
            }

            return true;
        }
    }
} // namespace Msmcomm.HciLinkLayer
