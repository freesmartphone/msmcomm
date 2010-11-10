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

namespace Msmcomm 
{
    public errordomain PacketDefinitionError 
    {
        COULD_NOT_FIND_FILE,
        SYNTAX_ERROR,
        COULD_NOT_PARSE_HEX_BYTE,
        ERROR_WHILE_PARSING,
    }

    public class PacketDefinition 
    {
        public uint8 group_id { get; set; }
        public uint8 msg_id { get; set; }
        public string structure_name { get; set; }
        public string message_type_name { get; set; }
    }

    public class PacketDefinitionReader : Object 
    {
        private uint8 parse_hex_byte(string str) throws PacketDefinitionError 
        {
            uint8 result = 0x0;

            if (str.length > 4 || !str.has_prefix("0x")) 
            {
                string msg = @"Could not parse hex byte '$(str)'";
                throw new PacketDefinitionError.COULD_NOT_PARSE_HEX_BYTE(msg);
            }
            
            if (str.length == 4) 
            {
                uint8 hb = chr_to_byte(str[2]);
                uint8 lb = chr_to_byte(str[3]);
                result = (hb << 4) | lb;
            }
            else 
            {
                result = chr_to_byte(str[2]);
            }
            
            return result;
        }

        public ArrayList<PacketDefinition> read_from_file(string path) throws PacketDefinitionError 
        {
            var definitions = new ArrayList<PacketDefinition>();
            var file  = File.new_for_path(path);
            
            if (!file.query_exists(null)) 
            {
                var msg = @"Could not find file '$(path)'";
                throw new PacketDefinitionError.COULD_NOT_FIND_FILE(msg);
            }

            try 
            {
                var in_stream = new DataInputStream(file.read(null));
                string line;
                int n = 1;
                while ((line = in_stream.read_line(null, null)) != null) 
                {
                    if (line.length == 0) 
                        continue;
                    
                    if (line.has_prefix("#"))
                        continue;
                    
                    string[] tokens = line.split(" ");
                    if (tokens.length != 3 && tokens.length != 4) 
                    {
                        string msg = @"More than three tokens in line $(n)";
                        throw new PacketDefinitionError.SYNTAX_ERROR(msg);
                    }

                    var def = new PacketDefinition();
                    def.group_id = parse_hex_byte(tokens[0]);
                    def.msg_id = parse_hex_byte(tokens[1]);
                    def.structure_name = tokens[2];
                    if (tokens.length == 4)
                    {
                        def.message_type_name = tokens[3];
                    }
                    definitions.add(def);
                    
                    n++;
                }
            }
            catch (PacketDefinitionError err) 
            {
                throw err;
            }
            catch (GLib.Error err) 
            {
                string msg = @"An error occured while parsing '$(path)'";
                throw new PacketDefinitionError.ERROR_WHILE_PARSING(msg);
            }

            return definitions;
        }
    }
} // namespace

