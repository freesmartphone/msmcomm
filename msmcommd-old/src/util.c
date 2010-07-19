
/*
 * (C) 2009-2010 by Simon Busch <morphis@gravedo.de>
 * All Rights Reserved
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

#include <msmcomm/internal.h>

#define VALUES_PER_LINE 16
extern int append_newline;

void hexdump(uint8_t * data, uint32_t len)
{
    char ascii[VALUES_PER_LINE + 1];

    int count;

    int offset;

    uint8_t *p;

    if (!data)
        return;
    p = data;

    memset(ascii, 0, VALUES_PER_LINE + 1);
    count = 0;

    while (len--)
    {
        uint8_t b = *p++;

        log_small_message("%02x ", b & 0xff);
        if (b > 32 && b < 128)
            ascii[count] = b;
        else
            ascii[count] = '.';
        count++;

        if (count == VALUES_PER_LINE)
        {
            log_small_message("      %s\n", ascii);
            memset(ascii, 0, VALUES_PER_LINE + 1);
            count = 0;
        }
    }

    if (count != 0)
    {
        while (count++ < VALUES_PER_LINE)
        {
            log_small_message("   ");
        }
        log_small_message("      %s\n", ascii);
    }
}
