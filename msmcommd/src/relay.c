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

LLIST_HEAD(relay_connections);

extern void *talloc_relay_ctx;

static int relay_client_data(struct bsc_fd *bfd, uint32_t what)
{
	struct relay_connection *conn = bfd->data;
	int rc = 0, len;
	uint8_t buffer[4096];

	if (what & BSC_FD_READ) {
		/* We got new data to send to our connected serial part */
		len = recv(bfd->fd, buffer, 4096, 0);
		DEBUG_MSG("got %i bytes from client\n", len);
		schedule_llc_data(conn->ctx, buffer, len);
	}

	return rc;
}

static void relay_data_from_llc(struct msmc_context *ctx, const uint8_t *data, uint32_t len)
{
	struct relay_connection *client;
	llist_for_each_entry(client, &relay_connections, list) {
		send(client->bfd.fd, data, len, 0);
	}
}

static int relay_new_connection(struct bsc_fd *bfd, uint32_t what)
{
	struct msmc_context *ctx = (struct msmc_context*) bfd->data;
	struct relay_connection *conn;
	struct sockaddr_in sa;
	int rc;
	socklen_t len = sizeof(sa);

	rc = accept(bfd->fd, (struct sockaddr*) &sa, &len);
	if (rc < 0) {
		ERROR_MSG("relay accpet failed: %s", strerror(errno));
		return -1;
	}

	conn = talloc_zero(talloc_relay_ctx, struct relay_connection);
	conn->bfd.data = conn;
	conn->bfd.fd = rc;
	conn->bfd.when = BSC_FD_READ;
	conn->bfd.cb = relay_client_data;
	conn->ctx = ctx;
	bsc_register_fd(&conn->bfd);
	llist_add_tail(&conn->list, &relay_connections);

	return 0;
}

int init_relay_interface(struct msmc_context *ctx) 
{
	struct sockaddr_in addr;
	struct bsc_fd *bfd = &ctx->fds[MSMC_FD_NETWORK];
	int ret, on = 1;

	bfd->fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	bfd->cb = relay_new_connection;
	bfd->when = BSC_FD_READ | BSC_FD_WRITE;
	bfd->data = ctx;
	bfd->priv_nr = 0;

	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(MSMC_DEFAULT_NETWORK_PORT);
	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK); /* FIXME currently we only listen on the
													  loopback interface */ 

	setsockopt(bfd->fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
	
	ret = bind(bfd->fd, (struct sockaddr*) &addr, sizeof(addr));
	if (ret < 0) {
		ERROR_MSG("could not bind socket: %s", strerror(errno));
		return -EIO;
	}

	ret = listen(bfd->fd, 0);
	if (ret < 0) {
		ERROR_MSG("could not listen on socket: %s", strerror(errno));
		return -EIO;
	}

	ret = bsc_register_fd(bfd);
	if (ret < 0) {
		perror("could not register fd");
		return ret;
	}

	register_llc_data_handler(ctx, relay_data_from_llc);

	return 1;
}

static void close_client_connection(struct bsc_fd *bfd)
{
	struct relay_connection *rc = (struct relay_connection*) bfd->data;

	close(bfd->fd);
	bsc_unregister_fd(bfd);

	llist_del(&rc->list);
	talloc_free(rc);
}

void shutdown_relay_interface(struct msmc_context *ctx)
{
	struct bsc_fd *bfd; 

	/* release all client connection */
	llist_for_each_entry(bfd, &relay_connections, list) {
		close_client_connection(bfd);
	}

	/* close socket */
	close(ctx->fds[MSMC_FD_NETWORK].fd);
}

