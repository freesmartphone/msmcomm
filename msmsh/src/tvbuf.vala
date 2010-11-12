
namespace Msmcomm {

    public errordomain TvbuffError 
    {
        OUT_OF_RANGE,
        INVALID_BUFFER,
    }

    public class Tvbuff 
    {
        private RawDataBuffer _buffer;

        public uint32 length 
        {
            get 
            {
                if (_buffer == null) 
                {
                    throw new TvbuffError.INVALID_BUFFER("Current buffer is invalid");
                }
                return _buffer.size;
            }
        }

        public Tvbuff(RawDataBuffer buffer) 
        {
            _buffer = buffer;
        }

        private bool ensure_offset(uint offset)
        {
            bool result = true;
            if (offset >= _buffer.size)
            {
                stdout.printf("ensure_offset: buffer.size = %i\n".printf((int)_buffer.size));
                result = false;
            }
            return result;
        }

        public uint8 read_uint8(uint offset) throws TvbuffError 
        {
            if (!ensure_offset(offset))
            {
                throw new TvbuffError.OUT_OF_RANGE("Out of range!");
            }
            return _buffer.data[offset];
        }

        public uint16 read_uint16(uint offset) throws TvbuffError 
        {
            uint16 result = 0x0;
            return result;
        }


        public uint8[] read_range_uint8(uint start, uint len) throws TvbuffError 
        {
            stdout.printf(@"read_range_uint8: start=$(start) len=$(len)\n");
            
            if (len > _buffer.size)
            {
                throw new TvbuffError.OUT_OF_RANGE("Out of range!");
            }

            uint8[] buf = new uint8[len];
            for (uint n=start; n<start+len; n++) 
            {
                buf[n-start] = _buffer.data[n];
            }

            return buf;
        }
    }
} // namespace
