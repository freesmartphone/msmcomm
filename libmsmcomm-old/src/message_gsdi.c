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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_VERIFY_PIN
 */

void msg_verify_pin_init(struct msmcomm_message *msg)
{
    msg->group_id = 0xf;
    msg->msg_id = 0xe;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct pin_status_msg);
}

uint32_t msg_verify_pin_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct pin_status_msg);
}

void msg_verify_pin_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_verify_pin_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct pin_status_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_verify_pin_set_pin(struct msmcomm_message *msg, const char *pin)
{
    _message_pin_status_set_pin(msg, pin);
}

void msmcomm_message_verify_pin_set_pin_type(struct msmcomm_message *msg, msmcomm_sim_pin_type_t pin_type)
{
    _message_pin_status_set_pin_type(msg, pin_type);
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_PIN
 */

void msg_change_pin_init(struct msmcomm_message *msg)
{
    msg->group_id = 0xf;
    msg->msg_id = 0xf;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct change_pin_msg);
}

uint32_t msg_change_pin_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct change_pin_msg);
}

void msg_change_pin_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_change_pin_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct change_pin_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_change_pin_set_old_pin(struct msmcomm_message *msg, const char *old_pin, unsigned int len)
{
    unsigned int bytes = 0;
    
    /* A valid pin should be 4 or 8 bytes long */
    if (len >= 4)
    {
        bytes = 4; 
    }
    else if (len >= 8)
    {
        bytes = 8;
    }
    
    memcpy(MESSAGE_CAST(msg, struct change_pin_msg)->old_pin, old_pin, bytes);
}

void msmcomm_message_change_pin_set_new_pin(struct msmcomm_message *msg, const char *new_pin, unsigned int len)
{
    unsigned int bytes = 0;
    
    /* A valid pin should be 4 or 8 bytes long */
    if (len >= 4)
    {
        bytes = 4; 
    }
    else if (len >= 8)
    {
        bytes = 8;
    }
    
    memcpy(MESSAGE_CAST(msg, struct change_pin_msg)->new_pin, new_pin, bytes);
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_ENABLE_PIN
 */

void msg_enable_pin_init(struct msmcomm_message *msg)
{
    msg->group_id = 0xf;
    msg->msg_id = 0x12;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct pin_status_msg);
}

uint32_t msg_enable_pin_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct pin_status_msg);
}

void msg_enable_pin_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_enable_pin_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct pin_status_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_enable_pin_set_pin(struct msmcomm_message *msg, const char *pin)
{
    _message_pin_status_set_pin(msg, pin);
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_DISABLE_PIN
 */

void msg_disable_pin_init(struct msmcomm_message *msg)
{
    msg->group_id = 0xf;
    msg->msg_id = 0x12;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct pin_status_msg);
}

uint32_t msg_disable_pin_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct pin_status_msg);
}

void msg_disable_pin_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_disable_pin_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct pin_status_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_disable_pin_set_pin(struct msmcomm_message *msg, const char *pin)
{
    _message_pin_status_set_pin(msg, pin);
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_SIM_INFO
 */

void msg_sim_info_init(struct msmcomm_message *msg)
{
    msg->group_id = 0xf;
    msg->msg_id = 0x3;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct sim_info_msg);
}

uint32_t msg_sim_info_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct sim_info_msg);
}

void msg_sim_info_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_sim_info_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct sim_info_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_sim_info_set_field_type(struct msmcomm_message *msg, msmcomm_sim_info_field_type_t field_type)
{
    switch (field_type)
    {
        case MSMCOMM_SIM_INFO_FIELD_TYPE_IMSI:
            MESSAGE_CAST(msg, struct sim_info_msg)->sim_file = 0x401;
            break;
        case MSMCOMM_SIM_INFO_FIELD_TYPE_MSISDN:
            MESSAGE_CAST(msg, struct sim_info_msg)->sim_file = 0x419;
            break;
    }
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_GSDI_GET_ALL_PIN_STATUS_INFO
 */

void msg_gsdi_get_all_pin_status_info_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0f;
    msg->msg_id = 0x1a;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct gsdi_get_all_pin_status_info_msg);
}

uint32_t msg_gsdi_get_all_pin_status_info_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct gsdi_get_all_pin_status_info_msg);
}

void msg_gsdi_get_all_pin_status_info_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_gsdi_get_all_pin_status_info_prepare_data(struct msmcomm_message *msg)
{
    return msg->payload;
}
