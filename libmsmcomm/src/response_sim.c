
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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_SIM
 */

/* Notes:
 * - when the voice mail number is aquired, this messages contains it
 * - it's even the response for the verify-pin message
 */

unsigned int resp_sim_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x10) && (msg->msg_id == 0x1);
}

void resp_sim_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                           uint32_t len)
{
    if (len != sizeof (struct sim_resp))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct sim_resp)->ref_id;
    
    /* Handle individual result codes */
    if (MESSAGE_CAST(msg, struct sim_resp)->result0 == 0x2 &&
        MESSAGE_CAST(msg, struct sim_resp)->result1 == 0x9) 
    {
        msg->result = MSMCOMM_RESULT_SIM_BAD_STATE;
    }
}

uint32_t resp_sim_get_size(struct msmcomm_message *msg)
{
    return sizeof(struct sim_resp);
}

unsigned int msmcomm_resp_sim_info_get_field_type(struct msmcomm_message *msg)
{
    msmcomm_sim_info_field_type_t type = MSMCOMM_SIM_INFO_FIELD_TYPE_NONE;
    
    if (MESSAGE_CAST(msg, struct sim_resp)->field_type_0 == 0x1 &&
        MESSAGE_CAST(msg, struct sim_resp)->field_type_1 == 0x4) 
    {
        type = MSMCOMM_SIM_INFO_FIELD_TYPE_IMSI;
    }
    else if (MESSAGE_CAST(msg, struct sim_resp)->field_type_0 == 0x19 &&
        MESSAGE_CAST(msg, struct sim_resp)->field_type_1 == 0x4) 
    {
        type = MSMCOMM_SIM_INFO_FIELD_TYPE_MSISDN;
    }
    
    return type;
}

char* msmcomm_resp_sim_get_field_data(struct msmcomm_message *msg)
{
    int n, m;
    char *field_data = NULL;
    
    switch (msmcomm_resp_sim_info_get_field_type(msg)) 
    {
        case MSMCOMM_SIM_INFO_FIELD_TYPE_IMSI:
            /* We got the IMSI with this response */
            if (MESSAGE_CAST(msg, struct sim_resp)->field_length != 8)
                break;
            
            field_data = (char*)malloc(sizeof(char) * (MSMCOMM_MAX_IMSI_LENGTH + 1));
            
            /* Copy imsi from message structure */
            m = 0;
            field_data[m++] = 0x30 + ((MESSAGE_CAST(msg, struct sim_resp)->field_data[0] & 0xf0) >> 4);
            for (n = 1; n<8; n++) 
            {
                field_data[m++] = 0x30 + (MESSAGE_CAST(msg, struct sim_resp)->field_data[n] & 0xf);
                field_data[m++] = 0x30 + ((MESSAGE_CAST(msg, struct sim_resp)->field_data[n] & 0xf0) >> 4);
            }
            
            field_data[MSMCOMM_MAX_IMSI_LENGTH] = 0;
            break;
        case MSMCOMM_SIM_INFO_FIELD_TYPE_MSISDN:
            /* We got the MSISDN with this response */
            /* FIXME */
            break;
    }
    
    return field_data;
}
 
/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_READ_PHONEBOOK
 */

unsigned int resp_phonebook_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x19) && (msg->msg_id == 0x0);
}

void resp_phonebook_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct phonebook_resp))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct phonebook_resp)->ref_id;

    /* handle message specifc error codes */
    if (MESSAGE_CAST(msg, struct phonebook_resp)->result == 0xb)
        msg->result = MSMCOMM_RESULT_READ_SIMBOOK_INVALID_RECORD_ID;
}

uint32_t resp_phonebook_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct phonebook_resp);
}

unsigned int msmcomm_resp_phonebook_get_book_type(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct phonebook_resp)->book_type)
    {
        case 0x10:
            return MSMCOMM_PHONEBOOK_TYPE_ADN;
        case 0x20:
            return MSMCOMM_PHONEBOOK_TYPE_FDN;
        case 0x8:
            return MSMCOMM_PHONEBOOK_TYPE_SDN;
    }

    return MSMCOMM_PHONEBOOK_TYPE_NONE;
}

uint8_t msmcomm_resp_phonebook_get_position(struct msmcomm_message * msg)
{
    return MESSAGE_CAST(msg, struct phonebook_resp)->position;
}

unsigned int msmcomm_resp_phonebook_get_encoding_type(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct phonebook_resp)->encoding_type)
    {
        case 0x4:
            return MSMCOMM_ENCODING_TYPE_ASCII;
        case 0x9:
            return MSMCOMM_ENCODING_TYPE_BUCS2;
    }

    return MSMCOMM_ENCODING_TYPE_NONE;
}

char *msmcomm_resp_phonebook_get_number(struct msmcomm_message *msg)
{
    char *number = NULL;

    int len = 0;

    struct phonebook_resp *resp = MESSAGE_CAST(msg, struct phonebook_resp);

    if (resp->number == NULL)
        return NULL;

    len = strlen(resp->number) + 1;
    number = (uint8_t *) malloc(len * sizeof (char));
    memcpy(number, resp->number, len - 1);
    number[len - 1] = 0;

    return number;
}

char *msmcomm_resp_phonebook_get_title(struct msmcomm_message *msg)
{
    char *title = NULL;

    int len = 0;

    struct phonebook_resp *resp = MESSAGE_CAST(msg, struct phonebook_resp);

    if (resp->title == NULL)
        return NULL;

    len = strlen(resp->title) + 1;
    title = (uint8_t *) malloc(len * sizeof (char));
    memcpy(title, resp->title, len - 1);
    title[len - 1] = 0;

    return title;
}

uint8_t msmcomm_resp_phonebook_get_modify_id(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct phonebook_resp)->modify_id;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_PHONEBOOK_PROPERTIES
 */

unsigned int resp_get_phonebook_properties_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1a) && (msg->msg_id == 0xc);
}

void resp_get_phonebook_properties_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                               uint32_t len)
{
    if (len != sizeof (struct get_phonebook_properties_resp))
        return;

    msg->payload = data;
}

uint32_t resp_get_phonebook_properties_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct get_phonebook_properties_resp);
}

uint32_t msmcomm_resp_get_phonebook_properties_get_slot_count(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct get_phonebook_properties_resp)->slot_count;
}

uint32_t msmcomm_resp_get_phonebook_properties_get_slots_used(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct get_phonebook_properties_resp)->slots_used;
}

uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_title(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct get_phonebook_properties_resp)->max_chars_per_title;
}

uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_number(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct get_phonebook_properties_resp)->max_chars_per_number;
}
