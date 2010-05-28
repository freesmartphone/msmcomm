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

void msmcomm_message_change_operation_mode_set_operation_mode(struct msmcomm_message *msg, uint8_t operation_mode)
{
	if (operation_mode == MSMCOMM_OPERATION_MODE_RESET)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x7;
	else if (operation_mode == MSMCOMM_OPERATION_MODE_ONLINE)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x5;
	else if (operation_mode == MSMCOMM_OPERATION_MODE_OFFLINE)
		MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x6;
}

uint8_t* msg_change_operation_mode_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct change_operation_mode_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_TEST_ALIVE
 */

void msg_test_alive_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x1;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct test_alive_msg);
	
	MESSAGE_CAST(msg, struct test_alive_msg)->some_value0 = 0x5;
	MESSAGE_CAST(msg, struct test_alive_msg)->some_value1 = 0x1;
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
	MESSAGE_CAST(msg, struct get_firmware_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_GET_PHONE_STATE_INFO
 */

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

void msg_get_charger_status_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x15;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct charger_status_msg);
}

uint32_t msg_get_charger_status_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct charger_status_msg);
}

void msg_get_charger_status_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_get_charger_status_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct charger_status_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_CHARGING
 */

void msg_charging_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0x13;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct charging_msg);
}

uint32_t msg_charging_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct charging_msg);
}

void msg_charging_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_charging_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct charging_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

void msmcomm_message_charging_set_mode(struct msmcomm_message *msg, unsigned int mode)
{
	uint8_t new_mode;

	switch (mode) {
	case MSMCOMM_CHARGING_MODE_INDUCTIVE:
		new_mode = 0x2;
		break;
	case MSMCOMM_CHARGING_MODE_USB:
		new_mode = 0x1;
		break;
	default:
		return;
	}

	MESSAGE_CAST(msg, struct charging_msg)->mode = new_mode;
}

void msmcomm_message_charging_set_voltage
	(struct msmcomm_message *msg, unsigned int voltage)
{
	uint16_t new_voltage = 0;
	switch(voltage) {
	case MSMCOMM_CHARGING_VOLTAGE_MODE_250mA:
		new_voltage = 250;
		break;
	case MSMCOMM_CHARGING_VOLTAGE_MODE_500mA:
		new_voltage = 500;
		break;
	case MSMCOMM_CHARGING_VOLTAGE_MODE_1A:
		new_voltage = 1000;
		break;
	default:
		break;
	}

	/* little endian! */
	MESSAGE_CAST(msg, struct charging_msg)->voltage = 
		((new_voltage & 0xff) << 8) | ((new_voltage & 0xff00) >> 4);
}

/*
 * MSMCOMM_MESSAGE_CMD_SET_SYSTEM_TIME
 */
void msg_set_system_time_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x1b;
	msg->msg_id = 0xe;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct set_system_time_msg);
}

uint32_t msg_set_system_time_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct set_system_time_msg);
}

void msg_set_system_time_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_set_system_time_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct set_system_time_msg)->ref_id = msg->ref_id;
	MESSAGE_CAST(msg, struct set_system_time_msg)->static0 = 0x3;
	return msg->payload;
}

void msmcomm_message_set_system_time_set(struct msmcomm_message *msg,
										 uint16_t year, uint16_t month,
										 uint16_t day, uint16_t hour,
										 uint16_t minutes, uint16_t seconds,
										 int32_t timezone_offset)
{
	MESSAGE_CAST(msg, struct set_system_time_msg)->year = year;
	MESSAGE_CAST(msg, struct set_system_time_msg)->month = month;
	MESSAGE_CAST(msg, struct set_system_time_msg)->day = day;
	MESSAGE_CAST(msg, struct set_system_time_msg)->hour = hour;
	MESSAGE_CAST(msg, struct set_system_time_msg)->minutes = minutes;
	MESSAGE_CAST(msg, struct set_system_time_msg)->seconds = seconds;
	MESSAGE_CAST(msg, struct set_system_time_msg)->timezone_offset = timezone_offset;
}

/*
 * MSMCOMM_MESSAGE_CMD_RSSI_STATUS
 */

void msg_rssi_status_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x6;
	msg->msg_id = 0x1;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct rssi_status_msg);
}

uint32_t msg_rssi_status_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct rssi_status_msg);
}

void msg_rssi_status_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_rssi_status_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct rssi_status_msg)->ref_id = msg->ref_id;
	return msg->payload;
}

void msmcomm_message_rssi_status_set_status(struct msmcomm_message *msg, uint8_t status)
{
	MESSAGE_CAST(msg, struct rssi_status_msg)->status = status ? 1 : 0;
}

/*
 * MSMCOMM_MESSAGE_CMD_SET_MODE_PREFERENCE
 */

void msg_set_mode_preference_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x3;
	msg->msg_id = 0x1;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct set_mode_preference_msg);
}

uint32_t msg_set_mode_preference_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct set_mode_preference_msg);
}

void msg_set_mode_preference_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_set_mode_preference_prepare_data(struct msmcomm_message *msg)
{
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->ref_id = msg->ref_id;

	/* NOTE: The following values are the same for every mode! */
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value0 = 0x3;
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value1 = 0x40;
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value2 = 0x40;
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value3 = 0x1;
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value4 = 0x2;
	MESSAGE_CAST(msg, struct set_mode_preference_msg)->value5 = 0x4;
	
	return msg->payload;
}

void msmcomm_message_set_mode_preference_status_set_mode(struct msmcomm_message *msg, unsigned int mode)
{
	uint8_t mode_value = 0x0;
	
	switch (mode)
	{
		case MSMCOMM_NETWORK_MODE_AUTOMATIC:
			mode_value = 0x2;
			break;
		case MSMCOMM_NETWORK_MODE_GSM:
			mode_value = 0xd;
			break;
		case MSMCOMM_NETWORK_MODE_UMTS:
			mode_value = 0xe;
			break;
		default:
			INFO("You set some unknown preference mode. Please choose GSM, UMTS or AUTOMATIC.");
			return;
	}

	MESSAGE_CAST(msg, struct set_mode_preference_msg)->mode = mode_value;
}


