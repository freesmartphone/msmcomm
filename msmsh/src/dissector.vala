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

namespace Msmcomm 
{
    public enum FrameType 
    {
        NULL,
        SYNC,
        SYNC_RESP,
        CONFIG,
        CONFIG_RESP,
        ACKNOWLEDGE,
        DATA,
    }

    public enum FsAction 
    {
        NULL,
        READ,
        WRITE,
    }

    public FsAction byte_to_fs_action(uint8 byte) 
    {
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
    
    public FsAction string_to_fs_action(string str)
    {
        FsAction result = FsAction.NULL;
        
        switch (str)
        {
            case "read":
                result = FsAction.READ;
                break;
            case "write":
                result = FsAction.WRITE;
                break;
        }
        
        return result;
    }

    public string fs_action_to_string(FsAction action) 
    {
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

    public FrameType byte_to_frame_type(uint8 byte) 
    {
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

    public string frame_type_to_string(FrameType type) 
    {
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
    
    public class FieldInfo
    {
        public string name { get; set; }
        public string value_hex { get; set; }
        public string value_ascii { get; set; }
        public int offset_start { get; set; }
        public int offset_end { get; set; }
    }

    public class DataTransferObject
    {
        public Gee.ArrayList<FieldInfo> fields { get; set; }
        public string name { get; set; }

        public DataTransferObject() 
        {
            fields = new Gee.ArrayList<FieldInfo>();
        }
    }

    public interface IResult : GLib.Object 
    {
        // public abstract DataTransferObject to_data_transfer_object();
    }

    public class FrameInfo 
    {
        public uint8 addr { get; set; }
        public FrameType fr_type { get; set; default = FrameType.NULL; }
        public uint8 seq { get; set; }
        public uint8 ack { get; set; }
        public RawDataBuffer payload { get; set; }
        public bool is_valid { get; set; default = true; }
        public bool is_complete { get; set; default = true; }
        public FsAction fs_action { get; set; default = FsAction.READ; }
        
        public FrameInfo()
        {
            payload = new RawDataBuffer();
        }
    }

    public class MessageInfo {
        public uint8 subsystem_id { get; set; }
        public uint8 group_id { get; set; }
        public uint8 msg_id { get; set; }
        public RawDataBuffer payload { get; set; }
        public string structure_name { get; set; }
        public string message_type_name { get; set; }
        public Gee.ArrayList<FieldInfo> fields;

        public MessageInfo()
        {
            fields = new Gee.ArrayList<FieldInfo>();
            payload = new RawDataBuffer();
        }
    }

    public class LinkLayerDissector : GLib.Object 
    {
        private Session session;

        public LinkLayerDissector(Session session) 
        {
            this.session = session;
        }
        
        public FrameInfo? run(RawDataBuffer buffer) 
        {
            var fri = new FrameInfo();
            
            fri.fs_action = byte_to_fs_action(buffer.direction);

            var fr = new LowLevel.Frame.new_from_buffer(buffer.data, buffer.size);
            if (fr != null) 
            {
                fri.ack = fr.ack;
                fri.seq = fr.seq;
                fri.addr = fr.addr;
                fri.fr_type = byte_to_frame_type(fr.type);
                fri.is_valid = fr.is_valid == 1 ? true : false;
                fri.payload = new RawDataBuffer();
                fri.payload.data = fr.payload;
                fri.payload.size = fr.payload_size;
            }

            return fri;
        }
    }

    public class StructureDefinitionDissector : GLib.Object 
    {
        private Session session;

        construct 
        {
        }
        
        public StructureDefinitionDissector(Session session) 
        {
            this.session = session;
        }
        
        public MessageInfo? run(RawDataBuffer? buffer) {
            var msg = new MessageInfo();
            var tvb = new Tvbuff(buffer);
            string structure_name = "";
            StructureDefinition sdef = null;
            uint len = 0, val = 0;
            
            // We should have at least three bytes for a valid message 
            if (buffer.size == 0 || buffer.size < 3)
                return null;

            // First we need to find out which kind of message we have
            // FIXME we need more handling for the case that we have a 
            // subsystem id in our current message ...
            msg.group_id = tvb.read_uint8(0);
            msg.msg_id = tvb.read_uint8(1);
            
            // Do we have a message with payload or just with group/msg/subsystem id
            if (buffer.size > 3)
            {
                msg.payload = new RawDataBuffer();
                msg.payload.data = tvb.read_range_uint8(3, tvb.length - 3);
                msg.payload.size = tvb.length - 3;

                // Find the right packet definition for the current message
                foreach (var def in session.definitions) 
                {
                    if (msg.group_id == def.group_id && msg.msg_id == def.msg_id) 
                    {
                        structure_name = def.structure_name;
                        msg.message_type_name = def.message_type_name;
                        break;
                    }
                }

                // Find the right structure definition for the current message
                foreach (var structure in session.structures) 
                {
                    if (structure.name == structure_name) 
                    {
                        sdef = structure;
                        msg.structure_name = sdef.name;
                        break;
                    }
                }

                // Assign field definitions to buffer
                if (sdef != null) 
                {
                    FsoFramework.theLogger.info(@"Adding fields for structure '$(sdef.name)'");
                    
                    if (sdef.length != buffer.size - 3)
                    {
                        return msg;
                    }

                    foreach (var field in sdef.fields) 
                    {
                        if (field.offset_end == 0)
                        {
                            len = 1;
                        }
                        else 
                        {
                            len = field.offset_end - field.offset_start + 1;
                        }

                        uint8[] buf = tvb.read_range_uint8(field.offset_start + 3, len);
                        var tmp = convertBinaryToString(buf);
                        string hex = "";
                        foreach (uint8 byte in buf) 
                        {
                            hex += "%02x ".printf(byte);
                        }
                        
                        var field_info = new FieldInfo(); 
                        field_info.name = field.name;
                        field_info.value_hex = hex;
                        field_info.value_ascii = tmp;
                        field_info.offset_start = field.offset_start;
                        field_info.offset_end = field.offset_end;
                        msg.fields.add(field_info);
                    }
                }
            }
            
            return msg;
        }

        private string convertBinaryToString(uint8[] buffer) 
        {
            string result = "";

            foreach (uint8 byte in buffer) 
            {
                if (byte > 32 && byte < 128) 
                {
                    result += "%c".printf(byte);
                }
                else 
                { 
                    result += ".";
                }
            }
            
            return result;
        }
    }

    public class Packet 
    {
        public FrameInfo frame { get; set; }
        public MessageInfo message { get; set; }
    }

    public class DissectorWorker 
    {
        private LinkLayerDissector linkLayerDissector;
        private StructureDefinitionDissector structureDefinitionDissector;

        public DissectorWorker(Session session) 
        {
            linkLayerDissector = new LinkLayerDissector(session);
            structureDefinitionDissector = new StructureDefinitionDissector(session);
        }

        public Packet run(RawDataBuffer buffer) 
        {
            var p = new Packet();
            p.frame = linkLayerDissector.run(buffer);
            
            if (p.frame.fr_type == FrameType.DATA)
            {
                p.message = structureDefinitionDissector.run(p.frame.payload);
            }
            
            return p;
        }
    }

} // namespace

