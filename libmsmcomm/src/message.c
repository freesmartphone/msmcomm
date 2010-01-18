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

#include <msmcomm/internal.h>

extern void *talloc_msmcomm_ctx;

struct msmcomm_message
{
	uint8_t	group_id;
	uint8_t	msg_id;
	void *data;
};

int msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg)
{
	uint8_t *data;
	uint32_t len;
	
	return 1;
}

uint32_t msmcomm_message_get_size(struct msmcomm_message *msg)
{
	uint32_t len;

	/* handle specific groups of message and than specify the actual size of the
	 * message on message id layer */
	if (msg->group_id == MSMCOMM_MESSAGE_GROUP_XXX) {
		switch (msg->msg_id) {
			case MSMCOMM_MESSAGE_MSG_XXX1:
				break;
			default:
				break;
		}
	}
	else if(msg->group_id == MSMCOMM_MESSAGE_GROUP_YYY) {
	}

	return len;
}

struct msmcomm_message* msmcomm_create_message(struct msmcomm_context *ctx)
{
	return NULL;
}

void msmcomm_message_set_type(struct msmcomm_message *msg, int type)
{
}

int msmcomm_message_get_type(struct msmcomm_message *msg)
{
	return -1;
}

void msmcomm_message_set_group_id(struct msmcomm_message *msg, int group_id)
{
}

void msmcomm_message_set_msg_id(struct msmcomm_message *msg, int msg_id)
{
}




