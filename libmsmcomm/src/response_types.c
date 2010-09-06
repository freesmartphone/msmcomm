
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

/*
 * Some helpful macros
 */

#define NEW_TYPE(type, name) \
	extern unsigned int type##_##name##_is_valid(struct msmcomm_message *msg); \
	extern void type##_##name##_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len); \
	extern uint32_t type##_##name##_get_size(struct msmcomm_message *msg);

#define RESPONSE_TYPE(name) NEW_TYPE(resp, name)
#define EVENT_TYPE(name) NEW_TYPE(event, name)

#define EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(name) \
	NEW_TYPE(event, name) \
	extern unsigned int event_##name##_get_type(struct msmcomm_message *msg);

#define TYPE_DATA(type, subtype, descriptor_type, name, has_submsg_id) \
	{	subtype, \
	    descriptor_type, \
        has_submsg_id, \
		type##_##name##_get_size, \
		NULL, NULL, NULL, \
		type##_##name##_handle_data, \
		type##_##name##_is_valid, \
		NULL \
		}
        
#define EVENT_DATA(type, name, has_submsg_id) TYPE_DATA(event, type, DESCRIPTOR_TYPE_EVENT, name, has_submsg_id)

#define EVENT_DATA_WITHOUT_EXPLICIT_TYPE(name, has_submsg_id) \
    {	MSMCOMM_MESSAGE_INVALID, \
        DESCRIPTOR_TYPE_EVENT, \
        has_submsg_id, \
		NULL, NULL, NULL, NULL, \
		event_##name##_handle_data, \
		event_##name##_is_valid, \
		event_##name##_get_type }

#define TYPE_DATA(type, subtype, descriptor_type, name, has_submsg_id) \
	{	subtype, \
	    descriptor_type, \
        has_submsg_id, \
		type##_##name##_get_size, \
		NULL, NULL, NULL, \
		type##_##name##_handle_data, \
		type##_##name##_is_valid, \
		NULL \
		}

#define RESPONSE_DATA(type, name, has_submsg_id) TYPE_DATA(resp, type, DESCRIPTOR_TYPE_RESPONSE, name, has_submsg_id)

RESPONSE_TYPE(get_imei) 
RESPONSE_TYPE(get_firmware_info) 
RESPONSE_TYPE(test_alive)
RESPONSE_TYPE(sim)
RESPONSE_TYPE(sound)
RESPONSE_TYPE(cm_call)
RESPONSE_TYPE(charging)
RESPONSE_TYPE(charger_status)
RESPONSE_TYPE(cm_ph)
RESPONSE_TYPE(set_system_time)
RESPONSE_TYPE(rssi_status)
RESPONSE_TYPE(phonebook)
RESPONSE_TYPE(get_phonebook_properties)
RESPONSE_TYPE(audio_modem_tuning_params)

EVENT_TYPE(radio_reset_ind)
EVENT_TYPE(charger_status)
EVENT_TYPE(operator_mode) 
EVENT_TYPE(cm_ph_info_available) 
EVENT_TYPE(get_networklist)
EVENT_TYPE(cm_ph)
EVENT_TYPE(power_state)
EVENT_TYPE(network_state_info)
EVENT_TYPE(phonebook_ready) 
EVENT_TYPE(phonebook_modified)
EVENT_TYPE(sms_recieved_message)

EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(call_status)
EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sim_status)
EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sups_status)
EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(sms_status)

struct descriptor response_descriptors[] = {
    /* responses */
    RESPONSE_DATA(MSMCOMM_RESPONSE_TEST_ALIVE, test_alive, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_FIRMWARE_INFO, get_firmware_info, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_IMEI, get_imei, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SIM, sim, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SOUND, sound, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CM_CALL, cm_call, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGING, charging, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGER_STATUS, charger_status, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CM_PH, cm_ph, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SET_SYSTEM_TIME, set_system_time, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_RSSI_STATUS, rssi_status, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_PHONEBOOK, phonebook, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties, 0),
    RESPONSE_DATA(MSMCOMM_RESPONSE_AUDIO_MODEM_TUNING_PARAMS, audio_modem_tuning_params, 0),

