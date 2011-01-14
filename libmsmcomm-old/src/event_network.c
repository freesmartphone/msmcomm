
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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_network_state_info
 */

unsigned int event_network_state_info_is_valid(struct msmcomm_message *msg)
{
    /* event network_state_info seems to be have both msgId 0x0 and 0x1 */
    return ((msg->group_id == 0x8) && (msg->msg_id == 0x0 || msg->msg_id == 0x1));
}

void event_network_state_info_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct network_state_info_event))
        return;

    msg->payload = data;
}

uint32_t event_network_state_info_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct network_state_info_event);
}

unsigned int msmcomm_event_network_state_info_is_only_rssi_update(struct msmcomm_message *msg)
{
    return (msg->msg_id == 0x1);
}

uint32_t msmcomm_event_network_state_info_get_change_field(struct msmcomm_message * msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[0] << 0) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[1] << 8) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[2] << 16) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[3] << 24);
}

#define notify_type_handler(value0, value1, type) \
	if (((field0 & value0) | (field1 & value1))) \
		type_handler(user_data, msg, type);

void msmcomm_event_network_state_info_trace_changes
    (struct msmcomm_message *msg, msmcomm_network_state_info_changed_field_type_cb type_handler,
     void *user_data)
{
    unsigned long long field0 = 0x0, field1 = 0x0;

    unsigned long long fields = 0x0;

    if (type_handler == NULL)
        return;

    field0 = (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[0] << 0) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[1] << 8) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[2] << 16) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[3] << 24);

    field1 = (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[4] << 0) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[5] << 8) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[6] << 16) |
        (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[7] << 24);

    notify_type_handler((0x1 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SID);
    notify_type_handler((0x2 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_NID);
    notify_type_handler((0x4 << 0), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_REGISTRATION_ZONE);
    notify_type_handler((0x8 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PACKET_ZONE);
    notify_type_handler((0x1 << 1), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASESTATION_P_REV);
    notify_type_handler((0x2 << 1), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_P_REV_IN_USE);
    notify_type_handler((0x4 << 1), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_CONCURRENT_SERVICES_SUPPORTED);
    notify_type_handler((0x8 << 1), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVING_STATUS);
    notify_type_handler((0x1 << 2), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVICE_DOMAIN);
    notify_type_handler((0x2 << 2), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_SERVICE_CAPABILITY);
    notify_type_handler((0x4 << 2), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_MODE);
    notify_type_handler((0x8 << 2), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_ROAMING_STATUS);
    notify_type_handler((0x1 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_ID);
    notify_type_handler((0x2 << 3), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERICE_INDICATOR);
    notify_type_handler((0x4 << 3), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_MOBILITY_MANAGEMENT);
    notify_type_handler((0x8 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_HDR);
    notify_type_handler((0x1 << 4), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SIM_CARD_STATUS);
    notify_type_handler((0x2 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PLMN);
    notify_type_handler((0x4 << 4), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PS_DATA_SUSPEND_MASK);
    notify_type_handler((0x8 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_UZ);
    /* FIXME 0x1 << 5 */
    /* FIXME 0x2 << 5 */
    notify_type_handler((0x4 << 5), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
    notify_type_handler((0x8 << 5), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
    notify_type_handler((0x1 << 6), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
    /* 0x2 << 6 is not used */
    notify_type_handler((0x4 << 6), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASE_STATION_PARAMETERS_CHANGED);
    notify_type_handler((0x2 << 7), 0x0,
                        MSMCOMM_NETWORK_STATE_INFO_CHANGED_FILED_TYPE_ORIGINATION_STATUS);
}

uint8_t *msmcomm_event_network_state_info_get_plmn(struct msmcomm_message *msg)
{
    uint8_t *tmp;

    if (msg->payload == NULL)
        return NULL;

    tmp = malloc(sizeof (uint8_t) * MSMCOMM_DEFAULT_PLMN_LENGTH);
    memcpy(tmp, MESSAGE_CAST(msg, struct network_state_info_event)->plmn,
           MSMCOMM_DEFAULT_PLMN_LENGTH);
    return tmp;
}

char *msmcomm_event_network_state_info_get_operator_name(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return;

    char *buffer =
        malloc(sizeof (char) *
               MESSAGE_CAST(msg, struct network_state_info_event)->operator_name_len);
    snprintf(buffer, 255, "%s", MESSAGE_CAST(msg, struct network_state_info_event)->operator_name);

    return buffer;
}

uint16_t msmcomm_event_network_state_info_get_rssi(struct msmcomm_message * msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->rssi;
}

uint16_t msmcomm_event_network_state_info_get_ecio(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->ecio;
}

uint8_t msmcomm_event_network_state_info_get_service_domain(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->servce_domain;
}

uint8_t msmcomm_event_network_state_info_get_service_capability(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->service_capability;
}

uint8_t msmcomm_event_network_state_info_get_gprs_attached(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->gprs_attached;
}

uint16_t msmcomm_event_network_state_info_get_roam(struct msmcomm_message *msg)
{
    if (msg->payload == NULL)
        return 0x0;

    return MESSAGE_CAST(msg, struct network_state_info_event)->roam;
}

msmcomm_network_registration_status_t msmcomm_event_network_state_info_get_registration_status(struct msmcomm_message *msg)
{
    msmcomm_network_registration_status_t result = MSMCOMM_NETWORK_REGISTRATION_STATUS_INVALID;

    if (msg->payload == NULL)
        return MSMCOMM_NETWORK_REGISTRATION_STATUS_INVALID;

    switch (MESSAGE_CAST(msg, struct network_state_info_event)->reg_status)
    {
        case 0:
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_NO_SERVICE;
            break;
        case 1:
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_HOME;
            break;
        case 2: 
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_SEARCHING;
            break;
        case 3:
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_DENIED;
            break;
        case 4:
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_UNKNOWN;
            break;
        case 5:
            result = MSMCOMM_NETWORK_REGISTRATION_STATUS_ROAMING;
            break;
    }

    return result;
}

msmcomm_network_service_status_t msmcomm_event_network_state_info_get_service_status(struct msmcomm_message *msg)
{
    msmcomm_network_service_status_t result = MSMCOMM_NETWORK_SERVICE_STATUS_INVALID;

    if (msg->payload == NULL)
    {
        return MSMCOMM_NETWORK_SERVICE_STATUS_INVALID;
    }

    switch (MESSAGE_CAST(msg, struct network_state_info_event)->serv_status)
    {
        case 0:
            result = MSMCOMM_NETWORK_SERVICE_STATUS_NO_SERVICE;
            break;
        case 1:
            result = MSMCOMM_NETWORK_SERVICE_STATUS_LIMITED;
            break;
        case 2:
            result = MSMCOMM_NETWORK_SERVICE_STATUS_FULL;
            break;
    }

    return result;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_NETWORKLIST
 */

unsigned int event_get_networklist_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x5 && msg->msg_id == 0x12);
}

void event_get_networklist_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct get_networklist_event))
        return;

    msg->payload = data;
}

uint32_t event_get_networklist_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct get_networklist_event);
}

unsigned int msmcomm_event_get_networklist_get_network_count(struct msmcomm_message *msg)
{
    struct get_networklist_event *evt = MESSAGE_CAST(msg, struct get_networklist_event);

    int count = 0;

    if (evt->plmn_0[0] == 0x0)
        return count;
    else
        count++;

    if (evt->plmn_1[0] == 0x0)
        return count;
    else
        count++;

    if (evt->plmn_2[0] == 0x0)
        return count;
    else
        count++;

    if (evt->plmn_3[0] == 0x0)
        return count;
    else
        count++;

    if (evt->plmn_4[0] == 0x0)
        return count;
    else
        count++;

    if (evt->plmn_5[0] == 0x0)
        return count;
    else
        count++;
}

unsigned int msmcomm_event_get_networklist_get_plmn(struct msmcomm_message *msg, int nnum)
{
    struct get_networklist_event *evt = MESSAGE_CAST(msg, struct get_networklist_event);

    unsigned int result = 0x0;

    uint8_t *plmn = NULL;

    switch (nnum)
    {
        case 0:
            plmn = evt->plmn_0;
            break;
        case 1:
            plmn = evt->plmn_1;
            break;
        case 2:
            plmn = evt->plmn_2;
            break;
        case 3:
            plmn = evt->plmn_3;
            break;
        case 4:
            plmn = evt->plmn_4;
            break;
        case 5:
            plmn = evt->plmn_5;
            break;
        default:
            break;
    }

    if (plmn == NULL)
        return 0x0;

    result = network_plmn_to_value(plmn);
    return result;
}

char *msmcomm_event_get_networklist_get_network_name(struct msmcomm_message *msg, int nnum)
{
    struct get_networklist_event *evt = MESSAGE_CAST(msg, struct get_networklist_event);

    char *result = NULL;

    int len = 0;

    uint8_t *network_name = NULL;

    switch (nnum)
    {
        case 0:
            network_name = evt->operator_name_0;
            break;
        case 1:
            network_name = evt->operator_name_1;
            break;
        case 2:
            network_name = evt->operator_name_2;
            break;
        case 3:
            network_name = evt->operator_name_3;
            break;
        case 4:
            network_name = evt->operator_name_4;
            break;
        case 5:
            network_name = evt->operator_name_5;
            break;
        default:
            break;
    }

    if (network_name == NULL)
        return 0x0;

    len = strlen(network_name);
    result = (char *)malloc(sizeof (char) * len + 1);
    memcpy(result, network_name, len);
    result[len] = 0;
    return result;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_PH
 */

unsigned int event_cm_ph_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x5 && msg->msg_id == 0x2);
}

void event_cm_ph_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct cm_ph_event))
        return;

    msg->payload = data;
}

