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
    public delegate bool XdrBufferWriteCb(OutputXdrBuffer buffer, void *data);
    public delegate bool XdrBufferReadCb(InputXdrBuffer buffer, void *data);

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

        public uint32 length { get { return buffer.len; } }
        public uint8[] data { get { return buffer.data; } }

        /**
         * Check if the supplied size is a multiply of four. If yes it returns true
         * otherwise false.
         **/
        protected bool is_aligned_size(uint32 size)
        {
            return (size & 0x3) == 0;
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

        /**
         * Retrieve all bytes from current read position to the end of the buffer.
         **/
        public bool retrive_remaining_data(out uint8[] data)
        {
            uint32 size = buffer.len - buffer_next;
            bool result = false;

            if (size > 0 )
            {
                data = new uint8[size];
                Memory.copy(&data, ((uint8*) buffer.data) + buffer_next, size);
                result = true;
            }

            return result;
        }

        /**
         * Skip a specified number of bytes in buffer.
         **/
        public void skip(uint num)
        {
            if (buffer_next + num <= buffer.len)
                update_counters(num);
        }

        /**
         * Reset internal read position to the beginning.
         **/
        public void rewind()
        {
            buffer_next = 0;
        }

        /**
         * Read a uint32 value from the buffer
         **/
        public bool read_uint32(out uint32 value)
        {
            bool result = false;
            uint32 value_size = (uint32) sizeof(uint32);
            uint32 temp = 0x0;

            if (buffer_next + value_size <= buffer.len)
            {
                Memory.copy(&temp, ((uint8*) buffer.data) + buffer_next, value_size);
                value = Posix.ntohl(temp);
                update_counters(value_size);
                result = true;
            }

            return result;
        }

        /**
         * Read a int32 value from the buffer
         **/
        public bool read_int32(out int32 value)
        {
            uint32 temp;
            bool result = false;

            result = read_uint32(out temp);
            value = (int32) temp;

            return result;
        }

        /**
         * Read a uint16 value from the buffer
         **/
        public bool read_uint16(out uint16 value)
        {
            uint32 temp;
            bool result = false;

            result = read_uint32(out temp);
            value = (uint16) temp;

            return result;
        }

        /**
         * Read a int16 value from the buffer
         **/
        public bool read_int16(out int16 value)
        {
            uint32 temp;
            bool result = false;

            result = read_uint32(out temp);
            value = (int16) temp;

            return result;
        }

        /**
         * Read a uint8 value from the buffer
         **/
        public bool read_uint8(out uint8 value)
        {
            uint32 temp;
            bool result = false;

            result = read_uint32(out temp);
            value = (uint8) temp;

            return result;
        }

        /**
         * Read a int8 value from the buffer
         **/
        public bool read_int8(out int8 value)
        {
            uint32 temp;
            bool result = false;

            result = read_uint32(out temp);
            value = (int8) temp;

            return result;
        }

        /**
         * Read a set of bytes from the buffer. The number of the bytes to read is stored
         * within the buffer so no size or length has to be supplied.
         **/
        public bool read_bytes(out uint8[] data, out uint32 len)
        {
            uint32 size = 0, size_aligned = 0;
            bool result = false;

            if (read_uint32(out size))
            {
                size_aligned = size;

                if (!is_aligned_size(size))
                    size_aligned += get_align_size_offset(size);

                if (buffer_next + size_aligned <= buffer.len)
                {
                    data = new uint8[size];
                    Memory.copy(data, ((uint8*) buffer.data) + buffer_next, size);
                    len = size;
                    update_counters(size_aligned);
                    result = true;
                }
            }

            if (!result)
            {
                data = null;
                len = 0;
            }

            return result;
        }

        /**
         * This reads a pointer and the data behind it recursivly from the buffer.
         * NOTE: The obj needs to be initialized before calling read_pointer!
         */
        public bool read_pointer(void *obj, uint32 obj_size, XdrBufferReadCb read_cb)
        {
            uint32 ptr_valid = 0;

            if (obj == null || read_cb == null)
                return false;

            if (!read_uint32(out ptr_valid) || ptr_valid != 1)
                return false;

            return read_cb(this, obj);
        }

#if 0
        public bool read_array(out void *obj, out uint32 obj_size, uint32 elem_size, XdrBufferReadCb read_cb)
        {
            bool result = false;
            void *ptr = null;

            result = read_uint32(out obj_size);
            if (obj_size <= 0)
                return false;

            obj = (void*) new uint8[obj_size * elem_size];

            ptr = obj;
            for (int n = 0; n < obj_size; n++)
            {
                result = read_cb(this, ptr);
                if (!result)
                {
                    obj = null;
                    return false;
                }
                ptr += elem_size;
            }

            return true;
        }
#endif
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
        }

        //
        // public API
        //

        construct
        {
            reset();
        }

        /**
         * This will append a raw byte sequence to the internal buffer. It is required
         * that the data is already in xdr format.
         **/
        public bool append(uint8[] data)
        {
            bool result = false;

            if (buffer_next + data.length <= BUFFER_MAX_SIZE)
            {
                buffer.append(data);
                update_counters(data.length);
                result = true;
            }

            return result;
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
                uint32 temp = Posix.htonl(value);
                Memory.copy(bytes, &temp, value_size);
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
                size += get_align_size_offset(size);

            // respect four bytes for the size of the bytes
            size += (uint32) sizeof(uint32);

            if (buffer_next + size < BUFFER_MAX_SIZE)
            {
                // append the length of the bytes first
                uint8[] temp = new uint8[4];
                uint32 nsize = Posix.htonl(bytes.length);
                Memory.copy(temp, &nsize, 4);
                buffer.append(temp);

                // now append the bytes and add zeros to match the aligned size
                temp = new uint8[size - sizeof(uint32)];
                Memory.copy(temp, bytes, bytes.length);
                if (!is_aligned_size(bytes.length))
                {
                    Posix.memset(((uint8*) temp) + bytes.length, 0,
                                 get_align_size_offset(bytes.length));
                }

                buffer.append(temp);
                update_counters(size);
                result = true;
            }

            return result;
        }

        /**
         * Write a pointer and the structure of it recursivly to the buffer. This will
         * only write the pointer itself and then calls write_cb to handle the content
         * the pointer points to.
         **/
        public bool write_pointer(void *obj, uint32 obj_size, XdrBufferWriteCb write_cb)
        {
            bool result = false;
            uint32 ptr_valid = 0;

            if (obj == null || write_cb == null)
                return false;

            ptr_valid = (obj != null) ? 1 : 0;
            result = write_uint32(ptr_valid);

            if (!result || ptr_valid != 1)
                return false;

            return write_cb(this, obj);
        }

        /**
         * Writes a array and it's content recursivly to the buffer. This will only write
         * the size of the array to the buffer and then call write_cb to write each
         * element of the array.
         **/
        public bool write_array_raw(void *obj, uint32 obj_size, uint32 elem_size, XdrBufferWriteCb write_cb)
        {
            bool result = false;
            uint *tmpaddr = obj;

            if (obj == null || write_cb == null)
                return false;

            result = write_uint32(obj_size);
            if (!result)
                return false;

            for (int n = 0; n < obj_size; n++)
            {
                result = write_cb(this, tmpaddr);
                if (!result)
                    return false;

                tmpaddr += elem_size;
            }

            return true;
        }

        /**
         * Writes an array with items of type T and it's content recursivly to the buffer.
         * This will only write the size of the array to the buffer and then call write_cb
         * to write each element of the array.
         **/
        public bool write_array<T>(T[] items, XdrBufferWriteCb write_cb)
        {
            return write_array_raw((void*) items, items.length, (uint32) sizeof(T), write_cb);
        }
    }
}
