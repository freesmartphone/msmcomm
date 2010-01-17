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

char ifname[] = "eth1";

const char *frame_type_names[] = {
	"SYNC",
	"SYNC RESPONSE",
	"CONFIG",
	"CONFIG RESPONSE",
	"ACKNOWLEDGE",
	"DATA"
};

int use_serial_port = 1;

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

static int init_all(struct msmc_context *ctx)
{
	if (!ctx || strlen(ctx->serial_port) == 0) return;

	/* basic timer */
	timer.cb = timer_cb;
	timer.data = ctx;
	bsc_schedule_timer(&timer, 0 , 50); 

	/* serial and network components */
	if (init_llc(ctx) < 0) {
		talloc_free(ctx);
		exit(1);
	}

	if (init_relay_interface(ctx) < 0) {
		shutdown_llc(ctx);
		exit(1);
	}

}

static void shutdown_all(struct msmc_context *ctx)
{
	shutdown_llc(ctx);

	/* free context */
	if (ctx)
		talloc_free(ctx);
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

static void do_print_version()
{
}

static void do_print_help()
{
}

static void handle_options(struct msmc_context *ctx, int argc, char *argv[])
{
	opterr = 0;
	int option_index;
	int chr;
	int check_arg[2];
	check_arg[0] = 0;
	check_arg[1] = 0;

	struct option opts[] = {
		{ "serial-port", required_argument, 0, 's' },
		{ "network", required_argument, 0, 'n'},
		{ "network-port", required_argument, 0, 'p'},
		{ "help", no_argument, 0, 'h' },
		{ "version", no_argument, 0, 'v'},
	};

	while (1) {
		option_index = 0;
		chr = getopt_long(argc, argv, "s:n:p:hv", opts, &option_index);

		if (chr == -1)
			break;

		switch(chr) {
			case 's':
				snprintf(ctx->serial_port, 30, "%s", optarg);
				check_arg[0] = 1;
				if (check_arg[1]) {
					printf("you cannot use msmcommd with a serial port and a network port!\n");
					exit(1);
				}
				break;
			case 'n':
				snprintf(ctx->network_addr, 30, "%s", optarg);
				check_arg[1] = 1;
				if (check_arg[0]) {
					printf("you cannot use msmcommd with a network port and a serial port!\n");
					exit(1);
				}
				use_serial_port = 0;
				break;
			case 'p':
				snprintf(ctx->network_port, 10, "%s", optarg);
				break;
			case 'h':
				do_print_help();
				break;
			case 'v':
				do_print_version();
				break;
			case '?':
				break;
			default:
				break;
		}
	}
}

static void print_configuration(struct msmc_context *ctx)
{
	printf("configuration:\n");
#ifdef DEBUG
	printf("...mode: debug\n");
#else
	printf("...mode: normal\n");
#endif
	if (use_serial_port) {
		printf("...serial port: %s\n", ctx->serial_port);
	}
	else {
		printf("...network port: %s:%i\n", ctx->network_addr, ctx->network_port);
	}
	printf("...network relay port: %i\n", MSMC_DEFAULT_NETWORK_PORT);
}

int main(int argc, char *argv[])
{
	int retval;
	struct msmc_context *ctx;
	int option_index;

	printf("msmcommd (c) 2009 by Simon Busch\n");
	printf("not ready for use ... just testing out how this damn protocol works\n");

	init_talloc();

	ctx = talloc(NULL, struct msmc_context);
	snprintf(ctx->serial_port, 30, MSMC_DEFAULT_SERIAL_PORT);

	handle_options(ctx, argc, argv);

	print_configuration(ctx);

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

