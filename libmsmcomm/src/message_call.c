
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

void msg_dial_call_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x0;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct dial_call_msg);

    MESSAGE_CAST(msg, struct dial_call_msg)->value0 = 0x4;

    MESSAGE_CAST(msg, struct dial_call_msg)->value1 = 0x1;

    /* We allow the other side to see our number! */
    MESSAGE_CAST(msg, struct dial_call_msg)->block = 0xb;
}

uint32_t msg_dial_call_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct dial_call_msg);
}

void msg_dial_call_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_dial_call_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct dial_call_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_dial_call_set_caller_id
    (struct msmcomm_message *msg, const char * caller_id, unsigned int len)
{
    if (len > sizeof ((struct dial_call_msg *) 0)->caller_id)
        return;

    /* copy caller id to payload structure */
    memcpy(MESSAGE_CAST(msg, struct dial_call_msg)->caller_id, caller_id, len);
    MESSAGE_CAST(msg, struct dial_call_msg)->caller_id_len = (uint8_t)len;
}

void msmcomm_message_dial_call_set_block(struct msmcomm_message *msg, unsigned int block)
{
    uint8_t magic = 0xb;
    if (block) {
        magic = 0xc;
    }
    MESSAGE_CAST(msg, struct dial_call_msg)->block = magic;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_ANSWER_CALL
 */

void msg_answer_call_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x1;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct answer_call_msg);

    /* some constant values */
    MESSAGE_CAST(msg, struct answer_call_msg)->value0 = 0x2;
    MESSAGE_CAST(msg, struct answer_call_msg)->value1 = 0x1;
    MESSAGE_CAST(msg, struct answer_call_msg)->value2 = 0x0;
}

uint32_t msg_answer_call_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct answer_call_msg);
}

void msg_answer_call_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_answer_call_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct answer_call_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_answer_call_set_call_id(struct msmcomm_message *msg, uint8_t call_id)
{
    MESSAGE_CAST(msg, struct answer_call_msg)->call_id = call_id;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_END_CALL
 */

void msg_end_call_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x0;
    msg->msg_id = 0x2;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct end_call_msg);

    /* some constant values */
    MESSAGE_CAST(msg, struct end_call_msg)->value0 = 0x1;
}

uint32_t msg_end_call_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct end_call_msg);
}

void msg_end_call_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_end_call_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct end_call_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_end_call_set_call_id(struct msmcomm_message *msg, uint8_t call_id)
{
    MESSAGE_CAST(msg, struct end_call_msg)->call_id = call_id;
}
