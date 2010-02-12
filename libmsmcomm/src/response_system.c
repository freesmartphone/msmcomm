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

#if 0
struct get_firmware_info_resp
{
	uint8_t unknown0[5];
	uint8_t hci_version;
	uint8_t unknown1[3];
	uint8_t firmware_version[13];
	uint8_t unknown2[122];
} __attribute__ ((packed));
#endif

unsigned int resp_get_firmware_info_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0xa);
}

void resp_get_firmware_info_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct get_firmware_info_resp)) {
		return;
	}

	msg->payload = data;
}

void resp_get_firmware_info_free(struct msmcomm_message *msg)
{
}

uint8_t msmcomm_resp_get_firmware_info_get_hci_version(struct msmcomm_message *msg)
{
	return MESSAGE_CAST(msg, struct get_firmware_info_resp)->hci_version;
}

void msmcomm_resp_get_firmware_info_get_info(struct msmcomm_message *msg, char *buffer, int len)
{
	snprintf(buffer, len, "%s", MESSAGE_CAST(msg, struct get_firmware_info_resp)->firmware_version);
}

/*
 * MSMCOMM_RESPONSE_GET_IMEI
 */

#if 0
struct get_imei_resp
{
	uint8_t unknown[5];
	uint8_t imei[17];
} __attribute__ ((packed));
#endif

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

	msg->payload = data;
}

void msmcomm_resp_get_imei_get_imei(struct msmcomm_message *msg, uint8_t *buffer, int len)
{
	int n;
	struct get_imei_resp *resp;

	/* we need a least a buffer with 17 chars */
	if (len < 17)
		return;

	resp = (struct get_imei_resp*) msg->payload;

	/* imei consists of 17 bytes - each byte is one number of the imei */
	for (n = 0; n < 17; n++) {
		buffer[n] = 0x30 + resp->imei[n];
	}
}

void resp_get_imei_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_RESPONSE_GET_CHARGER_STATUS
 */

#if 0
struct get_charger_status_resp
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown1[4];
	uint16_t voltage;
	uint8_t unknown2[6];
} __attribute__ ((packed));
#endif

unsigned int resp_get_charger_status_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0x16);
}

void resp_get_charger_status_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct get_charger_status_resp))
		return;

	msg->payload = data;
}

void resp_get_charger_status_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_RESPONSE_CARGE_USB
 */

#if 0
struct charge_usb_resp
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown1[4];
	uint16_t voltage;
	uint8_t unknown2[2];
} __attribute__ ((packed));
#endif

unsigned int resp_charge_usb_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1c) && (msg->msg_id == 0x14);
}

void resp_charge_usb_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct charge_usb_resp))
		return;

	msg->payload = data;
}

void resp_charge_usb_free(struct msmcomm_message *msg)
{
}

unsigned int msmcomm_resp_charge_usb_get_voltage(struct msmcomm_message *msg)
{
	/* FIXME */
	return MSMCOMM_CHARGE_USB_MODE_500mA;
}

