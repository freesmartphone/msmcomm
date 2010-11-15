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
 
