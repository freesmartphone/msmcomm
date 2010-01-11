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

char ifname[] = "eth0";

const char *frame_type_names[] = {
	"SYNC",
	"SYNC RESPONSE",
	"CONFIG",
	"CONFIG RESPONSE",
	"ACKNOWLEDGE",
	"DATA"
};

void hexdump(const uint8_t *data, uint32_t len)
{
	const char *p;
	int count;

	if (!data) return;

	p = &data[0];
	count = 0;
	while (len--) {
		if (count == 10) {
			printf("\n");
			count = 0;
		}
		printf("%02x ", *p++ & 0xff);
		count++;
	}
	if(count <= 10)
		printf("\n");
}

static struct timer_list timer;

static void timer_cb(void *_data)
{
	struct msmc_context *ctx = _data;

	/* schedule again */
	bsc_schedule_timer(&timer, 0, 50);
}

static int setup_sock(struct msmc_context *ctx) 
{
	struct sockaddr_in addr;
	struct bsc_fd *bfd = &ctx->fds[MSMC_NETWORK_FD];
	int ret;

	bfd->fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	bfd->cb = cb;
	bfd->when = BSC_FD_READ | BSC_FD_WRITE;
	bfd->data = data;
}

static int init_all(struct msmc_context *ctx)
{
	if (!ctx || strlen(ctx->serial_port) == 0) return;

	DEBUG_MSG("setting up ...");

	/* basic timer */
	timer.cb = timer_cb;
	timer.data = ctx;
	bsc_schedule_timer(&timer, 0 , 50); 

	/* serial and network components */
	if (init_llc(ctx) > 0) {
		ERROR_MSG("failed to init serial component!");
		exit(1);
	}
}

static void shutdown_all(struct msmc_context *ctx)
{
	DEBUG_MSG("shutting down ...");

	shutdown_llc(ctx);

	/* free context */
	if (ctx)
		free(ctx);
}

static int update_all(struct msmc_context *ctx)
{
	fd_set rfds;
	int retval;
	char buffer[MSMC_MAX_BUFFER_SIZE];

	if (!ctx) return;

	retval = bsc_select_main(0);
	if (retval < 0)
		return -1;

	return 0;
}

static void print_usage()
{
}

static void print_help()
{
}

static void handle_options(struct msmc_context *ctx, int arc, char *argv[])
{

}

int main(int argc, char *argv[])
{
	int retval;
	struct msmc_context *ctx;
	int option_index;

	printf("msmcommd (c) 2009 by Simon Busch\n");

	ctx = talloc(NULL, struct msmc_context);

	handle_options(ctx, argc, argv);

	/* startup everything we need */
	init_all(ctx);

	while (1)
	{
		retval = update_all(ctx);
		if (retval < 0)
			exit(3);
	}

	shutdown_all(ctx);
	talloc_free(ctx);

	exit(0);
}

