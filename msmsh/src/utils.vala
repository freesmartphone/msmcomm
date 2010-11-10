/**
 * This file is part of msmsh
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

namespace Msmcomm
{
    public class ByteBuffer
    {
        private Gee.ArrayList<uint8> _buffer;
        
        public ByteBuffer()
        {
            _buffer = new Gee.ArrayList<uint8>();
        }
        
        
        public uint8[] pack_data()
        {
            uint8[] result = new uint8[_buffer.size];
            
            int n = 0;
            foreach (var byte in _buffer)
            {
                result[n] = byte;
                n++;
            }
               
            return result;
        }
        
        public uint size 
        {
            get
            {
                return _buffer.size;
            }
        }
        
        public void append(uint8 byte)
        {
            _buffer.add(byte);
        }
        
        public void clear()
        {
            _buffer.clear();
        }
    }
    
    public uint8 chr_to_byte(unichar str) 
    {
        uint8 result = 0x0;
            
        switch (str) 
        {
            case '0':
                result = 0x0;
                break;
            case '1':
                result = 0x1;
                break;
            case '2':
                result = 0x2;
                break; 
            case '3':
                result = 0x3;
                break;
            case '4':
                result = 0x4;
                break;
            case '5':
                result = 0x5;
                break;
            case '6':
                result = 0x6;
                break;
            case '7': 
                result = 0x7;
                break;
            case '8':
                result = 0x8;
                break;
            case '9':
                result = 0x9;
                break;
            case 'a':
                result = 0xa;
                break;
            case 'b':
                result = 0xb;
                break;
            case 'c':
                result = 0xc;
                break;
            case 'd': 
                result = 0xd;
                break;
            case 'e':
                result = 0xe;
                break;
            case 'f':
                result = 0xf;
                break;
            default:
                break;
        }

        return result;
    }
}
