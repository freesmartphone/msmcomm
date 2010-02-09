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
 * MSMCOMM_MESSAGE_CMD_VERIFY_PIN
 */
#if 0
struct verify_pin_msg
{
	uint8_t unknown0;
	uint8_t pin_type;
	uint8_t unknown1[4];
	uint8_t pin[8]; /* pin can be 4 or 8 bytes long */
	uint8_t unknown2;
} __attribute__ ((packed));
#endif

void msg_verify_pin_init(struct msmcomm_message *msg)
{
	msg->group_id = 0xf;
	msg->msg_id = 0xe;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct verify_pin_msg);

	/* we think the second bytes includes the pin type */
	MESSAGE_CAST(msg, struct verify_pin_msg)->pin_type = 0x12;
}

uint32_t msg_verify_pin_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct verify_pin_msg);
}

void msg_verify_pin_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_verify_pin_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

/* note: pin is passed as ascii chars! */
void msmcomm_message_verify_pin_set_pin(struct msmcomm_message *msg, uint8_t *pin, int len)
{
	if (len != 4 && len != 8)
		return;

	memcpy(MESSAGE_CAST(msg, struct verify_pin_msg)->pin, pin, len);
}
