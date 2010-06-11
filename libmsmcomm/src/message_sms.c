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
 * MSMCOMM_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE
 */

void msg_sms_acknowledge_incommming_message_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x15;
    msg->msg_id = 0xb;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct sms_ack_msg);
    
    /* Some unknown values, set always to 0x1 */
    MESSAGE_CAST(msg, struct sms_ack_msg)->value0 = 0x1;
    MESSAGE_CAST(msg, struct sms_ack_msg)->value1 = 0x1;
}

uint32_t msg_sms_acknowledge_incommming_message_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct sms_ack_msg);
}

void msg_sms_acknowledge_incommming_message_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_sms_acknowledge_incommming_message_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct sms_ack_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

