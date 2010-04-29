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

namespace Msmcomm {

public enum FrameType {
	NULL,
	SYNC,
	SYNC_RESP,
	CONFIG,
	CONFIG_RESP,
	ACKNOWLEDGE,
	DATA,
}

public enum FsAction {
	NULL,
	READ,
	WRITE,
}

public FsAction byte_to_fs_action(uint8 byte) {
	switch (byte) {
		case 0x1:
			return FsAction.READ;
		case 0x2:
			return FsAction.WRITE;
		default:
			break;
	}
	return FsAction.NULL;
}

public string fs_action_to_string(FsAction action) {
	switch (action) {
	case FsAction.READ:
		return "READ";
	case FsAction.WRITE:
		return "WRITE";
	default:
		break;
	}
	return "";
}

public FrameType byte_to_frame_type(uint8 byte) {
	switch (byte) {
	case 0x1:
		return FrameType.SYNC;
	case 0x2:
		return FrameType.SYNC_RESP;
	case 0x3:
		return FrameType.CONFIG;
	case 0x4:
		return FrameType.CONFIG_RESP;
	case 0x5:
		return FrameType.ACKNOWLEDGE;
	case 0x6:
		return FrameType.DATA;
	}
	return FrameType.NULL;
}

public string frame_type_to_string(FrameType type) {
	string result = "";
	switch (type) {
	case FrameType.NULL:
		result = "NULL";
		break;
	case FrameType.SYNC:
		result = "SYNC";
		break;
	case FrameType.SYNC_RESP:
		result = "SYNC RESPONSE";
		break;
	case FrameType.CONFIG:
		result = "CONFIG";
		break;
	case FrameType.CONFIG_RESP:
		result = "CONFIG RESPONSE";
		break;
	case FrameType.ACKNOWLEDGE:
		result = "ACKNOWLEDGE";
		break;
	case FrameType.DATA:
		result = "DATA";
		break;
	default:
		break;
	}
	return result;
}

public class DataTransferObject : GLib.Object {
	public Gee.HashMap<string, string> fields { get; set; }
	public string name { get; set; }

	construct {
		fields = new Gee.HashMap<string, string>();
	}
}

public interface IResult : GLib.Object {
	public abstract DataTransferObject to_data_transfer_object();
	public abstract string append_to_title { get; }
}

public interface IDissector : GLib.Object {
	public abstract IResult? run(RawDataBuffer buffer);
}

public class Frame : IResult, GLib.Object {
	public uint8 addr { get; set; }
	public FrameType fr_type { get; set; default = FrameType.NULL; }
	public uint8 seq { get; set; }
	public uint8 ack { get; set; }
	public uint8[] payload { get; set; }
	public bool is_valid { get; set; default = true; }
	public bool is_complete { get; set; default = true; }
	public FsAction fs_action { get; set; default = FsAction.READ; }

	private string _tmp;

	public string append_to_title {
		get {
			string frame_type = frame_type_to_string(fr_type);
			string fs_action = fs_action_to_string(fs_action);
			_tmp = @"$(fs_action) Type=$(frame_type)";
			return _tmp;
		}
	}

	public DataTransferObject to_data_transfer_object() {
		DataTransferObject obj = new DataTransferObject();
		obj.name = "Frame";
		obj.fields.set("Address", "0x%x".printf(addr));
		obj.fields.set("Type", frame_type_to_string(fr_type));
		obj.fields.set("Seq", "0x%x".printf(seq));
		obj.fields.set("Ack", "0x%x".printf(ack));
		if (is_complete) obj.fields.set("Complete", "True");
		else obj.fields.set("Complete", "False");
		if (is_valid) obj.fields.set("CRC", "OK");
		else obj.fields.set("CRC", "ERROR");
		return obj;
	}
}

public class Message : IResult, GLib.Object {
	public string append_to_title {
		get {
			return @"MessageType=FIXME";
		}
	}

	public DataTransferObject to_data_transfer_object() {
		DataTransferObject dto = new DataTransferObject();
		dto.name = "Message";
		return dto;
	}
}

public class LinkLayerDissector : IDissector, GLib.Object {
	public IResult? run(RawDataBuffer buffer) {
		Tvbuff tvb = new Tvbuff(buffer);
		uint8 seq_ack;
		uint8[] crc;
		uint8[] payload;

		var fr = new Frame();

		fr.fs_action = byte_to_fs_action(buffer.direction);

		// check if length is a valid frame length
		if (tvb.length < 5)
			return null;

		// do we have a valid frame?
		uint32 end = 0;
		for (uint32 n=tvb.length-1; n>0; n--) {
			uint8 byte = tvb.read_uint8(n);
			if (byte == 0x7e) {
				end = n;
				break;
			}
		}

		if (end <= 0) {
			fr.is_complete = false;
		}
		
		// extract basic information from buffer
		fr.addr = tvb.read_uint8(0);
		fr.fr_type = byte_to_frame_type(tvb.read_uint8(1) >> 4);
		seq_ack = tvb.read_uint8(2);
		fr.seq = (seq_ack & 0xf0) >> 4;
		fr.ack = (seq_ack & 0x0f);

		// FIXME crc check

		return fr;
	}

	private bool checkPayload(uint8[] payload) {
		// FIXME
		return false;
	}

	private uint8[] decodePayload(uint8[] payload) {
		uint real_size = 0;
		uint8 byte = 0x0, next_byte = 0x0;
		uint8[] decoded_payload = new uint8[payload.length];
		uint8[] result = null;

		for (int n = 0; n < payload.length; n++) {
			byte = payload[n];
			if (n < payload.length - 1) {
				next_byte = payload[n+1];
				if (byte == 0x7d) {
					switch (next_byte) {
					case 0x5e:
						decoded_payload[n] = 0x7e;
						n++;
						break;
					case 0x5d:
						decoded_payload[n] = 0x7d;
						n++;
						break;
					}
				}
			}
			else {
				decoded_payload[n] = byte;
			}
			real_size++;
		}

		result = new uint8[real_size];
		GLib.Memory.copy(result, decoded_payload, real_size);
		return result;
	}
}

public class StructureDefinitionDissector : IDissector, GLib.Object {
	public IResult? run(RawDataBuffer buffer) {
		var msg = new Message();

		// FIXME

		return msg;
	}
}

public class DissectorWorker {
	private ArrayList<IDissector> _dissectors;

	public DissectorWorker() {
		_dissectors = new ArrayList<IDissector>();
		_dissectors.add(new LinkLayerDissector());
		_dissectors.add(new StructureDefinitionDissector());
	}

	public Gee.ArrayList<IResult> run(RawDataBuffer buffer) {
		var results = new Gee.ArrayList<IResult>();
		foreach (var dissector in _dissectors) {
			IResult result = dissector.run(buffer);
			if (result != null) 
				results.add(result);
		}
		return results;
	}
}

} // namespace

