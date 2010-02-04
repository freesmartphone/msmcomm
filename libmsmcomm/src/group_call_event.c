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
 * Call event group handler
 */

struct call_status_event
{
	uint8_t unknown0;
	uint8_t call_id;
	uint8_t host_call_id;
	uint8_t unknown1;
	uint8_t caller_id[15];
	uint8_t unknown2[50];
	uint8_t caller_id_len;
	uint8_t unknown3[1038];
} __attribute__ ((packed));

unsigned int group_call_is_valid(struct msmcomm_message *msg)
{
	return msg->group_id == 0x2;
}

void group_call_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{ 
	if (len != sizeof(struct call_status_event))
		return;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct call_status_event);
	memcpy(msg->payload, data, len);
}

void group_call_free(struct msmcomm_message *msg)
{ 
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}

unsigned int group_call_get_type(struct msmcomm_message *msg)
{
	switch(msg->msg_id) {
	case 0:
		return MSMCOMM_EVENT_CALL_ORIGINATION;
	case 5:
		return MSMCOMM_EVENT_CALL_INCOMMING;
	case 6:
		return MSMCOMM_EVENT_CALL_CONNECT;
	case 3:
		return MSMCOMM_EVENT_CALL_END;
	default:
		break;
	}
	
	return MSMCOMM_MESSAGE_INVALID;
}

void msmcomm_event_call_status_get_caller_id
	(struct msmcomm_message *msg, uint8_t *buffer, unsigned int len) 
{
	snprintf(buffer, len, "%s", 
			 MESSAGE_CAST(msg, struct call_status_event)->caller_id);
}


