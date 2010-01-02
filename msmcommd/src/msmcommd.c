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

void hexdump(const unsigned char *data, int len)
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

struct msmc_context* msmc_context_new(void)
{
	struct msmc_context *ctx;

	ctx = (struct msmc_context*) malloc(sizeof(struct msmc_context));
}

static struct timer_list timer;

static void timer_cb(void *_data)
{
	struct msmc_context *ctx = _data;

	/* schedule again */
	bsc_schedule_timer(&timer, 0, 50);
}

int msmcommd_init(struct msmc_context *ctx)
{
	if (!ctx || strlen(ctx->serial_port) == 0) return;

	DEBUG_MSG("setting up ...");

	/* basic timer */
	timer.cb = timer_cb;
	timer.data = ctx;
	bsc_schedule_timer(&timer, 0 , 50); 

	/* serial and network components */
	if (msmc_serial_init(ctx) > 0) {
		ERROR_MSG("failed to init serial component!");
		exit(1);
	}
	if (msmc_network_init(ctx, ifname) < 0) {
		ERROR_MSG("failed to init network component!");
		msmc_serial_shutdown(ctx);
		exit(1);
	}
}

void msmc_context_free(struct msmc_context *ctx)
{
	DEBUG_MSG("shutting down ...");

	msmc_serial_shutdown(ctx);
	msmc_network_shutdown(ctx);

	/* free context */
	if (ctx)
		free(ctx);
}

int msmc_update(struct msmc_context *ctx)
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

void print_usage()
{
}

void print_help()
{
}

int main(int argc, char *argv[])
{
	int retval;
	struct msmc_context *ctx;
	int option_index;

	printf("msmcommd (c) 2009 by Simon Busch\n");

	ctx = msmc_context_new();

	/* set default configuration */
	snprintf(&ctx->serial_port[0], 30, "/dev/modemuart"); 

	/* parse options */
/*	while(1) {
		int c;
		unsigned long ul;
		char *slash;
		static struct option long_options[] = {
			{"serial-port", 1, 1, 's'},
			{"help", 0, 0, 'h'},
		};

		c = getopt_long(argc, argv, "s", long_options,
						&option_index);

		if (c == -1)
			break;

		switch(c) {
			case 's':
				snprintf(ctx->serial_port, 30, "%s", optarg);
				printf("using %s as serial port ...\n", ctx->serial_port);
				break;
			case 'h':
				print_usage();
				print_help();
				msmc_context_free(ctx);
				exit(0);
		}
	}*/

	DEBUG_MSG("init msmcommd ...");
	msmcommd_init(ctx);

	while (1)
	{
		retval = msmc_update(ctx);
		if (retval < 0)
			exit(3);
	}

	msmc_context_free(ctx);

	exit(0);
}

