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
extern struct descriptor msg_descriptors[];
extern unsigned int msg_descriptors_size;

int msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg)
{
	uint8_t *data, *payload;
	uint32_t len;

	/* caculate size of our message (header + payload) */
	len = 3;
	if (msg->descriptor == NULL || msg->descriptor->get_size == NULL)
		return 0;
	len += msg->descriptor->get_size(msg);

	/* prepare payload */
	if (!msg->descriptor || !msg->descriptor->prepare_data)
		return 0;
	payload = msg->descriptor->prepare_data(msg);

	/* pack message into full packet */
	data = talloc_size(talloc_msmc_ctx, sizeof(uint8_t) * len);
	memset(data, 0, len);

	/* store groupd id and message id in the packet buffer */
	data[0] = msg->group_id;
	data[1] = msg->msg_id;
	
	/* append payload to packet buffer */
	memcpy(&data[3], payload, len - 3);
	
	/* forward data per callback so the user has to handle the real sending */
	ctx->write_cb(ctx->write_data, data, len);

	/* cleanup */
	talloc_free(data);

	return 1;
}

uint32_t msmcomm_message_get_size(struct msmcomm_message *msg)
{	
	if (msg && msg->descriptor && msg->descriptor->get_size)
		return msg->descriptor->get_size(msg);
	return 0;
}

struct msmcomm_message* msmcomm_create_message(unsigned int type)
{
	unsigned int found = 0;
	int n;
	struct msmcomm_message *msg = talloc(talloc_msmc_ctx, struct
										 msmcomm_message);

	/* default settings */
	msg->descriptor = NULL;
	msg->descriptor_type = DESCRIPTOR_TYPE_INVALID;

	/* find the right message descriptor and init our message */
	for (n=0; n < msg_descriptors_size; n++) {
		if (msg_descriptors[n].type == type) {
			if (msg_descriptors[n].init)
				msg_descriptors[n].init(msg);

			msg->descriptor_type = DESCRIPTOR_TYPE_MESSAGE;
			msg->descriptor = &msg_descriptors[n];
			found = 1;
		}
	}

	if (!found) {
		talloc_free(msg);
		msg = NULL;
	}

	return msg;
}

struct msmcomm_message* msmcomm_message_make_copy(struct msmcomm_message *msg)
{
	struct msmcomm_message *msg_copy;
	
	/* copy message */
	msg_copy = (struct msmcomm_message*) malloc(sizeof(struct msmcomm_message));
	memcpy(msg_copy, msg, sizeof(struct msmcomm_message));

	/* we should now allocate memory for the payload, as the memcpy above does not
	   copy the content of the payload */
	if (msg->payload != NULL) {
		msg_copy->payload = malloc(sizeof(msg->payload));
		memcpy(msg_copy->payload, msg->payload, sizeof(msg->payload));
	}

	return msg_copy;
}

uint32_t msmcomm_message_get_type(struct msmcomm_message *msg)
{
	if (msg && msg->descriptor)
		return msg->descriptor->type;

	return MSMCOMM_MESSAGE_INVALID;
}

uint32_t msmcomm_message_get_ref_id(struct msmcomm_message *msg)
{
	return msg->ref_id;
}

void msmcomm_message_set_ref_id(struct msmcomm_message *msg, uint32_t ref_id)
{
	msg->ref_id = ref_id;
}


