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

#if 0
struct call_status_event
{
	uint8_t unknown0;
	uint8_t call_id;
	uint8_t host_call_id;
	uint8_t unknown1;
	uint8_t caller_id[15];
	uint8_t unknown2[50];
	uint8_t caller_id_len;
	uint8_t unknown3[521];
	uint8_t cause_value0;
	uint8_t unknown4[4];
	uint8_t cause_value1;
	uint8_t unknown5[29];
	uint8_t cause_value2;
	uint8_t reject_type;
	uint8_t reject_value;
	uint8_t unknown3[479];
} __attribute__ ((packed));
#endif 

unsigned int group_call_is_valid(struct msmcomm_message *msg)
{
	return msg->group_id == 0x2;
}

void group_call_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{ 
	if (len != sizeof(struct call_status_event))
		return;

	msg->payload = data;
}

void group_call_free(struct msmcomm_message *msg)
{ 
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

unsigned int msmcomm_event_call_status_get_cause_value(struct msmcomm_message *msg)
{
	uint8_t value = 0xff;

	if (MESSAGE_CAST(msg, struct call_status_event)->cause_value0 == 0)
		return MESSAGE_CAST(msg, struct call_status_event)->cause_value1;

	if (MESSAGE_CAST(msg, struct call_status_event)->cause_value2 == 0)
		return MESSAGE_CAST(msg, struct call_status_event)->cause_value2;

	if (MESSAGE_CAST(msg, struct call_status_event)->reject_type == 0x3)
		value = 0xe1;


	return 0;
}


