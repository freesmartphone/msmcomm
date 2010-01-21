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

extern void msg_change_operation_mode_init(struct msmcomm_message *msg);
extern uint32_t msg_change_operation_mode_get_size(struct msmcomm_message *msg);
extern void msg_change_operation_mode_free(struct msmcomm_message *msg);
extern uint8_t* msg_change_operation_mode_prepare_data(struct msmcomm_message *msg);

extern void msg_test_alive_init(struct msmcomm_message *msg);
extern uint32_t msg_test_alive_get_size(struct msmcomm_message *msg);
extern void msg_test_alive_free(struct msmcomm_message *msg);
extern uint8_t* msg_test_alive_prepare_data(struct msmcomm_message *msg);

extern void msg_get_imei_init(struct msmcomm_message *msg);
extern uint32_t msg_get_imei_get_size(struct msmcomm_message *msg);
extern void msg_get_imei_free(struct msmcomm_message *msg);
extern uint8_t* msg_get_imei_prepare_data(struct msmcomm_message *msg);

extern void msg_get_firmware_info_init(struct msmcomm_message *msg);
extern uint32_t msg_get_firmware_info_get_size(struct msmcomm_message *msg);
extern void msg_get_firmware_info_free(struct msmcomm_message *msg);
extern uint8_t* msg_get_firmware_info_prepare_data(struct msmcomm_message *msg);

struct message_descriptor msg_descriptors[] = {
	{	MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE, 
		msg_change_operation_mode_init, 
		msg_change_operation_mode_get_size, 
		msg_change_operation_mode_free,
		msg_change_operation_mode_prepare_data },
	{	MSMCOMM_MESSAGE_CMD_TEST_ALIVE,
		msg_test_alive_init,
		msg_test_alive_get_size,
		msg_test_alive_free,
		msg_test_alive_prepare_data },
	{	MSMCOMM_MESSAGE_CMD_GET_IMEI, 
		msg_get_imei_init, 
		msg_get_imei_get_size, 
		msg_get_imei_free,
		msg_get_imei_prepare_data },
	{	MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO, 
		msg_get_firmware_info_init, 
		msg_get_firmware_info_get_size, 
		msg_get_firmware_info_free,
		msg_get_firmware_info_prepare_data },
};

unsigned int msg_descriptors_size = (unsigned int)(sizeof(msg_descriptors) / sizeof(struct message_descriptor));

