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

extern void *talloc_msmc_ctx;

/*
 * MSMCOMM_RESPONSE_SOUND
 */

struct sound_resp
{
	uint8_t unknown[12];
} __attribute__ ((packed));

unsigned int resp_sound_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1f) && (msg->msg_id == 0x1);
}

void resp_sound_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct sound_resp)) {
		msg->payload = NULL;
		return;
	}

	msg->payload = talloc_zero(talloc_msmc_ctx, struct sound_resp);
	memcpy(&msg->payload, data, len);
}

void resp_sound_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}