    /* events */
    EVENT_DATA(MSMCOMM_EVENT_RESET_RADIO_IND, radio_reset_ind, 0),
    EVENT_DATA(MSMCOMM_EVENT_CHARGER_STATUS, charger_status, 0),
    EVENT_DATA(MSMCOMM_EVENT_OPERATION_MODE, operator_mode, 0),
    EVENT_DATA(MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE, cm_ph_info_available, 0),
    EVENT_DATA(MSMCOMM_EVENT_NETWORK_STATE_INFO, network_state_info, 0),
    EVENT_DATA(MSMCOMM_EVENT_GET_NETWORKLIST, get_networklist, 0),
    EVENT_DATA(MSMCOMM_EVENT_PHONEBOOK_READY, phonebook_ready, 0),
    EVENT_DATA(MSMCOMM_EVENT_PHONEBOOK_MODIFIED, phonebook_modified, 0),
    EVENT_DATA(MSMCOMM_EVENT_CM_PH, cm_ph, 0),
    EVENT_DATA(MSMCOMM_EVENT_SMS_RECEIVED_MESSAGE, sms_recieved_message, 0),
    
    EVENT_DATA_WITHOUT_EXPLICIT_TYPE(call_status, 0),
    EVENT_DATA_WITHOUT_EXPLICIT_TYPE(sim_status, 0),
    EVENT_DATA_WITHOUT_EXPLICIT_TYPE(sups_status, 0),
    EVENT_DATA_WITHOUT_EXPLICIT_TYPE(sms_status, 0),
};

const unsigned int response_descriptors_count = 
    (sizeof (response_descriptors) / sizeof (struct descriptor));


struct descriptor * find_descriptor(struct msmcomm_message *message, 
                                    int *self_naming) {
    int n = 0;
    struct descriptor *result = NULL;
	struct descriptor *d = NULL;
    
	*self_naming = 1;
	
	d = response_descriptors;
	for (n = 0; n < response_descriptors_count; n++) {
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

int descriptor_type_to_message_type(struct descriptor *dptor) {
    int result = MSMCOMM_MESSAGE_TYPE_NONE;
    
    if (dptor == NULL)
        return result;
    
    switch (dptor->descriptor_type) {
        case DESCRIPTOR_TYPE_EVENT:
            result = MSMCOMM_MESSAGE_TYPE_EVENT;
            break;  
        case DESCRIPTOR_TYPE_RESPONSE:
            result = MSMCOMM_MESSAGE_TYPE_RESPONSE;
            break;
    }
    
    return result;
}

int handle_response_data(struct msmcomm_context *ctx, uint8_t * data, uint32_t len)
{
    int n;
	int self_naming = 1;
    int offset = 0;
	int type = MSMCOMM_MESSAGE_INVALID;

    struct msmcomm_message message;

    /* we can already report events to our user? */
    if (ctx->event_cb == NULL)
        return 0;

    /* ensure response len: response should be groupId + msgId + one byte data
     * as minimum*/
    if (len < 3)
        return 0;

    /* NOTE: in some cases (for sim messages) there is also a subsystem id 
     * included in the message id. We assume that the is_valid handler
     * of the descritors gets this out of the msgId set in the response
     * structure.
     */
    offset = 3;
    message.group_id = data[0];
    message.msg_id = data[1] | (data[2] << 8);
    
    message.payload = NULL;
    message.descriptor = NULL;
    message.result = MSMCOMM_RESULT_OK;
    message.type = MSMCOMM_MESSAGE_TYPE_NONE;
    
    /* Find the right descriptor for the message */
    message.descriptor = find_descriptor(&message, &self_naming);
    if (message.descriptor == NULL)
        return 0;
    
    message.type = descriptor_type_to_message_type(message.descriptor);
    
    /* check for submsg id */
    if (message.descriptor->has_submsg_id) {
        if (len < 4) {
            /* message is too short for having a submsg id */
            return 0;
        }
        
        offset = 4;
        message.submsg_id = data[3];
    }
        
    /* let our descriptor handle the left data */
    message.descriptor->handle_data(&message, data + offset, len - offset);
        
    if (self_naming) {
        type = message.descriptor->type;
    }
    else {
        type = message.descriptor->get_type(&message);
    }
    
    /* Tell the user about the received message */
    ctx->event_cb(ctx->event_data, type, &message);
    
    return 1;
}

