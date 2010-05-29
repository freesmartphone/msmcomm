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
	extern uint8_t* msg_##name##_prepare_data(struct msmcomm_message *msg);

#define MESSAGE_DATA(type, name) \
	{	type, \
		msg_##name##_get_size, \
		msg_##name##_init, \
		msg_##name##_free, \
		msg_##name##_prepare_data, \
		NULL, NULL, NULL }

MESSAGE_TYPE(change_operation_mode)
MESSAGE_TYPE(test_alive)
MESSAGE_TYPE(get_imei)
MESSAGE_TYPE(get_firmware_info)
MESSAGE_TYPE(get_phone_state_info)
MESSAGE_TYPE(verify_pin)
MESSAGE_TYPE(get_location_priv_pref)
MESSAGE_TYPE(answer_call)
MESSAGE_TYPE(set_audio_profile)
MESSAGE_TYPE(end_call)
MESSAGE_TYPE(dial_call)
MESSAGE_TYPE(get_charger_status)
MESSAGE_TYPE(charging)
MESSAGE_TYPE(set_system_time)
MESSAGE_TYPE(rssi_status)
MESSAGE_TYPE(read_simbook)
MESSAGE_TYPE(get_networklist)
MESSAGE_TYPE(set_mode_preference)
MESSAGE_TYPE(get_phonebook_properties)

struct descriptor msg_descriptors[] = {
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE,change_operation_mode),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_TEST_ALIVE, test_alive),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_IMEI, get_imei),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO, get_firmware_info),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_PHONE_STATE_INFO, get_phone_state_info),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_VERIFY_PIN, verify_pin),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_LOCATION_PRIV_PREF, get_location_priv_pref),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_ANSWER_CALL, answer_call),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_SET_AUDIO_PROFILE, set_audio_profile),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_END_CALL, end_call),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_DIAL_CALL, dial_call),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_CHARGER_STATUS, get_charger_status),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_CHARGING, charging),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_SET_SYSTEM_TIME, set_system_time),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_RSSI_STATUS, rssi_status),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_READ_SIMBOOK, read_simbook),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_NETWORKLIST, get_networklist),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_SET_MODE_PREFERENCE, set_mode_preference),
	MESSAGE_DATA(MSMCOMM_MESSAGE_CMD_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties),
};

unsigned int msg_descriptors_size = (unsigned int)(sizeof(msg_descriptors) / sizeof(struct descriptor));

