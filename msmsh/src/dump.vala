/**
 * This file is part of msmsh.
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

using Gee;
using GLib;

namespace Msmcomm {

public enum FlowDirection {
	INVALID,
	IN,
	OUT,
}

public class RawDataBuffer {
	public uint8[] data { get; set; }
	public uint32 size { get; set; }
	public FlowDirection direction { get; set; }
}

public FlowDirection byte_to_flow_direction(uint8 byte) {
	switch (byte) {
		case 1:
			return FlowDirection.IN;
		case 2:
			return FlowDirection.OUT;
	}
	return FlowDirection.INVALID;
}

public errordomain DumpReaderError {
	UNKNOWN_FILE_FORMAT,
	COULD_NOT_LOAD_FILE,
}

public class DumpReader {
	private uint32 _currentPosition = 0;
	public ArrayList<RawDataBuffer> current_buffers { get; private set; }

	public DumpReader() {
		current_buffers = new ArrayList<RawDataBuffer>();
	}
	
	public void readFromFile(string path) throws DumpReaderError {
		try {
			var file = File.new_for_path(path);
			
			if (!file.query_exists(null)) {
				throw new DumpReaderError.COULD_NOT_LOAD_FILE(@"Could not find file '$(path)'");
			}
			
			var fileStream = file.read(null);
			var dataStream = new DataInputStream(fileStream);
			dataStream.set_byte_order (DataStreamByteOrder.LITTLE_ENDIAN);
			
			fileStream.seek(0, SeekType.END, null);
			var fileSize = fileStream.tell();
			fileStream.seek(0, SeekType.SET, null);
			
			var signature = dataStream.read_uint32(null);
			_currentPosition += 4;
			if (signature != 0xdeadbeef)
				throw new DumpReaderError.UNKNOWN_FILE_FORMAT(@"Format of file '$(path)' is unknown");

			// Ignore next byte for now ..
			dataStream.read_byte(null);
			_currentPosition += 1;
			
			while (_currentPosition < fileSize) {
				// Ensure we can read next header completly
				//if (fileSize - _currentPosition < 5)
					//break;
					
				// Read packet header
				var buffer = new RawDataBuffer();
				buffer.direction =  byte_to_flow_direction(dataStream.read_byte(null));
				buffer.size = dataStream.read_uint32(null);
				_currentPosition += 5;
					
				// Read packet data
				if (fileSize - _currentPosition >= buffer.size && 
					buffer.size > 0) {
					buffer.data = new uint8[buffer.size];
					dataStream.read(buffer.data, buffer.size, null);
					_currentPosition += buffer.size;
					current_buffers.add(buffer);
				}
			}
		}
		catch(DumpReaderError err) {
			throw err;
		}
		catch(GLib.Error err) {
			throw new DumpReaderError.COULD_NOT_LOAD_FILE(@"Could not load dump file '$(path)'");
		}
	}
}

} // namespace
