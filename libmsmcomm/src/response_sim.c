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

/*
 * MSMCOMM_RESPONSE_GET_SIM_CAPABILITIES
 */

/* Notes:
 * - when the voice mail number is aquired, this messages contains it
 * - it's even the response for the verify-pin message
 */

unsigned int resp_get_sim_capabilities_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x10) && (msg->msg_id == 0x1);
}

void resp_get_sim_capabilities_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* FIXME */
}

uint32_t resp_get_sim_capabilities_get_size(struct msmcomm_message *msg)
{
	return 0;
}

/*
 * MSMCOMM_RESPONSE_READ_SIMBOOK
 */

unsigned int resp_read_simbook_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x19) && (msg->msg_id == 0x0);
}

void resp_read_simbook_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct read_simbook_resp))
		return;

	msg->payload = data;
	msg->ref_id = MESSAGE_CAST(msg, struct read_simbook_resp)->ref_id;

	/* handle message specifc error codes */
	if (MESSAGE_CAST(msg, struct read_simbook_resp)->result == 0xb)
		msg->success = 0;
}

uint32_t resp_read_simbook_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct read_simbook_resp);
}

uint16_t msmcomm_resp_read_simbook_get_record_id(struct msmcomm_message *msg)
{
	return MESSAGE_CAST(msg, struct read_simbook_resp)->record_id;
}

unsigned int msmcomm_resp_read_simbook_get_encoding_type(struct msmcomm_message *msg)
{
	switch(MESSAGE_CAST(msg, struct read_simbook_resp)->encoding_type) {
		case 0x4:
			return MSMCOMM_ENCODING_TYPE_ASCII;
		case 0x9:
			return MSMCOMM_ENCODING_TYPE_BUCS2;
	}

	return MSMCOMM_ENCODING_TYPE_NONE;
}

char* msmcomm_resp_read_simbook_get_number(struct msmcomm_message *msg)
{
	char *number = NULL;
	int len = 0;
	struct read_simbook_resp *resp = MESSAGE_CAST(msg, struct read_simbook_resp);

	if (resp->number == NULL)
		return NULL;

	len = strlen(resp->number) + 1;
	number = (uint8_t*)malloc(len * sizeof(char));
	memcpy(number, resp->number, len - 1);
	number[len-1] = 0;
	
	return number;
}

char* msmcomm_resp_read_simbook_get_title(struct msmcomm_message *msg)
{
	char *title = NULL;
	int len = 0;
	struct read_simbook_resp *resp = MESSAGE_CAST(msg, struct read_simbook_resp);

	if (resp->title == NULL)
		return NULL;

	len = strlen(resp->title) + 1;
	title = (uint8_t*)malloc(len * sizeof(char));
	memcpy(title, resp->title, len - 1);
	title[len-1] = 0;

	return title;
}



