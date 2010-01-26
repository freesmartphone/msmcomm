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
 * MSMCOMM_RESPONSE_TEST_ALIVE
 */

struct test_alive_resp
{
} __attribute__ ((packed));

unsigned int resp_test_alive_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
}

void resp_test_alive_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* FIXME */
}

void resp_test_alive_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_RESPONSE_GET_FIRMWARE_INFO
 */

struct get_firmware_info_resp
{
	uint8_t unknown0[5];
	uint8_t hci_version;
	uint8_t unknown1[3];
	uint8_t firmware_version[13];
	uint8_t unknown2[122];
} __attribute__ ((packed));

unsigned int resp_get_firmware_info_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0xa);
}

void resp_get_firmware_info_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct get_firmware_info_resp)) {
		msg->payload = NULL;
		return;
	}

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_firmware_info_resp);
	memcpy(&msg->payload, data, len);
}

void resp_get_firmware_info_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}

void msmcomm_message_get_firmware_info_get_info(struct msmcomm_message *msg, char *buffer, int len)
{
	snprintf(buffer, len, "%s", MESSAGE_CAST(msg, struct
											 get_firmware_info_resp)->firmware_version);
}

/*
 * MSMCOMM_RESPONSE_GET_IMEI
 */

struct get_imei_resp
{
	uint8_t unknown[5];
	uint8_t imei[17];
} __attribute__ ((packed));

unsigned int resp_get_imei_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0x9);
}

void resp_get_imei_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct get_imei_resp)) {
		msg->payload = NULL;
		return;
	}

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_imei_resp);
	memcpy(&msg->payload, data, len);
}

void resp_get_imei_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}

