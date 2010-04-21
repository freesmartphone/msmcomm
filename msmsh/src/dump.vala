/**
 * This file is part of msmvterm.
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

public enum PacketType {
	INVALID,
	READ,
	WRITE,
}

public class Packet {
	public uint8[] Data { get; set; }
	public uint32 Size { get; set; }
	public PacketType Type { get; set; }
}

public PacketType byteToPacketType(uint8 byte) {
	switch (byte) {
		case 1:
			return PacketType.READ;
		case 2:
			return PacketType.WRITE;
	}
	return PacketType.INVALID;
}

public class PacketDump {
	public int FormatRevision { get; set; default = 0; }
	public ArrayList<Packet> Packets { get; set; }
	
	public PacketDump() {
		Packets = new ArrayList<Packet>();
	}
}

public errordomain PacketDumpReaderError {
	UNKNOWN_FILE_FORMAT,
	COULD_NOT_LOAD_FILE,
}

public class PacketDumpReader {
	private uint32 _currentPosition = 0;
	public PacketDump CurrentDump { get; set; }
	
	public void readFromFile(string path) throws PacketDumpReaderError {
		try {
			var file = File.new_for_path(path);
			
			if (!file.query_exists(null)) {
				throw new PacketDumpReaderError.COULD_NOT_LOAD_FILE(@"Could not find file '$(path)'");
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
				throw new PacketDumpReaderError.UNKNOWN_FILE_FORMAT(@"Format of file '$(path)' is unknown");
				
			CurrentDump = new PacketDump();
			CurrentDump.FormatRevision = dataStream.read_byte(null);
			_currentPosition += 1;
			
			while (_currentPosition < fileSize) {
				// Ensure we can read next header completly
				if (fileSize - _currentPosition < 5)
					break;
					
				// Read packet header
				var packet = new Packet();
				packet.Type = byteToPacketType(dataStream.read_byte(null));
				packet.Size = dataStream.read_uint32(null);
				_currentPosition += 5;
					
				// Read packet data
				if (fileSize - _currentPosition >= packet.Size) {
					packet.Data = new uint8[packet.Size];
					dataStream.read(packet.Data, packet.Size, null);
					_currentPosition += packet.Size;
					CurrentDump.Packets.add(packet);
				}
			}
			
		}
		catch(PacketDumpReaderError err) {
			throw err;
		}
		catch(GLib.Error err) {
			throw new PacketDumpReaderError.COULD_NOT_LOAD_FILE(@"Could not load dump file '$(path)'");
		}
	}
}

} // namespace
