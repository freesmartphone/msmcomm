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
 * MSMCOMM_EVENT_PHONEBOOK_READY
 */

unsigned int event_phonebook_ready_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1a && msg->msg_id == 0x6);
}

void event_phonebook_ready_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct phonebook_ready_event))
		return;

	msg->payload = data;
}

uint32_t event_phonebook_ready_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct phonebook_ready_event);
}

unsigned int msmcomm_event_phonebook_ready_get_book_type(struct msmcomm_message *msg)
{
	unsigned int type = MSMCOMM_PHONEBOOK_TYPE_NONE;
	
	switch (MESSAGE_CAST(msg, struct phonebook_ready_event)->book_type)
	{
		case 0x1:
			type = MSMCOMM_PHONEBOOK_TYPE_ADN;
			break;
		case 0x3:
			type = MSMCOMM_PHONEBOOK_TYPE_FDN;
			break;
		case 0x5:
			type = MSMCOMM_PHONEBOOK_TYPE_EFECC;
			break;
		case 0xe:
			type = MSMCOMM_PHONEBOOK_TYPE_SDN;
			break;
		case 0x10:
			type = MSMCOMM_PHONEBOOK_TYPE_MBDN;
			break;
		case 0x1d:
			type = MSMCOMM_PHONEBOOK_TYPE_ALL;
			break;
	}

	return type;
}

