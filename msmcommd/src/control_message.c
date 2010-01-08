/* 
 * (c) 2009 by Simon Busch <morphis@gravedo.de>
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

void ctrl_msg_set_client(struct control_message *ctrl_msg, const char *client_addr)
{
	ctrl_msg->client = NEW(struct sockaddr_in, 1);
	ctrl_msg->client->sin_family = AF_INET;
	ctrl_msg->client->sin_port = htons(MSMC_DEFAULT_NETWORK_PORT);
	inet_aton(client_addr, ctrl_msg->client->sin_addr.s_addr);
}

void free_ctrl_msg(struct control_message *ctrl_msg)
{
	if (ctrl_msg->client)
		free(ctrl_msg->client);
	free(ctrl_msg);
}

void ctrl_msg_format_data_type(struct control_message *ctrl_msg, const unsigned char *data, const
								  unsigned int len, unsigned int copy_data)
{
	ctrl_msg->type = MSMC_CONTROL_MSG_TYPE_DATA;
	ctrl_msg->payload_len = len;

	if (copy_data) {
		ctrl_msg->payload = NEW(unsigned char, len);
		memcpy(ctrl_msg->payload, data, len);
	}
	else {
		ctrl_msg->payload = data;
	}
}

void ctrl_msg_format_rsp_type(struct control_message *ctrl_msg, int rsp_type)
{
	ctrl_msg->type = MSMC_CONTROL_MSG_TYPE_RSP;
	ctrl_msg->payload_len = 1;
	ctrl_msg->payload = (unsigned char*) calloc(sizeof(unsigned char), MSMC_CONTROL_MSG_RSP_SIZE);
	ctrl_msg->payload[0] = rsp_type;
}

void ctrl_msg_format_cmd_type(struct control_message *ctrl_msg, int cmd_type)
{
	ctrl_msg->type = MSMC_CONTROL_MSG_TYPE_CMD;
	ctrl_msg->payload = 1;
	ctrl_msg->payload = (unsigned char*) calloc(sizeof(unsigned char), MSMC_CONTROL_MSG_RSP_SIZE);
	ctrl_msg->payload[0] = cmd_type;
}

void send_ctrl_msg(int fd, struct control_message *ctrl_msg)
{
	/* build control message packet to send to our client */
	unsigned char *ctrlp = (unsigned char*) calloc(sizeof(unsigned char), MSMC_CONTROL_MESSAGE_LEN(ctrl_msg));

	ctrlp[0] = ctrl_msg->type;
	memcpy(&ctrlp[1], &ctrl_msg->payload[0], ctrl_msg->payload_len);

	sendto(fd, ctrlp, sizeof(ctrlp), 0, (struct sockaddr*) ctrl_msg->client, sizeof(ctrl_msg->client));
}

