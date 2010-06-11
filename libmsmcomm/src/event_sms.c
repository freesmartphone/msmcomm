
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
 * MSMCOMM_EVENT_SMS_WMS_READ_TEMPLATE
 */

unsigned int event_sms_wms_read_template_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x17) && (SUBSYSTEM_ID(msg) == 0x1) && (MSG_ID(msg) == 0x7);
}

void event_sms_wms_read_template_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                             uint32_t len)
{
    if (len != sizeof (struct sms_wms_read_template_event))
        return;

    msg->payload = data;
}

uint32_t event_sms_wms_read_template_ind_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct sms_wms_read_template_event);
}

uint8_t msmcomm_event_sms_wms_read_template_get_digit_mode(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct sms_wms_read_template_event)->digit_mode;
}

uint8_t msmcomm_event_sms_wms_read_template_get_number_mode(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct sms_wms_read_template_event)->number_mode;
}

uint8_t msmcomm_event_sms_wms_read_template_get_number_type(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct sms_wms_read_template_event)->number_type;
}

uint8_t msmcomm_event_sms_wms_read_template_get_number_plan(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct sms_wms_read_template_event)->number_plan;
}

/*
 * MSMCOMM_EVENT_SMS_RECEIVED_MESSAGE
 */

unsigned int event_sms_received_message_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x17) && 
           (SUBSYSTEM_ID(msg) == 0x2) && 
           ((MSG_ID(msg) == 0xf) || MSG_ID(msg) == 0x11);
}

void event_sms_received_message_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                             uint32_t len)
{
    if (len != sizeof (struct sms_received_message_event))
        return;

    msg->payload = data;
}

uint32_t event_sms_received_message_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct sms_received_message_event);
}

char* msmcomm_event_sms_received_message_event_get_sender(struct msmcomm_message *msg)
{
    struct sms_received_message_event *evt = MESSAGE_CAST(msg, struct sms_received_message_event);
    unsigned int len = evt->sender_length + 1;
    char *sender = NULL;
    int n = 0;
    
    if (evt->sender_length > 0)
    {
        sender = (char*)malloc(sizeof(char) * len);
        memset(sender, 0, evt->sender_length + 1);
        
        for (n = 0; n < len - 1; n++)
        {
            /* We should provide real ascii characters */
            sender[n] = 0x30 + evt->sender[n];
        }
        
        sender[len-1] = 0;
    }
    
    return sender;
} 

uint8_t* msmcomm_event_sms_received_message_event_get_pdu(struct msmcomm_message *msg, 
                                                          unsigned int *length)
{
    uint8_t *pdu = NULL;
    struct sms_received_message_event *evt = MESSAGE_CAST(msg, struct sms_received_message_event);
    
    if (evt->pdu_length > 0)
    {
        pdu = (uint8_t*)malloc(sizeof(uint8_t) * evt->pdu_length);
        *length = evt->pdu_length;
        memset(pdu, 0, evt->pdu_length);
        memcpy(pdu, evt->pdu, evt->pdu_length);
    }
    
    return pdu;
}
