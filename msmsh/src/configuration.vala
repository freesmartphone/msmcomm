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

using GLib;

namespace Msmcomm 
{
    public const string DEFAULT_CONFIG_FILENAME = ".msmsh_config";

    public errordomain ConfigurationError
    {
        COULD_NOT_FIND_FILE,
    }

    public class Configuration : GLib.Object 
    {
        private GLib.KeyFile kf;
        
        construct 
        {
            kf = new GLib.KeyFile();
        }

        public void loadFromFile(string path) 
        {
            string config_path = @"$(path)/$(DEFAULT_CONFIG_FILENAME)";
            var file = File.new_for_path(config_path);
            if (!file.query_exists(null)) {
                string msg = @"Could not find configuration file at '$(path)'";
                throw new ConfigurationError.COULD_NOT_FIND_FILE(msg);
            }

            kf.load_from_file(config_path, GLib.KeyFileFlags.NONE);
        }


        //
        // NOTE: Functions below are copied from libfsobasics smartkeyfile.vala
        //
        
        public string stringValue( string section, string key, string defaultvalue = "" )
        {
            string value;

            try
            {
                value = kf.get_string( section, key );
            }
            catch ( KeyFileError e )
            {
                value = defaultvalue;
            }
            return value.strip();
        }

        public int intValue( string section, string key, int defaultvalue = 0 )
        {
            int value;

            try
            {
                value = kf.get_integer( section, key );
            }
            catch ( KeyFileError e )
            {
                value = defaultvalue;
            }
            return value;
        }

        public bool boolValue( string section, string key, bool defaultvalue = false )
        {
            bool value;

            try
            {
                value = kf.get_boolean( section, key );
            }
            catch ( KeyFileError e )
            {
                value = defaultvalue;
            }
            return value;
        }

        public string[]? stringListValue( string section, string key, string[]? defaultvalue = null )
        {
            string[] value;

            try
            {
                value = kf.get_string_list( section, key );
            }
            catch ( KeyFileError e )
            {
                value = defaultvalue;
            }
            return value;
        }

        public bool hasSection( string section )
        {
            return kf.has_group( section );
        }

        public List<string> sectionsWithPrefix( string? prefix = null )
        {
            var list = new List<string>();
            var groups = kf.get_groups();

            foreach ( var group in groups )
            {
                if ( prefix == null )
                    list.append( group );
                else
                    if ( group.has_prefix( prefix ) )
                        list.append( group );
            }
            return list;
        }

        public bool hasKey( string section, string key )
        {
            try
            {
                return kf.has_key( section, key );
            }
            catch ( KeyFileError e )
            {
                return false;
            }
        }

        public List<string> keysWithPrefix( string section, string? prefix = null )
        {
            var list = new List<string>();
            string[] keys;

            try
            {
                keys = kf.get_keys( section );
            }
            catch ( KeyFileError e )
            {
                return list;
            }

            foreach ( var key in keys )
            {
                if ( prefix == null )
                    list.append( key );
                else
                    if ( key.has_prefix( prefix ) )
                        list.append( key );
            }
            return list;
        }
    }
}
