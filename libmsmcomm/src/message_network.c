
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
 * MSMCOMM_COMMAND_GET_IMEI
 */

void msg_get_imei_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x1b;
    msg->msg_id = 0x8;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct get_imei_msg);
}

uint32_t msg_get_imei_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_imei_msg);
}

void msg_get_imei_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_get_imei_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct get_imei_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

/*
 * MSMCOMM_COMMAND_GET_NETWORKLIST
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
