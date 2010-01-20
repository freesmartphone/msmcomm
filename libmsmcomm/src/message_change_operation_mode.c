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

#include <msmcomm/internal.h>

struct change_operation_mode_msg
{
	uint8_t unknown0;
	uint8_t unknown1;
	uint8_t unknown3[3];
	uint8_t operator_mode;
}

void msg_change_operation_mode_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x3;
	msg->msg_id = 0x0;

	msg->payload = (struct change_operation_mode_msg*) 
		calloc(sizeof(struct change_operation_mode_msg), 1);

	/* second byte is always 0x2 */
	((struct change_operation_mode_msg)msg->payload)->unknown1 = 0x2;
	
	msmcomm_message_change_operation_mode_set_operator_mode(msg, 0x7);
}

void msg_change_operation_mode_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct change_operation_mode_msg);
}

void msg_change_operation_mode_free(struct msmcomm_message *msg)
{
	free(msg->payload);
}

void msmcomm_message_change_operation_mode_set_operator_mode(struct msmcomm_message *msg, uint8_t operator_mode)
{
	((struct change_operation_mode_msg)msg->payload)->operator_mode = operator_mode;
}

