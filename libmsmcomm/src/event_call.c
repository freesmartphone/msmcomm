
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
 * Call status events
 */

unsigned int event_call_status_is_valid(struct msmcomm_message *msg)
{
    return msg->group_id == 0x2;
}

void event_call_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct call_status_event))
        return;

    msg->payload = data;
}

void event_call_status_free(struct msmcomm_message *msg)
{
}

unsigned int event_call_status_get_type(struct msmcomm_message *msg)
{
    switch (msg->msg_id)
    {
        case 0:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CALL_ORIGINATION;
        case 3:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CALL_END;
        case 5:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CALL_INCOMMING;
        case 6:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CALL_CONNECT;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_TYPE_INVALID;
}

uint8_t msmcomm_event_call_status_get_call_id(struct msmcomm_message * msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->call_id;
}

unsigned int msmcomm_event_call_status_get_call_type(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct call_status_event)->call_type)
    {
		case 0x2:
			return MSMCOMM_CALL_TYPE_AUDIO;
		case 0x1:
			return MSMCOMM_CALL_TYPE_DATA;
	}
	
	return MSMCOMM_CALL_TYPE_NONE;
}

char *msmcomm_event_call_status_get_caller_id(struct msmcomm_message *msg)
{
    char *tmp;

    int len = 0;

    if (msg->payload == NULL)
        return NULL;

    len = MESSAGE_CAST(msg, struct call_status_event)->caller_id_len;
    tmp = (char *)malloc(len + 1);
    memcpy(tmp, MESSAGE_CAST(msg, struct call_status_event)->caller_id, len);

    tmp[len] = 0;
    return tmp;
}

uint8_t msmcomm_event_call_status_get_reject_type(struct msmcomm_message * msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->reject_type;
}

uint8_t msmcomm_event_call_status_get_reject_value(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->reject_value;
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
