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

DEFINE_RESPONSE_TYPE(get_imei) 
DEFINE_RESPONSE_TYPE(get_firmware_info) 
DEFINE_RESPONSE_TYPE(test_alive)
DEFINE_RESPONSE_TYPE(sim)
DEFINE_RESPONSE_TYPE(sound)
DEFINE_RESPONSE_TYPE(cm_call)
DEFINE_RESPONSE_TYPE(charging)
DEFINE_RESPONSE_TYPE(charger_status)
DEFINE_RESPONSE_TYPE(cm_ph)
DEFINE_RESPONSE_TYPE(set_system_time)
DEFINE_RESPONSE_TYPE(rssi_status)
DEFINE_RESPONSE_TYPE(phonebook)
DEFINE_RESPONSE_TYPE(get_phonebook_properties)
DEFINE_RESPONSE_TYPE(audio_modem_tuning_params)
DEFINE_RESPONSE_TYPE(get_home_network_name)

DEFINE_EVENT_TYPE(radio_reset_ind)
DEFINE_EVENT_TYPE(charger_status)
DEFINE_EVENT_TYPE(operator_mode) 
DEFINE_EVENT_TYPE(cm_ph_info_available) 
DEFINE_EVENT_TYPE(get_networklist)
DEFINE_EVENT_TYPE(cm_ph)
DEFINE_EVENT_TYPE(power_state)
DEFINE_EVENT_TYPE(network_state_info)
DEFINE_EVENT_TYPE(phonebook_ready) 
DEFINE_EVENT_TYPE(phonebook_modified)
DEFINE_EVENT_TYPE(sms_recieved_message)
DEFINE_EVENT_TYPE(phonebook_record_added)
DEFINE_EVENT_TYPE(phonebook_record_updated)
DEFINE_EVENT_TYPE(phonebook_record_deleted)
DEFINE_EVENT_TYPE(phonebook_record_failed)

DEFINE_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(call_status)
DEFINE_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sim_status)
DEFINE_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sups_status)
DEFINE_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sms_status)

struct descriptor response_descriptors[] = 
{
    /* responses */
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_TEST_ALIVE, test_alive, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_FIRMWARE_INFO, get_firmware_info, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_IMEI, get_imei, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_SIM, sim, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_SOUND, sound, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_CALL, cm_call, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_CHARGING, charging, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_CHARGER_STATUS, charger_status, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_PH, cm_ph, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_SET_SYSTEM_TIME, set_system_time, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_RSSI_STATUS, rssi_status, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_PHONEBOOK, phonebook, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_AUDIO_MODEM_TUNING_PARAMS, audio_modem_tuning_params, 0),
    REGISTER_RESPONSE_TYPE(MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_HOME_NETWORK_NAME, get_home_network_name, 0),

    /* events */
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_RESET_RADIO_IND, radio_reset_ind, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_CHARGER_STATUS, charger_status, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_OPERATION_MODE, operator_mode, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO_AVAILABLE, cm_ph_info_available, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_NETWORK_STATE_INFO, network_state_info, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_GET_NETWORKLIST, get_networklist, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_READY, phonebook_ready, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_MODIFIED, phonebook_modified, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH, cm_ph, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_SMS_RECEIVED_MESSAGE, sms_recieved_message, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_ADDED, phonebook_record_added, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_UPDATED, phonebook_record_updated, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_DELETED, phonebook_record_deleted, 0),
    REGISTER_EVENT_TYPE(MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_FAILED, phonebook_record_failed, 0),

    REGISTER_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(call_status, 0),
    REGISTER_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sim_status, 0),
    REGISTER_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sups_status, 0),
    REGISTER_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sms_status, 0),
};

const unsigned int response_descriptors_count = ARRAY_SIZE(response_descriptors, struct descriptor);

/*
 * Find the descriptor which can handle the supplied type of message
 */
struct descriptor * find_descriptor(struct msmcomm_message *message, int *self_naming) 
{
    int n = 0;
    struct descriptor *result = NULL;
    struct descriptor *d = NULL;

    *self_naming = 1;

    d = response_descriptors;
    for (n = 0; n < response_descriptors_count; n++) 
    {
        /* check for valid callbacks */
        if (d->is_valid == NULL || d->handle_data == NULL)
            continue;

        /* if we have a descriptor set which provides get_type callback, check it! */
        if (d->get_type != NULL) 
        {
            *self_naming = 0;
        }

        /* check if message is valid for this descriptor */
        if (d->is_valid(message))
        {
            result = d;
            break;
        }

        d++;
    }

    return result;
}

msmcomm_message_class_t descriptor_type_to_message_class_type(struct descriptor *dptor) 
{
    msmcomm_message_class_t result = MSMCOMM_MESSAGE_CLASS_NONE;

    if (dptor == NULL)
        return result;

    switch (dptor->type) {
        case DESCRIPTOR_TYPE_EVENT:
            result = MSMCOMM_MESSAGE_CLASS_EVENT;
            break;  
        case DESCRIPTOR_TYPE_RESPONSE:
            result = MSMCOMM_MESSAGE_CLASS_RESPONSE;
            break;
    }

    return result;
}

/*
 * Handle supplied data and forward it to the correc message handler
 */
int handle_response_data(struct msmcomm_context *ctx, uint8_t * data, uint32_t len)
{
    int n;
    int self_naming = 1;
    int offset = 0;
    msmcomm_message_type_t message_type = MSMCOMM_MESSAGE_TYPE_INVALID;

    struct msmcomm_message message;

    /* we can already report events to our user? */
    if (ctx->resp_cb == NULL)
        return 0;

    /* ensure response len: response should be groupId + msgId = 3 byte as minimum */
    if (len < 3)
        return 0;

    /**
     * NOTE: In some cases (for sim messages) there is also a subsystem id 
     * included in the message id. We assume that the is_valid handler
     * of the descritors gets this out of the msgId set in the response
     * structure.
     **/
    offset = 3;
    message.group_id = data[0];
    message.msg_id = data[1] | (data[2] << 8);

    message.payload = NULL;
    message.descriptor = NULL;
    message.result = MSMCOMM_RESULT_OK;
    message.class = MSMCOMM_MESSAGE_CLASS_NONE;

    /* Find the right descriptor for the message */
    message.descriptor = find_descriptor(&message, &self_naming);
    if (message.descriptor == NULL)
        return 0;

    message.class = descriptor_type_to_message_class_type(message.descriptor);

    /* check for submsg id */
    if (message.descriptor->has_submsg_id) 
    {
        if (len < 4) 
        {
            /* message is too short to have a submsg id */
            return 0;
        }

        offset = 4;
        message.submsg_id = data[3];
    }

    /* let our descriptor handle the left data */
    message.descriptor->handle_data(&message, data + offset, len - offset);

    if (self_naming) 
    {
        message_type = message.descriptor->message_type;
    }
    else 
    {
        message_type = message.descriptor->get_type(&message);
    }

    /* Tell the user about the received message */
    ctx->resp_cb(ctx->resp_data, message_type, &message);

    return 1;
}
