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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE
 */

void msg_wms_ack_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x15;
    msg->msg_id = 0xb;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct wms_ack_msg);
    
    /* Some unknown values, set always to 0x1 */
    MESSAGE_CAST(msg, struct wms_ack_msg)->value0 = 0x1;
    MESSAGE_CAST(msg, struct wms_ack_msg)->value1 = 0x1;
}

uint32_t msg_wms_ack_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct wms_ack_msg);
}

void msg_wms_ack_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_wms_ack_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct wms_ack_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_GET_SMS_CENTER_NUMBER
 */

void msg_wms_read_template_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x15;
    msg->msg_id = 0x11;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct wms_read_template_msg);
}

uint32_t msg_wms_read_template_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct wms_read_template_msg);
}

void msg_wms_read_template_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_wms_read_template_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct wms_read_template_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_wms_read_template_set_template(struct msmcomm_message *msg, msmcomm_wms_template_type_t template_type)
{
	uint16_t template = 0x0;

	switch (template_type)
	{
		case MSMCOMM_WMS_TEMPLATE_TYPE_SMSC_ADDRESS:
			template = 0x2;
			break;
		case MSMCOMM_WMS_TEMPLATE_TYPE_EMAIL_ADDRESS:
			template = 0x102;
			break;
		default:
			return;
	}

	MESSAGE_CAST(msg, struct wms_read_template_msg)->record = template;
}

