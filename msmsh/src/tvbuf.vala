
namespace Msmcomm {

public errordomain TvbuffError {
	OUT_OF_RANGE,
	INVALID_BUFFER,
}

public class Tvbuff {
	private RawDataBuffer _buffer;

	public uint32 length {
		get {
			if (_buffer == null) 
				throw new TvbuffError.INVALID_BUFFER("Current buffer is invalid");
			return _buffer.size;
		}
	}

	public Tvbuff(RawDataBuffer buffer) {
		_buffer = buffer;
	}

	private void ensure_offset(uint offset) {
		if (offset >= _buffer.size)
			throw new TvbuffError.OUT_OF_RANGE("Out of range");
	}

	public uint8 read_uint8(uint offset) throws TvbuffError {
		ensure_offset(offset);
		return _buffer.data[offset];
	}

	public uint16 read_uint16(uint offset) throws TvbuffError {
		uint16 result = 0x0;
		return result;
	}

	public uint8[] read_range_uint8(uint start, uint end) throws TvbuffError {
		uint8[] buf = new uint8[end-start];

		for (uint n=start; n<end; n++)
			buf[n-start] = _buffer.data[n];
		
		return buf;
	}
}

} // namespace
