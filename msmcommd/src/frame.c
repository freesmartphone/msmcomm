/* 
 * (c) 2009 by Simon Busch <morphis@gravedo.de>
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

void msmc_frame_create(struct frame *fr, unsigned int type)
{
	if (!fr)
		fr = (struct frame*) malloc(sizeof(struct frame));
	
	fr->adress = 0xfa;
	fr->type = type;
	fr->seq = 0;
	fr->ack = 0;
	fr->payload = NULL;
	fr->payload_len = 0;
}

unsigned char* msmc_frame_decode(unsigned char *data, unsigned int len, unsigned int *new_len)
{
	unsigned char *decoded_data;
	if (!data) return;
	
	decoded_data = (unsigned char*) malloc(sizeof(unsigned char) * len);
	*new_len = 0;
	while(len--)
	{
		/* replace:
		 * - 0x7d 0x5d with 0x7d
		 * - 0x7d 0x5e with 0x7e
		 */
		if (*data == 0x7d && len > 0)
		{
			if (*(data+1) == 0x5d)
			{
				*decoded_data++ = 0x7d;
				data++;
			}
			else if(*(data+1) == 0x5e)
			{
				*decoded_data++ = 0x7e;
				data++;
			}
		}
		else 
			*decoded_data = *data;

		*new_len += 1;
		decoded_data++;
		data++;
	}
}

