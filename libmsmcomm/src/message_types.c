
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
MESSAGE_TYPE(read_phonebook)
MESSAGE_TYPE(get_networklist)
MESSAGE_TYPE(write_phonebook)
MESSAGE_TYPE(delete_phonebook)
MESSAGE_TYPE(change_pin)
MESSAGE_TYPE(enable_pin)
MESSAGE_TYPE(disable_pin)
MESSAGE_TYPE(sim_info)
MESSAGE_TYPE(set_mode_preference) 
MESSAGE_TYPE(get_phonebook_properties)
MESSAGE_TYPE(get_audio_modem_tuning_params)
MESSAGE_TYPE(sms_acknowledge_incommming_message)
MESSAGE_TYPE(manage_calls)
//MESSAGE_TYPE(sms_get_sms_center_number)

struct descriptor msg_descriptors[] = {
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE, change_operation_mode),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_TEST_ALIVE, test_alive),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_IMEI, get_imei),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_FIRMWARE_INFO, get_firmware_info),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONE_STATE_INFO, get_phone_state_info),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_VERIFY_PIN, verify_pin),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_LOCATION_PRIV_PREF, get_location_priv_pref),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_ANSWER_CALL, answer_call),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_AUDIO_PROFILE, set_audio_profile),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_END_CALL, end_call),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_DIAL_CALL, dial_call),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_CHARGER_STATUS, get_charger_status),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_CHARGING, charging),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_SYSTEM_TIME, set_system_time),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_RSSI_STATUS, rssi_status),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_READ_PHONEBOOK, read_phonebook),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_NETWORKLIST, get_networklist),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_MODE_PREFERENCE, set_mode_preference),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_WRITE_PHONEBOOK, write_phonebook),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_DELETE_PHONEBOOK, delete_phonebook),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_PIN, change_pin),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_ENABLE_PIN, enable_pin),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_DISABLE_PIN, disable_pin),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SIM_INFO, sim_info),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS, get_audio_modem_tuning_params),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE, sms_acknowledge_incommming_message),
    MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_MANAGE_CALLS, manage_calls),
   //MESSAGE_DATA(MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_GET_SMS_CENTER_NUMBER, sms_get_sms_center_number),
};

unsigned int msg_descriptors_size =
    (unsigned int)(sizeof (msg_descriptors) / sizeof (struct descriptor));
    
