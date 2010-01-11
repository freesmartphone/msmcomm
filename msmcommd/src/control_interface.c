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

LLIST_HEAD(control_msg_tx_queue);
LLIST_HEAD(client_subcriptions);

extern void *mem_ctrl_ctx;

static void init_client_subscription(struct client_subscription *csubs)
{
	csubs->mem_ctx = talloc_new(mem_ctrl_ctx);
	csubs->client = talloc(csubs->mem_ctx, struct sockaddr_in);
}

static void schedule_ctrl_msg(struct msmc_context *ctx, struct control_message *ctrl_msg)
{
	/* schedule data */
	llist_add_tail(&control_msg_tx_queue, &ctrl_msg->list);
}

static void handle_ctrl_msg_command(struct msmc_context *ctx, uint32_t cmd, struct control_message *ctrl_msg)
{
	struct client_subscription *csubs;

	switch(cmd)
	{
	case MSMC_CONTROL_MSG_CMD_RESET_LL:
		break;
	case MSMC_CONTROL_MSG_CMD_SUBSCRIBE:
		/* create a new subscription for the client so he get informed about incomming data in the
		 * future */
		csubs = talloc(mem_ctrl_ctx, struct client_subscription);
		init_client_subscription(csubs);
		memcpy(csubs->client, ctrl_msg->client, sizeof(struct sockaddr_in));
		llist_add_tail(&client_subcriptions, &csubs->list);
		break;
	default:
		break;
	}
}

static void handle_ctrl_msg(struct msmc_context *ctx, struct control_message *ctrl)
{
	switch(ctrl->type)
	{
	case MSMC_CONTROL_MSG_TYPE_DATA:
		/* We received new data to send to our connected mobile station */
		schedule_llc_data(ctx, ctrl->payload, ctrl->payload_len);

		/* Tell our client that we received the data and scheduled it */
		struct control_message *rsp = talloc(mem_ctrl_ctx, struct control_message);
		init_ctrl_msg(rsp);
		ctrl_msg_format_rsp_type(rsp, MSMC_CONTROL_MSG_RSP_DATA_SCHEDULED);
		schedule_ctrl_msg(ctx, rsp);

		break;
	case MSMC_CONTROL_MSG_TYPE_CMD:
		if (ctrl->payload_len == 0 || ctrl->payload == NULL) {
			DEBUG_MSG("received control message with NULL payload!");
			return;
		}

		uint8_t cmd = ctrl->payload[0];
		handle_ctrl_msg_command(ctx, cmd, ctrl); 
		break;
	default:
		break;
	}
}

static void handle_incomming_control_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	struct control_message ctrl;
	struct sockaddr_in sa;
	socklen_t sa_len = sizeof(sa);
	size_t len;
	uint8_t buffer[5012];

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

	handle_ctrl_msg(ctx, &ctrl);
}

static void handle_data_from_llc(struct msmc_context *ctx, const uint8_t *data, const uint32_t len)
{
	struct client_subscription *csubs;
	struct control_message ctrlm;

	/* we received data from the serial port -> forward it to all registered clients */
	llist_for_each_entry(csubs, &client_subcriptions, list) {
		ctrlm.client = csubs->client;
		ctrl_msg_format_data_type(&ctrlm, data, len, 0);
		send_ctrl_msg(ctx->fds[MSMC_FD_NETWORK].fd, &ctrlm);
	}
}

static void handle_outgoing_control_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;

	/* loop through our trx-queue and send every control message to it's client */
	struct control_message *ctrl_msg;
	llist_for_each_entry(ctrl_msg, &control_msg_tx_queue, list) {
		send_ctrl_msg(ctx->fds[MSMC_FD_NETWORK].fd, ctrl_msg);
		llist_del(&ctrl_msg->list);
		talloc_free(ctrl_msg);
	}
}

static void _network_cb(struct bsc_fd *bfd, uint32_t flags)
{
	if (flags & BSC_FD_READ)
		handle_incomming_control_data(bfd);
	if (flags & BSC_FD_WRITE)
		handle_outgoing_control_data(bfd);
}

int init_control_interface(struct msmc_context *ctx, const char *ifname)
{
	int fd, rc;
	struct sockaddr_in sa;

	DEBUG_MSG("init control interface ...\n");

	/* setup network control port */
	ctx->fds[MSMC_FD_NETWORK].cb = _network_cb;
	ctx->fds[MSMC_FD_NETWORK].data = ctx;
	ctx->fds[MSMC_FD_NETWORK].when = BSC_FD_READ | BSC_FD_WRITE;

	/* open network socket */
	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (fd < 0)
		return fd;

	/* bind to specific interface */
	if (ifname) {
		rc = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, ifname, strlen(ifname));
		if (rc < 0)
			goto err;
	}
	
	/* bind to port */
	sa.sin_family = AF_INET;
	sa.sin_port = htons(MSMC_DEFAULT_NETWORK_PORT);
	sa.sin_addr.s_addr = INADDR_ANY;

	rc = bind(fd, (struct sockaddr*) &sa, sizeof(sa));
	if (rc < 0)
		goto err;
	
	ctx->fds[MSMC_FD_NETWORK].fd = fd;
	bsc_register_fd(&ctx->fds[MSMC_FD_NETWORK]);

	/* register the callback handler for incomming data on serial front */
	register_llc_data_handler(ctx, handle_data_from_llc);

	DEBUG_MSG("-> finished!\n");

	return fd;
err:
	close(fd);
	return rc;
}

void shutdown_control_interface(struct msmc_context *ctx)
{
	/* close network port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_NETWORK]);
	close(ctx->fds[MSMC_FD_NETWORK].fd);

	talloc_free(mem_ctrl_ctx);
}

