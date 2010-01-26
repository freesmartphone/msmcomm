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

struct change_operation_mode_msg
{
	uint8_t unknown0;
	uint8_t unknown1;
	uint8_t unknown3[3];
	uint8_t operator_mode;
} __attribute__ ((packed));

struct test_alive_msg
{
	uint8_t unknown[5];
} __attribute__ ((packed));

struct get_firmware_msg
{
	uint8_t unknown[5];
} __attribute__ ((packed));

void msg_change_operation_mode_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x3;
	msg->msg_id = 0x0;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct change_operation_mode_msg);

	/* second byte is always 0x2 */
	((struct change_operation_mode_msg*)msg->payload)->unknown1 = 0x2;
	
	msmcomm_message_change_operation_mode_set_operator_mode(msg, 0x7);
}

uint32_t msg_change_operation_mode_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct change_operation_mode_msg);
}

void msg_change_operation_mode_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

void msmcomm_message_change_operation_mode_set_operator_mode(struct msmcomm_message *msg, uint8_t operator_mode)
{
	uint8_t mode = 0;

	if (operator_mode == MSMCOMM_OPERATOR_MODE_RESET)
		mode = 7;
	else if (operator_mode == MSMCOMM_OPERATOR_MODE_ONLINE)
		mode = 5;

	MESSAGE_CAST(msg, struct change_operation_mode_msg)->operator_mode = operator_mode;
}

uint8_t* msg_change_operation_mode_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

void msg_test_alive_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x8;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct test_alive_msg);
}

uint32_t msg_test_alive_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct test_alive_msg);
}

void msg_test_alive_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_test_alive_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

void msg_get_firmware_info_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x08;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_firmware_msg);
}

uint32_t msg_get_firmware_info_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct get_firmware_msg);
}

void msg_get_firmware_info_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_get_firmware_info_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

