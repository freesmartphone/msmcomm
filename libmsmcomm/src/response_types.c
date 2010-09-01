
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

#define GROUP_TYPE(name) \
	NEW_TYPE(group, name) \
	extern unsigned int group_##name##_get_type(struct msmcomm_message *msg);

#define TYPE_DATA(type, subtype, name) \
	{	subtype, \
		type##_##name##_get_size, \
		NULL, NULL, NULL, \
		type##_##name##_handle_data, \
		type##_##name##_is_valid, \
		NULL \
		}
        
#define GROUP_DATA(name) \
	{	MSMCOMM_MESSAGE_INVALID, \
		NULL, NULL, NULL, NULL, \
		group_##name##_handle_data, \
		group_##name##_is_valid, \
		group_##name##_get_type }
        
#define EVENT_DATA(type, name) TYPE_DATA(event, type, name)
#define RESPONSE_DATA(type, name) TYPE_DATA(resp, type, name)

/*
 * Group event types
 */

GROUP_TYPE(sim) 
GROUP_TYPE(call) 
GROUP_TYPE(sups)

struct descriptor group_descriptors[] = {
    GROUP_DATA(sim),
    GROUP_DATA(call),
    GROUP_DATA(sups),
};

const unsigned int group_descriptors_count = sizeof (group_descriptors)
    / sizeof (struct descriptor);

/*
 * Responses
 */

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

struct descriptor resp_descriptors[] = {
    RESPONSE_DATA(MSMCOMM_RESPONSE_TEST_ALIVE, test_alive),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_FIRMWARE_INFO, get_firmware_info),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_IMEI, get_imei),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SIM, sim),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SOUND, sound),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CM_CALL, cm_call),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGING, charging),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGER_STATUS, charger_status),
    RESPONSE_DATA(MSMCOMM_RESPONSE_CM_PH, cm_ph),
    RESPONSE_DATA(MSMCOMM_RESPONSE_SET_SYSTEM_TIME, set_system_time),
    RESPONSE_DATA(MSMCOMM_RESPONSE_RSSI_STATUS, rssi_status),
    RESPONSE_DATA(MSMCOMM_RESPONSE_PHONEBOOK, phonebook),
    RESPONSE_DATA(MSMCOMM_RESPONSE_GET_PHONEBOOK_PROPERTIES, get_phonebook_properties),
    RESPONSE_DATA(MSMCOMM_RESPONSE_AUDIO_MODEM_TUNING_PARAMS, audio_modem_tuning_params),
};

const unsigned int resp_descriptors_count = sizeof (resp_descriptors) / sizeof (struct descriptor);

/*
 * Events
 */

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

struct descriptor event_descriptors[] = {
    EVENT_DATA(MSMCOMM_EVENT_RESET_RADIO_IND, radio_reset_ind),
    EVENT_DATA(MSMCOMM_EVENT_CHARGER_STATUS, charger_status),
    EVENT_DATA(MSMCOMM_EVENT_OPERATION_MODE, operator_mode),
    EVENT_DATA(MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE, cm_ph_info_available),
    EVENT_DATA(MSMCOMM_EVENT_NETWORK_STATE_INFO, network_state_info),
    EVENT_DATA(MSMCOMM_EVENT_GET_NETWORKLIST, get_networklist),
    EVENT_DATA(MSMCOMM_EVENT_PHONEBOOK_READY, phonebook_ready),
    EVENT_DATA(MSMCOMM_EVENT_PHONEBOOK_MODIFIED, phonebook_modified),
    EVENT_DATA(MSMCOMM_EVENT_CM_PH, cm_ph),
    EVENT_DATA(MSMCOMM_EVENT_SMS_RECEIVED_MESSAGE, sms_recieved_message),
};

const unsigned int event_descriptors_count = sizeof (event_descriptors) / sizeof (struct descriptor);


struct descriptor * find_descriptor(struct msmcomm_message *message, unsigned int descriptor_type, int *self_naming)
{
    int n = 0;
    int descriptor_count = 0;
    struct descriptor *descriptors = NULL;
    struct descriptor *result = NULL;
	struct descriptor *d = NULL;
    
	*self_naming = 1;
	
    switch (descriptor_type)
    {
        case DESCRIPTOR_TYPE_INVALID:
            return NULL;
        case DESCRIPTOR_TYPE_GROUP:
            descriptors = group_descriptors;
            descriptor_count = group_descriptors_count;
			*self_naming = 0;
            break;
        case DESCRIPTOR_TYPE_EVENT:
            descriptors = event_descriptors;
            descriptor_count = event_descriptors_count;
            break;
        case DESCRIPTOR_TYPE_RESPONSE:
            descriptors = resp_descriptors;
            descriptor_count = resp_descriptors_count;
            break;
    }
    
    /* Find the right descriptor */
	d = descriptors;
    for (n = 0; n < descriptor_count; n++)
    {
        /* check for valid callbacks */
        if (d->is_valid == NULL || d->handle_data == NULL)
            continue;
        
        /* if we have a descriptor set which provides get_type callback, check it! */
        if (!*self_naming)
        {
            if (d->get_type == NULL)
                continue;
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


int handle_response_data(struct msmcomm_context *ctx, uint8_t * data, uint32_t len)
{
    int n;
	int self_naming = 1;
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
    message.group_id = data[0];
    message.msg_id = data[1] | (data[2] << 8);
    message.payload = NULL;
    message.descriptor = NULL;
    message.result = MSMCOMM_RESULT_OK;
    message.type = MSMCOMM_MESSAGE_TYPE_NONE;
    
    /* Find the right descriptor for the message s*/
    if ((message.descriptor = find_descriptor(&message, DESCRIPTOR_TYPE_GROUP, &self_naming)) == NULL) {
        if ((message.descriptor = find_descriptor(&message, DESCRIPTOR_TYPE_EVENT, &self_naming)) == NULL) {
            if ((message.descriptor = find_descriptor(&message, DESCRIPTOR_TYPE_RESPONSE, &self_naming)) == NULL) {
                /* could not find any valid descriptor for this message */
                return 0;
            }
            else {
                message.type = MSMCOMM_MESSAGE_TYPE_RESPONSE;
            }
        }
        else {
            message.type = MSMCOMM_MESSAGE_TYPE_EVENT;
        }
    }
    else {
        message.type = MSMCOMM_MESSAGE_TYPE_EVENT;
    }
    
    
     /* let our descriptor handle the left data */
    message.descriptor->handle_data(&message, data + 3, len - 3);

    
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
