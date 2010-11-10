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
    
    public class RawDataBuffer 
    {
        public uint8[] data { get; set; }
        public uint size { get; set; }
        public FsAction direction { get; set; }
    }

    public errordomain DumpReaderError 
    {
        UNKNOWN_FILE_FORMAT,
        COULD_NOT_LOAD_FILE,
    }
    
    public class DumpReader
    {
        public Gee.ArrayList<RawDataBuffer> current_buffers { get; private set; }
        
        public DumpReader()
        {
            current_buffers = null;
        }
        
        public void readFromFile(string path) throws DumpReaderError
        {
            // Assure that file exists
            var file = File.new_for_path(path);
            if (!file.query_exists(null)) 
            {
                throw new DumpReaderError.COULD_NOT_LOAD_FILE(@"Could not find file '$(path)'");
            }
            
            // Process input strace dump via python script an fetch the 
            // output per stdout
            var script_path = "/home/morphis/Workspace/fso/msmcomm/msmsh/scripts/strace-msm-parse.py"; // FIXME make this dynamic!
            var output = "";
            var cmdline = @"/usr/bin/env python $(script_path) $(path)";
            
            try
            {
                Process.spawn_command_line_sync(cmdline, out output);
            }
            catch (SpawnError err0)
            {
                var msg = @"Could not load dump from file: $(err0.message)";
                throw new DumpReaderError.COULD_NOT_LOAD_FILE(msg);
            }
            
            // Now we parse the output from the script
            current_buffers = parse_data(output);
        }
        
        private uint8 parse_byte(string bytestr)
        {
            uint8 result = 0x0;
            
            if (bytestr.length == 2)
            {
               uint8 a = chr_to_byte(bytestr.data[0]);
               uint8 b = chr_to_byte(bytestr.data[1]);
               
               // we have most significant half-byte first!
               result = ((a << 4) | b);
            }
            
            return result; 
        }
        
        private Gee.ArrayList<RawDataBuffer> parse_data(string datastr) throws DumpReaderError
        {
            Gee.ArrayList<RawDataBuffer> result = new Gee.ArrayList<RawDataBuffer>();
            RawDataBuffer current_buffer = null;
            ByteBuffer current_bbuffer = new ByteBuffer();
            int line_count = 0;
            int byte_count = 0;
            
            foreach (var line in datastr.split("\n"))
            {
                line_count++;
                
                if (line.has_prefix("PACKET:"))
                {
                    // First finish current buffer
                    if (current_buffer != null)
                    {
                        current_buffer.data = current_bbuffer.pack_data();
                        current_buffer.size = current_bbuffer.size;
                        
                        // Do we have exact number of bytes read for this packet?
                        if (current_buffer.size != current_bbuffer.size)
                        {
                            result.clear();
                            var msg = "Defined length of packet and real length does not match";
                            FsoFramework.theLogger.error(@"DumpReader.parse_data: $(msg)");
                            FsoFramework.theLogger.error(@"DumpReader.parse_data: [$(line_count)] current line = \"$(line)\"");
                            throw new DumpReaderError.UNKNOWN_FILE_FORMAT(msg);
                        }
                        
                        result.add(current_buffer);
                    }
                    
                    // Now we can start with our new buffers
                    current_buffer = new RawDataBuffer();
                    current_bbuffer.clear();
                    byte_count = 0;
                    
                    string[] packet_info = line.split(" ");
                    if (packet_info.length != 5)
                    {
                        result.clear();
                        var msg = "Packet header has wrong format";
                        throw new DumpReaderError.UNKNOWN_FILE_FORMAT(msg);
                    }
                    
                    // FIXME this is really ugly .... I know ... will fix this or not ...
                    current_buffer.size = packet_info[4].split("=")[1].to_int();
                    current_buffer.direction = string_to_fs_action(packet_info[1].split("=")[1]);
                }
                else if (line.has_prefix("DATA:"))
                {
                    // Append all bytes in this line to the current buffer
                    var bytes = line.split(" ");
                    int line_bytes = 0;
                    for(int n = 2; n < bytes.length; n++)
                    {
                        // Don't read more bytes than we actually have
                        if (byte_count == current_buffer.size || line_bytes == 16)
                            break;
                        
                        current_bbuffer.append(parse_byte(bytes[n]));
                        byte_count++;
                        line_bytes++;
                    }
                }
            }
            
            return result;
        }
    }

#if 0
    public class DumpReader 
    {
        private uint32 _currentPosition = 0;
        public ArrayList<RawDataBuffer> current_buffers { get; private set; }

        public DumpReader() 
        {
            current_buffers = new ArrayList<RawDataBuffer>();
        }
        
        public void readFromFile(string path) throws DumpReaderError 
        {
            try 
            {
                var file = File.new_for_path(path);
                
                if (!file.query_exists(null)) 
                {
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
                {
                    throw new DumpReaderError.UNKNOWN_FILE_FORMAT(@"Format of file '$(path)' is unknown");
                }

                // Ignore next byte for now ..
                dataStream.read_byte(null);
                _currentPosition += 1;
                
                while (_currentPosition < fileSize) 
                {
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
            catch(DumpReaderError err) 
            {
                throw err;
            }
            catch(GLib.Error err) 
            {
                throw new DumpReaderError.COULD_NOT_LOAD_FILE(@"Could not load dump file '$(path)'");
            }
        }
    }
#endif
} // namespace
