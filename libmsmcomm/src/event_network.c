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
 * MSMCOMM_EVENT_CM_SS
 */

struct cm_ss_event
{
	uint8_t unknown0;
	uint8_t change_field[2];
	uint8_t unknown1[13];
	uint8_t plmn[3];
	uint8_t unknown2[3];
	uint8_t operator_name_len;
	uint8_t operator_name[80];
	uint8_t unknown10[575];
} __attribute__ ((packed));

unsigned int event_cm_ss_is_valid(struct msmcomm_message *msg)
{
	/* event cm_ss seems to be have both msgId 0x0 and 0x1 */
	return ((msg->group_id == 0x8) && (msg->msg_id == 0x0 || msg->msg_id == 0x1));
}

void event_cm_ss_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
}

void event_cm_ss_free(struct msmcomm_message *msg)
{
}

