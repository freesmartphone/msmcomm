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

extern unsigned char ifname[];

LLIST_HEAD(control_msg_tx_queue);
LLIST_HEAD(client_subcriptions);

struct control_message* _control_message_new(void)
{
	return (struct control_message*) malloc(sizeof(struct control_message));
}

void _control_message_format_data(struct control_message *ctrl_msg, const unsigned char *data, const
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

void _control_message_format_rsp(struct control_message *ctrl_msg, int rsp_type)
{
	ctrl_msg->type = MSMC_CONTROL_MSG_TYPE_RSP;
	ctrl_msg->payload_len = 1;
	ctrl_msg->payload = (unsigned char*) calloc(sizeof(unsigned char), MSMC_CONTROL_MSG_RSP_SIZE);
	ctrl_msg->payload[0] = rsp_type;
}

void _control_message_send(struct msmc_context *ctx, struct control_message *ctrl_msg)
{
	/* build control message packet to send to our client */
	unsigned char *ctrlp = (unsigned char*) calloc(sizeof(unsigned char), MSMC_CONTROL_MESSAGE_LEN(ctrl_msg));

	ctrlp[0] = ctrl_msg->type;
	memcpy(&ctrlp[1], &ctrl_msg->payload[0], ctrl_msg->payload_len);

	sendto(ctx->fds[MSMC_FD_NETWORK].fd, ctrlp, sizeof(ctrlp), 0,
		   (struct sockaddr*) ctrl_msg->client, sizeof(ctrl_msg->client));
}

void _network_data_schedule(struct msmc_context *ctx, struct control_message *ctrl_msg)
{
	/* schedule data */
	llist_add_tail(&control_msg_tx_queue, &ctrl_msg->list);
}

void _control_message_cmd_handle(struct msmc_context *ctx, unsigned int cmd, struct control_message *ctrl_msg)
{
	struct client_subscription *csubs;

	switch(cmd)
	{
	case MSMC_CONTROL_MSG_CMD_RESET_LL:
		break;
	case MSMC_CONTROL_MSG_CMD_SUBSCRIBE:
		/* create a new subscription for the client so he get informed about incomming data in the
		 * future */
		csubs = NEW(struct client_subscription, 1);
		memcpy(csubs->client, ctrl_msg->client, sizeof(struct sockaddr_in));
		llist_add_tail(&client_subcriptions, &csubs->list);
		break;
	default:
		break;
	}
}

void _control_message_handle(struct msmc_context *ctx, struct control_message *ctrl)
{
	switch(ctrl->type)
	{
	case MSMC_CONTROL_MSG_TYPE_DATA:
		/* We received new data to send to our connected mobile station */
		_serial_data_schedule(ctx, ctrl->payload, ctrl->payload_len);

		/* Tell our client that we received the data */
		struct control_message *rsp = _control_message_new();
		_control_message_format_rsp(rsp, MSMC_CONTROL_MSG_RSP_DATA_SCHEDULED);
		_network_data_schedule(ctx, rsp);

		break;
	case MSMC_CONTROL_MSG_TYPE_CMD:
		if (ctrl->payload_len == 0 || ctrl->payload == NULL) {
			DEBUG_MSG("received control message with NULL payload!");
			return;
		}

		unsigned char cmd = ctrl->payload[0];
		_control_message_cmd_handle(ctx, cmd, ctrl); 
		break;
	default:
		break;
	}
}

void _network_incomming_data_handle(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	struct control_message ctrl;
	struct sockaddr_in sa;
	socklen_t sa_len = sizeof(sa);
	size_t len;
	char buffer[5012];

	DEBUG_MSG("control message arrived ...");
	len = recvfrom(bfd->fd, &buffer, sizeof(buffer), 0, (struct sockaddr*) &sa, &sa_len);

	if (len < 0 || len <= 1) {
		DEBUG_MSG("control message received in wrong format ... dropping message.");
		return;
	}

	/* control message packet format:
	 * [0] = type of the message (DATA, CMD or RSP)
	 * [1] - * = payload
	 */

	/* copy all data to ctrl structure */
	ctrl.payload_len = len - 1;
	ctrl.payload = &buffer[1];
	ctrl.type = buffer[0];
	ctrl.client = &sa;

	_control_message_handle(ctx, &ctrl);
}

static void _network_serial_data_handle(struct msmc_context *ctx, const unsigned char *data, const unsigned int len)
{
	struct client_subscription *csubs;
	struct control_message ctrlm;

	/* we received data from the serial port -> forward it to all registered clients */
	llist_for_each_entry(csubs, &client_subcriptions, list) {
		ctrlm.client = csubs->client;
		_control_message_format_data(&ctrlm, data, len, 0);
		_control_message_send(ctx, &ctrlm);
	}
}

void _network_outgoing_data_handle(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;

	/* loop through our trx-queue and send every control message to it's client */
	struct control_message *ctrl_msg;
	llist_for_each_entry(ctrl_msg, &control_msg_tx_queue, list) {
		_control_message_send(ctx, ctrl_msg);
	}
}

static void _network_cb(struct bsc_fd *bfd, unsigned int flags)
{
	if (flags & BSC_FD_READ)
		_network_incomming_data_handle(bfd);
	if (flags & BSC_FD_WRITE)
		_network_outgoing_data_handle(bfd);
}

int msmc_network_init(struct msmc_context *ctx)
{
	int fd, rc;
	struct sockaddr_in sa;

	/* setup network control port */
	ctx->fds[MSMC_FD_NETWORK].cb = _network_cb;
	ctx->fds[MSMC_FD_NETWORK].data = ctx;
	ctx->fds[MSMC_FD_NETWORK].when = BSC_FD_READ | BSC_FD_WRITE;

	/* open network socket */
	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (fd < 0) {
		bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
		close(ctx->fds[MSMC_FD_SERIAL].fd);
		return -1;
	}

	/* bind to specific interface */
	if (strlen(ifname) > 0) {
		rc = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, ifname, strlen(ifname));
		if (rc < 0) {
			close(fd);
			bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
			close(ctx->fds[MSMC_FD_SERIAL].fd);
			return -1;
		}
	}
	
	/* bind to port */
	sa.sin_family = AF_INET;
	sa.sin_port = htons(MSMC_DEFAULT_NETWORK_PORT);
	sa.sin_addr.s_addr = INADDR_ANY;

	rc = bind(fd, (struct sockaddr*) &sa, sizeof(sa));
	if (rc < 0) {
		close(fd);
		bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
		close(ctx->fds[MSMC_FD_SERIAL].fd);
		return -1;
	}

	ctx->fds[MSMC_FD_NETWORK].fd = fd;
	bsc_register_fd(&ctx->fds[MSMC_FD_NETWORK]);

	/* register the callback handler for incomming data on serial front */
	msmc_serial_data_handler_add(ctx, _network_serial_data_handle);

	return 0;
}

void msmc_network_shutdown(struct msmc_context *ctx)
{
	/* close network port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_NETWORK]);
	close(ctx->fds[MSMC_FD_NETWORK].fd);
}

