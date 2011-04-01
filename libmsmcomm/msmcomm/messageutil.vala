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

using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    private string convertBytesToString(uint8[] bytes)
    {
        string *tmp = GLib.malloc0(bytes.length); 
        char *dest = (char*) tmp;
        Memory.copy(dest, (uint8*) bytes, bytes.length);
        return (owned) tmp;
    }

    private uint16 parseMcc(uint16 input)
    {
        // Example: input = 0xf262, output = 262
        uint16 b0 = (input & 0xf000) >> 12; b0 = b0 > 9 ? 0 : b0;
        uint16 b1 = (input & 0x0f00) >> 8; b1 = b1 > 9 ? 0 : b1;
        uint16 b2 = (input & 0x00f0) >> 4; b2 = b2 > 9 ? 0 : b2;
        uint16 b3 = (input & 0x000f) >> 0; b3 = b3 > 9 ? 0 : b3;
        return b0 * 1000 + b1 * 100 + b2 * 10 + b3;
    }

    private uint8 parseMnc(uint8 input)
    {
        // Example: input = 0x20, output = 2;
        uint8 b0 = (input & 0xf0) >> 4; b0 = b0 > 9 ? 0 : b0;
        uint8 b1 = (input & 0x0f) >> 0; b1 = b1 > 9 ? 0 : b1;
        return b1 * 10 + b0;
    }

    public uint8[] encodeBinary( string str )
    {
        var result = new uint8[str.length];
        int i = 0;

        foreach(var c in str.data)
        {
            result[i++] = c - '0';
        }

        return result;
    }

    public string decodeBinary( uint8[] data )
    {
        var s = new StringBuilder();

        foreach( var byte in data )
        {
            s.append_c( (char) byte + '0' );
        }

        return s.str;
    }

    public uint8[] encode_bcd( string number )
    {
        var result = new uint8[(number.length + 1) / 2];
        int i = 0, n = 0;

        foreach(var byte in number.data)
        {
            n = i / 2;

            if( ( i % 2 ) == 0 )
            {
                 result[n] = byte - '0';
            }
            else
            {
                 result[n] |= ( byte - '0' ) << 4;
            }

            i++;
        }

        if( ( i % 2 ) != 0 )
        {
            result[i/2] |= 0xf << 4;
        }

        return result;
    }

    public string decode_bcd( uint8[] data, int length )
    {
        var s = new StringBuilder();
        int n = 0;

        foreach( uint8 byte in data )
        {
            if ( n == length )
            {
                break;
            }

            s.append_c( ( (char) ( byte & 0xF ) + '0') );

            if( ( ( byte & 0xF0 ) >> 4) <= 9 )
            {
                s.append_c( ( (char) ( ( byte & 0xF0 ) >> 4 ) + '0' ) );
            }

            n++;
        }

        return s.str;
    }
}