uint32_t event_cm_ph_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct cm_ph_event);
}

uint8_t msmcomm_event_cm_ph_get_plmn_count(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct cm_ph_event)->plmn_count;
}

unsigned int msmcomm_event_cm_ph_get_plmn(struct msmcomm_message *msg, unsigned int n)
{
    uint8_t *plmn = NULL;
    unsigned int value = 0x0;
    
    switch (n) 
    {
        case 0:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_0;
            break;
        case 1:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_1;
            break;
        case 2:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_2;
            break;
        case 3:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_3;
            break;
        case 4:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_4;
            break;
        case 5:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_5;
            break;
        case 6:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_6;
            break;
        case 7:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_7;
            break;
        case 8:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_8;
            break;
        case 9:
            plmn = MESSAGE_CAST(msg, struct cm_ph_event)->plmn_9;
            break;
    }
    
    if (plmn != NULL) 
    {
        value = network_plmn_to_value(plmn);
    }
    
    return value;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_PH_INFO_AVAILABLE
 */

unsigned int event_cm_ph_info_available_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x5) && (msg->msg_id == 0xe);
}

void event_cm_ph_info_available_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                            uint32_t len)
{
    if (len != sizeof (struct cm_ph_event))
        return;

    msg->payload = data;
}

uint32_t event_cm_ph_info_available_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct cm_ph_event);
}
