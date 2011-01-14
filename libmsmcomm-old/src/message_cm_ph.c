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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE
 */

void msg_change_operation_mode_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x3;
    msg->msg_id = 0x0;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct change_operation_mode_msg);
}

uint32_t msg_change_operation_mode_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct change_operation_mode_msg);
}

void msg_change_operation_mode_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

void msmcomm_message_change_operation_mode_set_operation_mode(struct msmcomm_message *msg,
                                                              msmcomm_operation_mode_t operation_mode)
{
    if (operation_mode == MSMCOMM_OPERATION_MODE_RESET)
        MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x7;

    else if (operation_mode == MSMCOMM_OPERATION_MODE_ONLINE)
        MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x5;

    else if (operation_mode == MSMCOMM_OPERATION_MODE_OFFLINE)
        MESSAGE_CAST(msg, struct change_operation_mode_msg)->operation_mode = 0x6;
}

uint8_t *msg_change_operation_mode_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct change_operation_mode_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONE_STATE_INFO
 */

void msg_get_phone_state_info_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x3;
    msg->msg_id = 0x5;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct get_phone_state_info_msg);
}

uint32_t msg_get_phone_state_info_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_phone_state_info_msg);
}

void msg_get_phone_state_info_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_get_phone_state_info_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct get_phone_state_info_msg)->ref_id = msg->ref_id;

    return msg->payload;
}
