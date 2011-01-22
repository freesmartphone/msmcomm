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
}
