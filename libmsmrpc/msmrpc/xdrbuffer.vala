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

namespace Msmrpc
{
    /**
     * XdrBuffer
     *
     * Base class for a xdr buffer. Implementations are InputXdrBuffer and
     * OutputXdrBuffer.
     **/
    public abstract class XdrBuffer : GLib.Object
    {
        protected const int BUFFER_MAX_SIZE = 2048;

        protected GLib.ByteArray buffer;
        protected uint32 buffer_next;
        protected uint32 buffer_length;

        public uint32 length { get { return buffer_length; } }
        public uint8[] data { get { return buffer.data; } }

        /**
         * Check if the supplied size is a multiply of four. If yes it returns true
         * otherwise false.
         **/
        protected bool is_aligned_size(uint32 size)
        {
            return (size & 0x3) > 0;
        }

        /**
         * Return the number of bytes needed to add to get a multiply of four for the
         * supplied size.
         **/
        protected uint32 get_align_size_offset(uint32 size)
        {
            return (4 - (size & 0x3));
        }

        /**
         * Reset everything. This means in detail that the internal buffer is cleared
         * and the counters are reset.
         **/
        protected void reset()
        {
            buffer = new GLib.ByteArray.sized(BUFFER_MAX_SIZE);
            buffer_next = 0;
            buffer_length = 0;
        }

        //
        // public API
        //

        /**
         * Set a amount of bytes as data for the buffer. This data has to be in xdr format
         * as it will not proessed in any other way than decoding. When calling this the
         * buffer will be reset first before the new data is set.
         **/
        public void fill(uint8[] data)
        {
            reset();
            buffer.append(data);
            buffer_length = buffer.len;
        }
    }

    /**
     * InputXdrBuffer
     *
     * This variant of the XdrBuffer is suitable when you receive data in the xdr format
     * and want to decode it.
     **/
    public class InputXdrBuffer : XdrBuffer
    {
        /**
         * Update all internal counters with the supplied size of processed bytes.
         **/
        private void update_counters(uint32 size)
        {
            buffer_next += size;
        }

        //
        // public API
        //

        public bool read_uint32(out uint32 value)
        {
            bool result = false;
            uint32 value_size = (uint32) sizeof(uint32);
            uint32 tmp = 0x0;

            if (buffer_next + value_size <= buffer.len)
            {
                Memory.copy(&tmp, ((uint8*) buffer.data) + buffer_next, value_size);
                value = Posix.ntohl(tmp);
                update_counters(value_size);
                result = true;
            }

            return result;
        }

        public bool read_int32(out int32 value)
        {
            uint32 tmp;
            bool result = false;

            result = read_uint32(out tmp);
            value = (int32) tmp;

            return result;
        }

        public bool read_uint16(out uint16 value)
        {
            uint32 tmp;
            bool result = false;

            result = read_uint32(out tmp);
            value = (uint16) tmp;

            return result;
        }

        public bool read_int16(out int16 value)
        {
            uint32 tmp;
            bool result = false;

            result = read_uint32(out tmp);
            value = (int16) tmp;

            return result;
        }

        public bool read_uint8(out uint8 value)
        {
            uint32 tmp;
            bool result = false;

            result = read_uint32(out tmp);
            value = (uint8) tmp;

            return result;
        }

        public bool read_int8(out int8 value)
        {
            uint32 tmp;
            bool result = false;

            result = read_uint32(out tmp);
            value = (int8) tmp;

            return result;
        }
    }

    /**
     * OutputXdrBuffer
     *
     * This variant of the XdrBuffer is suitable when you want to format data with xdr for
     * sending it over the network.
     **/
    public class OutputXdrBuffer : XdrBuffer
    {
        /**
         * Update all internal counters with the supplied size of processed bytes.
         **/
        private void update_counters(uint32 size)
        {
            buffer_next += size;
            buffer_length += size;
        }

        //
        // public API
        //

        construct
        {
            reset();
        }

        /**
         * Append a uint32 value to the buffer
         **/
        public bool write_uint32(uint32 value)
        {
            bool result = false;
            uint32 value_size = (uint32) sizeof(uint32);

            if (buffer_next + value_size < BUFFER_MAX_SIZE)
            {
                // NOTE: We need to pass a array of four bytes here to the byte array and
                // copy before the uint32 in it. Otherwise g_byte_array_append don't get
                // the correct number of bytes supplied.
                uint8[] bytes = new uint8[value_size];
                uint32 tmp = Posix.htonl(value);
                Memory.copy(bytes, &tmp, value_size);
                buffer.append(bytes);
                update_counters(value_size);
                result = true;
            }

            return result;
        }

        /**
         * Append a int32 value to the buffer
         **/
        public bool write_int32(int32 value)
        {
            return write_uint32((uint32) value);
        }

        /**
         * Append a uint16 value to the buffer
         **/
        public bool write_uint16(uint16 value)
        {
            return write_uint32((uint32) value);
        }

        /**
         * Append a int16 value to the buffer
         **/
        public bool write_int16(int16 value)
        {
            return write_uint32((uint32) value);
        }

        /**
         * Append a uint8 value to the buffer
         **/
        public bool write_uint8(uint8 value)
        {
            return write_uint32((uint32) value);
        }

        /**
         * Append a int8 value to the buffer
         **/
        public bool write_int8(int8 value)
        {
            return write_uint32((uint32) value);
        }

        /**
         * Append a set of bytes to the buffer
         **/
        public bool write_bytes(uint8[] bytes)
        {
            bool result = false;
            uint32 size = bytes.length;

            // be sure we have a aligned size (multiply of four)
            if (!is_aligned_size(size))
            {
                size += get_align_size_offset(size);
            }

            // respect four bytes for the size of the bytes
            size += (uint32) sizeof(uint32);

            if (buffer_next + size < BUFFER_MAX_SIZE)
            {
                // append the length of the bytes first
                uint8[] temp = new uint8[4];
                Memory.copy(temp, &bytes.length, 4);
                buffer.append(temp);

                // now append the bytes and add zeros to match the aligned size
                temp = new uint8[size-1];
                Memory.copy(temp, bytes, bytes.length);
                if(!is_aligned_size(bytes.length))
                {
                    Posix.memset(((uint8*) temp) + bytes.length, 0, get_align_size_offset(bytes.length));
                }

                buffer.append(temp);
                update_counters(size);

                result = true;
            }

            return result;
        }
    }
}
