
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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_DIAL_CALL
 */

void msg_cm_call_origination_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x0;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct cm_call_origination_msg);

    MESSAGE_CAST(msg, struct cm_call_origination_msg)->value0 = 0x4;

    MESSAGE_CAST(msg, struct cm_call_origination_msg)->value1 = 0x1;

    /* We allow the other side to see our number! */
    MESSAGE_CAST(msg, struct cm_call_origination_msg)->block = 0xb;
}

uint32_t msg_cm_call_origination_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_call_origination_msg);
}

void msg_cm_call_origination_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_cm_call_origination_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct cm_call_origination_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_cm_call_origination_set_caller_id(struct msmcomm_message *msg, const char * caller_id, unsigned int len)
{
    if (len > sizeof ((struct cm_call_origination_msg *) 0)->caller_id)
        return;

    /* copy caller id to payload structure */
    memcpy(MESSAGE_CAST(msg, struct cm_call_origination_msg)->caller_id, caller_id, len);
    MESSAGE_CAST(msg, struct cm_call_origination_msg)->caller_id_len = (uint8_t)len;
}

void msmcomm_message_cm_call_origination_set_block(struct msmcomm_message *msg, unsigned int block)
{
    uint8_t magic = 0xb;
    if (block) {
        magic = 0xc;
    }
    MESSAGE_CAST(msg, struct cm_call_origination_msg)->block = magic;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_ANSWER_CALL
 */

void msg_cm_call_answer_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x1;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct cm_call_answer_msg);

    /* some constant values */
    MESSAGE_CAST(msg, struct cm_call_answer_msg)->value0 = 0x2;
    MESSAGE_CAST(msg, struct cm_call_answer_msg)->value1 = 0x1;
    MESSAGE_CAST(msg, struct cm_call_answer_msg)->value2 = 0x0;
}

uint32_t msg_cm_call_answer_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_call_answer_msg);
}

void msg_cm_call_answer_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_cm_call_answer_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct cm_call_answer_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_cm_call_answer_set_call_id(struct msmcomm_message *msg, uint8_t call_id)
{
    MESSAGE_CAST(msg, struct cm_call_answer_msg)->call_id = call_id;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_END_CALL
 */

void msg_cm_call_end_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x2;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct cm_call_end_msg);

    /* some constant values */
    MESSAGE_CAST(msg, struct cm_call_end_msg)->value0 = 0x1;
}

uint32_t msg_cm_call_end_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_call_end_msg);
}

void msg_cm_call_end_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_cm_call_end_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct cm_call_end_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_cm_call_end_set_call_id(struct msmcomm_message *msg, uint8_t call_id)
{
    MESSAGE_CAST(msg, struct cm_call_end_msg)->call_id = call_id;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_MANAGE_CALLS
 */

void msg_cm_call_sups_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x3;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct cm_call_sups_msg);
}

uint32_t msg_cm_call_sups_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_call_sups_msg);
}

void msg_cm_call_sups_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_cm_call_sups_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct cm_call_sups_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_cm_call_sups_set_call_id(struct msmcomm_message *msg, uint8_t call_id)
{
    MESSAGE_CAST(msg, struct cm_call_sups_msg)->call_id = call_id;
}

void msmcomm_message_cm_call_sups_set_command_type(struct msmcomm_message *msg, msmcomm_cm_call_sups_comand_type_t command_type)
{
    uint8_t value = 0x0;

    switch (command_type)
    {
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_ALL_OR_SEND_BUSY:
            value = 0x0;
            break;
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_ALL_AND_ACCEPT_WAITING_OR_HELD:
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD:
            value = 0x1;
            break;
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD:
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD:
            value = 0x2;
            break;
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_ACTIVATE_HELD:
            value = 0x3;
            break;
        case MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_SELF_AND_CONNECT_ACTIVE:
            value = 0x4;
            break;
        default:
            return;
    }

    MESSAGE_CAST(msg, struct cm_call_sups_msg)->command = value;
}

