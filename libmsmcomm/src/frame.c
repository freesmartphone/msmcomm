/* 
 * (c) 2010 by Simon Busch <morphis@gravedo.de>
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

#include "internal.h"

struct msmcomm_frame {
	uint8_t 	address;
	uint8_t 	type;
	uint8_t 	unknown;
	uint8_t 	seq;
	uint8_t 	ack;
	uint8_t 	*payload;
	uint32_t 	payload_len;
	uint8_t 	is_valid;
};

struct msmcomm_frame * msmcomm_frame_new()
{
	struct msmcomm_frame *fr = (struct msmcomm_frame*)malloc(sizeof(struct msmcomm_frame));
	fr->address = 0xfa;
	fr->type = 0x0;
	fr->unknown = 0;
	fr->seq = 0;
	fr->ack = 0;
	fr->payload = NULL;
	fr->payload_len = 0;
	fr->is_valid = 0;
	return fr;
}

void msmcomm_frame_free(struct msmcomm_frame *fr)
{
    if (fr->payload != NULL)
        free(fr->payload);
    free(fr);
}

struct msmcomm_frame * msmcomm_frame_new_from_buffer(uint8_t *buffer, uint32_t length) 
{
	uint8_t *p, *start, *end, *tmp;
	uint8_t found = 0;
	int len, tmp_len;
	struct msmcomm_frame *fr = NULL;
	unsigned short crc, fr_crc, crc_result = 0xf0b8;

	// try to find a valid frame
	p = buffer;
	start = p;
	end = p + length;
	while(p <= end) {
		if (*p == 0x7e) {
			found = 1;
			break;
			start = p + 1;
		}
		p++;
	}

	// If we found a frame, disassemble it!
	if (found) {
		fr = msmcomm_frame_new();
		len = p - start;

		/* copy data for decoding */
		tmp = calloc(sizeof(uint8_t), len);
		memcpy(tmp, buffer, len);
		fr->payload = tmp;
		fr->payload_len = len;

		/* decode frame */
		msmcomm_frame_decode(fr);
		tmp_len = fr->payload_len;
	
		/* the last two bytes are the crc checksum, check them! */
		fr_crc = (tmp[len-2] << 8) | tmp[len-1];
		crc = crc16_calc(tmp, tmp_len);
		if (crc != crc_result)
			fr->is_valid = 0;
		else fr->is_valid = 1;

		/* parse frame data */
		fr->address = tmp[0];
		fr->type = tmp[1] >> 4;
		fr->seq  = tmp[2] >> 4;
		fr->ack  = tmp[2] & 0xf;
		fr->payload = NULL;
		fr->payload_len = 0;
		if (len > 5) {
			fr->payload = (uint8_t*)malloc(sizeof(uint8_t) * (tmp_len - 3));
			memcpy(fr->payload, &tmp[3], tmp_len - 5);
			fr->payload_len = tmp_len - 5;
		}
	}

	return fr;
}

void msmcomm_frame_set_payload(struct msmcomm_frame *fr, uint8_t *payload, uint32_t length) 
{
	fr->payload = (uint8_t*)malloc(sizeof(uint8_t) * length);
	memcpy(fr->payload, payload, length);
	fr->payload_len = length;
}

void msmcomm_frame_set_address(struct msmcomm_frame *fr, uint8_t addr) 
{
	fr->address = addr;
}

void msmcomm_frame_set_type(struct msmcomm_frame *fr, uint8_t type) 
{
	fr->type = type;
}

void msmcomm_frame_set_sequence_nr(struct msmcomm_frame *fr, uint8_t seq) 
{
	fr->seq = seq;
}

void msmcomm_frame_set_acknowledge_nr(struct msmcomm_frame *fr, uint8_t ack) 
{
	fr->ack = ack;
}

uint8_t msmcomm_frame_get_address(struct msmcomm_frame *fr) 
{
	return fr->address;
}

uint8_t msmcomm_frame_get_type(struct msmcomm_frame *fr) 
{
	return fr->type;
}

uint8_t msmcomm_frame_get_sequence_nr(struct msmcomm_frame *fr) 
{
	return fr->seq;
}

uint8_t msmcomm_frame_get_acknowledge_nr(struct msmcomm_frame *fr) 
{
	return fr->ack;
}

uint32_t msmcomm_frame_get_payload_length(struct msmcomm_frame *fr)
{
	return fr->payload_len;
}

uint8_t* msmcomm_frame_get_payload(struct msmcomm_frame *fr, int *length) 
{
	*length = fr->payload_len;
	return fr->payload;
}

uint8_t msmcomm_frame_is_valid(struct msmcomm_frame *fr) 
{
	return fr->is_valid;
}

void msmcomm_frame_encode(struct msmcomm_frame *fr)
{
	if (!fr || fr->payload_len == 0) 
		return;

	uint8_t *encoded_data = (uint8_t*)calloc(fr->payload_len, sizeof(uint8_t));
	uint8_t *p = encoded_data;
	uint8_t *data = fr->payload;
	uint32_t encoded_data_len = fr->payload_len;

	while(fr->payload_len--) {
		/* replace: 
		 * 0x7d with 0x7d 0x5d
		 * 0x7e with 0x7d 0x5e
		 */
		if (*data == 0x7d || *data == 0x7e) {
			encoded_data = (uint8_t*)realloc(encoded_data, sizeof(uint8_t) * ++encoded_data_len);
			*p = 0x7d; p++;
			*p = (0x5 << 4) | (*data & 0xf); p++;
			data++;
		}
		else {
			*p = *data;
			p++; data++;
		}
	}
	
	fr->payload = (uint8_t*)realloc(fr->payload, sizeof(uint8_t) * encoded_data_len);	
	memcpy(fr->payload, encoded_data, encoded_data_len);
	fr->payload_len = encoded_data_len;
}

void msmcomm_frame_decode(struct msmcomm_frame *fr)
{
	if (!fr || fr->payload_len == 0) 
		return;
	
	uint8_t *decoded_data = calloc(fr->payload_len, sizeof(uint8_t));
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
				decoded_data = (uint8_t*)realloc(decoded_data, sizeof(uint8_t) * --decoded_data_len);
			}
		}
		else 
		{
			*p = *data;
			p++; data++;
		}
 	}

	fr->payload = (uint8_t*)realloc(fr->payload, sizeof(uint8_t) * decoded_data_len);
	memcpy(fr->payload, decoded_data, decoded_data_len);
	fr->payload_len = decoded_data_len;
}

