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

extern void *talloc_llc_ctx;

void init_frame(struct frame *fr, uint32_t type)
{
	fr->adress = 0xfa;
	fr->type = type;
	fr->seq = 0;
	fr->ack = 0;
	fr->payload = NULL;
	fr->payload_len = 0;
}

static void ensure_data_length(uint8_t *data, uint32_t *len, uint32_t count)
{
	/* check wether data is big enough to contain some count more bytes */
	if (*len + count >= *len) {
		data = talloc_realloc(talloc_llc_ctx, data, uint8_t, *len+count);
		*len += count;
	}
}

void encode_frame_data(const uint8_t *data, const uint32_t len, uint32_t *new_len, uint8_t *encoded_data)
{
	uint8_t *tmp = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * len * 2);
	uint32_t n = len;
	uint32_t tmp_len = len*2;
	uint8_t *p = &tmp[0];
	*new_len = 0;
	while(n--) {
		/* replace: 
		 * 0x7d with 0x7d 0x5d
		 * 0x7e with 0x7d 0x5e
		 */
		if (*data == 0x7d) {
			ensure_data_length(tmp, &tmp_len, 2);
			*p++ = 0x7d;
			*p++ = 0x5d;
			data += 2;
			new_len += 2;
		}
		else if (*data == 0x7e) {
			ensure_data_length(tmp, &tmp_len, 2);
			*p++ = 0x7d;
			*p++ = 0x5d;
			new_len += 2;
		}
		else {
			*p++ = *data++;
			new_len++;
		}
	}

	encoded_data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * (*new_len));
	talloc_free(tmp);
}

void decode_frame_data(const uint8_t *data, const uint32_t len, uint32_t *new_len,
								 uint8_t *decoded_data)
{
	uint8_t tmp[len];
	uint8_t *p = &tmp[0];
	uint32_t n = len;

	*new_len = 0;
	while(n--) {
		/* replace:
		 * - 0x7d 0x5d with 0x7d
		 * - 0x7d 0x5e with 0x7e
		 */
		if (*data == 0x7d && len > 0) {
			if (*(data+1) == 0x5d) {
				*p++ = 0x7d;
				data++;
			}
			else if(*(data+1) == 0x5e) {
				*p++ = 0x7e;
				data++;
			}
		}
		else 
			*p++ = *data;

		*new_len += 1;
		p++;
		data++;
	}
	
	decoded_data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * (*new_len));
	memcpy(decoded_data, &tmp[0], *new_len);
}

