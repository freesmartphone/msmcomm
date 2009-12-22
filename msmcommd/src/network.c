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

void _control_message_handle(struct msmc_context *ctx, struct msmc_control_message *ctrl)
{
	if (!ctx || !ctrl)
		return;

	/* FIXME */
}

void _incomming_data_handle(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	struct msmc_control_message ctrl;
	struct sockaddr_in sa;
	socklen_t sa_len = sizeof(sa);
	size_t len;
	char buffer[5012];

	DEBUG_MSG("control message arrived ...");
	len = recvfrom(bfd->fd, &buffer, sizeof(buffer), 0, (struct sockaddr*) &sa, &sa_len);

	if (len < 0 || len < 5) {
		DEBUG_MSG("error while reading control message from network port. discarding packet!");
		return;
	}

	/* copy all data to ctrl structure */
	ctrl.payload_len = len - 5;
	ctrl.payload = &buffer[5];
	ctrl.type = buffer[0];

	_control_message_handle(ctx, &ctrl);
}

static void _network_cb(struct bsc_fd *bfd, unsigned int flags)
{
	if (flags & BSC_FD_READ)
		_incomming_data_handle(bfd);
#if 0
	if (flags & BSC_FD_WRITE)
		msmc_ctrl_handle_outgoing_data(bfd);
#endif
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

	return 0;
}

void msmc_network_shutdown(struct msmc_context *ctx)
{
	/* close network port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_NETWORK]);
	close(ctx->fds[MSMC_FD_NETWORK].fd);
}

