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

#define MESSAGE_TYPE(name) \
	extern void msg_##name##_init(struct msmcomm_message *msg); \
	extern uint32_t msg_##name##_get_size(struct msmcomm_message *msg); \
	extern void msg_##name##_free(struct msmcomm_message *msg); \
	extern uint8_t msg_##name##_prepare_data(struct msmcomm_message *msg);

#define MESSAGE_DATA(type, name) \
	{	type, \
		msg_##name##_init, \
		msg_##name##_get_size, \
		msg_##name##_free, \
		msg_##name##_prepare_data }

MESSAGE_TYPE(change_operation_mode)
MESSAGE_TYPE(test_alive)
MESSAGE_TYPE(get_imei)
MESSAGE_TYPE(get_firmware_info)

struct message_descriptor msg_descriptors[] = {
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE,change_operation_mode),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_TEST_ALIVE, test_alive),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_IMEI, get_imei),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO, get_firmware_info),
};

unsigned int msg_descriptors_size = (unsigned int)(sizeof(msg_descriptors) / sizeof(struct message_descriptor));

