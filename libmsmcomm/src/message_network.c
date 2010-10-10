
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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_RSSI_STATUS
 */

void msg_rssi_status_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x6;
    msg->msg_id = 0x1;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct rssi_status_msg);
}

uint32_t msg_rssi_status_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct rssi_status_msg);
}

void msg_rssi_status_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_rssi_status_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct rssi_status_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_rssi_status_set_status(struct msmcomm_message *msg, uint8_t status)
{
    MESSAGE_CAST(msg, struct rssi_status_msg)->status = status ? 1 : 0;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_SET_MODE_PREFERENCE
 */

void msg_set_mode_preference_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x3;
    msg->msg_id = 0x1;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct set_mode_preference_msg);
}

uint32_t msg_set_mode_preference_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct set_mode_preference_msg);
}

void msg_set_mode_preference_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_set_mode_preference_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct set_mode_preference_msg)->ref_id = msg->ref_id;

    /* NOTE: The following values are the same for every mode! */
    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value0 = 0x3;

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value1 = 0x40;

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value2 = 0x40;

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value3 = 0x1;

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value4 = 0x2;

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->value5 = 0x4;

    return msg->payload;
}

void msmcomm_message_set_mode_preference_status_set_mode(struct msmcomm_message *msg,
                                                         msmcomm_network_mode_t mode)
{
    uint8_t mode_value = 0x0;

    switch (mode)
    {
        case MSMCOMM_NETWORK_MODE_AUTOMATIC:
            mode_value = 0x2;
            break;
        case MSMCOMM_NETWORK_MODE_GSM:
            mode_value = 0xd;
            break;
        case MSMCOMM_NETWORK_MODE_UMTS:
            mode_value = 0xe;
            break;
        default:
            INFO("You set some unknown preference mode. Please choose GSM, UMTS or AUTOMATIC.");
            return;
    }

    MESSAGE_CAST(msg, struct set_mode_preference_msg)->mode = mode_value;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_GET_NETWORKLIST
 */

void msg_get_networklist_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x3;
    msg->msg_id = 0xa;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct get_networklist_msg);
}

uint32_t msg_get_networklist_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_networklist_msg);
}

void msg_get_networklist_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_get_networklist_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct get_networklist_msg)->ref_id = msg->ref_id;
    MESSAGE_CAST(msg, struct get_networklist_msg)->value0 = 0x13;
    return msg->payload;
}

