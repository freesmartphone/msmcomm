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

void encode_frame(struct frame *fr)
{
	uint8_t *encoded_data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * fr->payload_len);
	uint8_t *p = encoded_data;
	uint8_t *data = fr->payload;
	uint32_t encoded_data_len = fr->payload_len;
	
	while(fr->payload_len--) {
		/* replace: 
		 * 0x7d with 0x7d 0x5d
		 * 0x7e with 0x7d 0x5e
		 */
		if (*data == 0x7d || *data == 0x7e) {
			encoded_data = talloc_realloc(talloc_llc_ctx, encoded_data, uint8_t, 
										  ++encoded_data_len);
			*p = 0x7d; p++;
			*p = (0x5 << 4) | (*data & 0xf); p++;
			data++;
		}
		else {
			*p = *data;
			p++; data++;
		}
	}
	
	talloc_free(fr->payload);
	fr->payload = talloc_zero_size(talloc_llc_ctx, sizeof(uint8_t) * encoded_data_len);	
	memcpy(fr->payload, encoded_data, encoded_data_len);
	fr->payload_len = encoded_data_len;
	talloc_free(encoded_data);
}

void decode_frame(struct frame *fr)
{
	uint8_t *decoded_data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * fr->payload_len);
	uint8_t *p = decoded_data;
	uint8_t *data = fr->payload;
	uint8_t *tmp = 0;
	uint32_t decoded_data_len = fr->payload_len;

	while(fr->payload_len--) {
		if (*data == 0x7d)
		{
			/* replace:
			* - 0x7d 0x5d with 0x7d
			* - 0x7d 0x5e with 0x7e
			*/
			tmp = data + 1;
			if (*tmp && (*tmp == 0x5d || *tmp == 0x5e)) {
				data += 2;
				*p++ = 0x70 | (*tmp & 0xf);
				decoded_data = talloc_realloc(talloc_llc_ctx, decoded_data, uint8_t,
											  --decoded_data_len);
			}
		}
		else 
		{
			*p = *data;
			p++; data++;
		}
 	}

	fr->payload = talloc_realloc(talloc_llc_ctx, fr->payload, uint8_t, decoded_data_len);
	memcpy(fr->payload, decoded_data, decoded_data_len);
	fr->payload_len = decoded_data_len;
	talloc_free(decoded_data);
}
