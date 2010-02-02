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
 * MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE
 */

/*
onlineMode: 
			fa 00 00 03 00
			00 00 00 00 00 
			05 f0 09 7e

offlineMode:
			fa 00 00 03 00
			00 00 00 00 00
			06 3b 36 7e
*/

struct change_operation_mode_msg
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown3[3];
	uint8_t operator_mode;
} __attribute__ ((packed));

void msg_change_operation_mode_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x3;
	msg->msg_id = 0x0;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct change_operation_mode_msg);
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
	if (operator_mode == MSMCOMM_OPERATION_MODE_RESET)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operator_mode = 0x7;
	else if (operator_mode == MSMCOMM_OPERATION_MODE_ONLINE)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operator_mode = 0x5;
	else if (operator_mode == MSMCOMM_OPERATION_MODE_OFFLINE)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operator_mode = 0x6;
}

uint8_t* msg_change_operation_mode_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct change_operation_mode_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_TEST_ALIVE
 */

struct test_alive_msg
{
	uint8_t unknown[6];
} __attribute__ ((packed));

void msg_test_alive_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x1;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct test_alive_msg);

	MESSAGE_CAST(msg, struct test_alive_msg)->unknown[1] = 0x5;
	MESSAGE_CAST(msg, struct test_alive_msg)->unknown[5] = 0x1;
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

/*
 * MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO
 */

struct get_firmware_msg
{
	uint8_t unknown[5];
} __attribute__ ((packed));

void msg_get_firmware_info_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x9;

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

/*
 * MSMCOMM_MESSAGE_CMD_GET_PHONE_STATE_INFO
 */

struct get_phone_state_info_msg
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown[3];
} __attribute__ ((packed));

void msg_get_phone_state_info_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x3;
	msg->msg_id = 0x5;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_phone_state_info_msg);
}

uint32_t msg_get_phone_state_info_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct get_phone_state_info_msg);
}

void msg_get_phone_state_info_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_get_phone_state_info_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct get_phone_state_info_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_SET_AUDIO_PROFILE
 */
 
/* [CMD] tel.setaudioprofile 0 0
 * handleAudioSettingsMessage Audio Profile Class 0 SubClass 0
 * handleAudioSettingsMessage USER TTY FLAG 3
 * handleAudioSettingsMessage !!!!!!!!!DISABLING TTY!!!!!!!!!
 * .305297Z365ff490 +convertTilAudioProfileToHciSoundDevice 
 * .306762Z375ff490 waitForSignal Forever signal=35D85CE0
 * .307830Z365ff490 -convertTilAudioProfileToHciSoundDevice 
 * .309387Z375ff490 +waitForSignal 
 * .310485Z365ff490 setAudioProfile setAudioProfile 0 0
 * PACKET: dir=write fd=11 fn='/dev/modemuart' len=16/0x10
 * frame (type=Data, seq=05, ack=0c)
 * 1e 00 00 3c 00 00 00 00 00 00 00 00 00            ...<.........   
 */
 
struct set_audio_profile_msg
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown1[9];
} __attribute__ ((packed));

void msg_set_audio_profile_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1e;
	msg->msg_id = 0x0;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct set_audio_profile_msg);
}

uint32_t msg_set_audio_profile_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct set_audio_profile_msg);
}

void msg_set_audio_profile_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_set_audio_profile_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct set_audio_profile_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_GET_CHARGER_STATUS
 */

struct get_charger_status_msg
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown1[12];
} __attribute__ ((packed));

void msg_get_charger_status_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x15;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_charger_status_msg);

	MESSAGE_CAST(msg, struct get_charger_status_msg)->ref_id = 0x0;
}

uint32_t msg_get_charger_status_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct get_charger_status_msg);
}

void msg_get_charger_status_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_get_charger_status_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_CHARGE_USB
 */

struct charge_usb_msg
{
	uint8_t unknown0;
	uint8_t ref_id;
	uint8_t unknown1[4];
	uint16_t voltage;
	uint8_t unknown2[2];
} __attribute__ ((packed));

void msg_charge_usb_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x15;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct charge_usb_msg);
}

uint32_t msg_charge_usb_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct charge_usb_msg);
}

void msg_charge_usb_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_charge_usb_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct charge_usb_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

void msmcomm_message_charge_usb_set_mode(struct msmcomm_message *msg, unsigned int mode)
{
	uint16_t voltage = 0;
	switch(mode) {
	case MSMCOMM_CHARGE_USB_MODE_250mA:
		voltage = 250;
		break;
	case MSMCOMM_CHARGE_USB_MODE_500mA:
		voltage = 500;
		break;
	case MSMCOMM_CHARGE_USB_MODE_1A:
		voltage = 1000;
		break;
	default:
		break;
	}

	/* little endian! */
	MESSAGE_CAST(msg, struct charge_usb_msg)->voltage = ((voltage & 0xff) << 8) | ((voltage & 0xff00) >> 4);
}

