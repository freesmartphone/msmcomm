/**
 * This file is part of msmcommd.
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
    internal void hexdump( bool write, void* data, int len, FsoFramework.Logger logger )
    {
        if ( len < 1 )
            return;

        int BYTES_PER_LINE = 16;

        uchar* pointer = (uchar*) data;
        var hexline = new StringBuilder( write? "<<< " : ">>> " );
        var ascline = new StringBuilder();
        uchar b;
        int i;

        for ( i = 0; i < len; ++i )
        {
            b = pointer[i];
            hexline.append_printf( "%02x ", b );
            if ( 31 < b && b < 128 )
                ascline.append_printf( "%c", b );
            else
                ascline.append_printf( "." );

            if ( i % BYTES_PER_LINE+1 == BYTES_PER_LINE )
            {
                hexline.append( ascline.str );
                logger.debug( hexline.str );
                hexline = new StringBuilder( write? ">>> " : "<<< " );
                ascline = new StringBuilder();
            }
        }
        if ( i % BYTES_PER_LINE+1 != BYTES_PER_LINE )
        {
            while ( hexline.len < 52 )
                hexline.append_c( ' ' );

            hexline.append( ascline.str );
            logger.debug( hexline.str );
        }
    }
} // namespace Msmcomm
