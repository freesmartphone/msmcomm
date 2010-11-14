
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

DEFINE_MESSAGE_TYPE(change_operation_mode)
DEFINE_MESSAGE_TYPE(test_alive)
DEFINE_MESSAGE_TYPE(get_imei)
DEFINE_MESSAGE_TYPE(get_firmware_info)
DEFINE_MESSAGE_TYPE(get_phone_state_info)
DEFINE_MESSAGE_TYPE(verify_pin)
DEFINE_MESSAGE_TYPE(get_location_priv_pref)
DEFINE_MESSAGE_TYPE(answer_call)
DEFINE_MESSAGE_TYPE(set_audio_profile)
DEFINE_MESSAGE_TYPE(end_call)
DEFINE_MESSAGE_TYPE(dial_call)
DEFINE_MESSAGE_TYPE(get_charger_status)
DEFINE_MESSAGE_TYPE(charging)
DEFINE_MESSAGE_TYPE(set_system_time)
DEFINE_MESSAGE_TYPE(rssi_status)
DEFINE_MESSAGE_TYPE(read_phonebook)
DEFINE_MESSAGE_TYPE(get_networklist)
DEFINE_MESSAGE_TYPE(write_phonebook)
DEFINE_MESSAGE_TYPE(delete_phonebook)
DEFINE_MESSAGE_TYPE(change_pin)
DEFINE_MESSAGE_TYPE(enable_pin)
DEFINE_MESSAGE_TYPE(disable_pin)
DEFINE_MESSAGE_TYPE(sim_info)
DEFINE_MESSAGE_TYPE(set_mode_preference) 
DEFINE_MESSAGE_TYPE(get_phonebook_properties)
DEFINE_MESSAGE_TYPE(get_audio_modem_tuning_params)
DEFINE_MESSAGE_TYPE(sms_acknowledge_incommming_message)
DEFINE_MESSAGE_TYPE(manage_calls)
//DEFINE_MESSAGE_TYPE(sms_get_sms_center_number)
DEFINE_MESSAGE_TYPE(get_home_network_name)

struct descriptor msg_descriptors[] = {
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE, change_operation_mode),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_TEST_ALIVE, test_alive),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_IMEI, get_imei),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_FIRMWARE_INFO, get_firmware_info),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONE_STATE_INFO, get_phone_state_info),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_VERIFY_PIN, verify_pin),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_LOCATION_PRIV_PREF, get_location_priv_pref),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_ANSWER_CALL, answer_call),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_AUDIO_PROFILE, set_audio_profile),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_END_CALL, end_call),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_DIAL_CALL, dial_call),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_CHARGER_STATUS, get_charger_status),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_CHARGING, charging),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_SYSTEM_TIME, set_system_time),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_RSSI_STATUS, rssi_status),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_READ_PHONEBOOK, read_phonebook),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_NETWORKLIST, get_networklist),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SET_MODE_PREFERENCE, set_mode_preference),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_WRITE_PHONEBOOK, write_phonebook),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_DELETE_PHONEBOOK, delete_phonebook),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_PIN, change_pin),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_ENABLE_PIN, enable_pin),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_DISABLE_PIN, disable_pin),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SIM_INFO, sim_info),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS, get_audio_modem_tuning_params),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE, sms_acknowledge_incommming_message),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_MANAGE_CALLS, manage_calls),
    //REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_GET_SMS_CENTER_NUMBER, sms_get_sms_center_number),
    REGISTER_MESSAGE_TYPE(MSMCOMM_MESSAGE_TYPE_COMMAND_GET_HOME_NETWORK_NAME, get_home_network_name),
};

unsigned int msg_descriptors_size = ARRAY_SIZE(msg_descriptors, struct descriptor);
