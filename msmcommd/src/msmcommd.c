/*
 * (C) 2009-2010 by Simon Busch <morphis@gravedo.de>
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
extern int use_talloc_report;
extern int enable_logging;
int run_as_daemon = 0;

#define VALUES_PER_LINE 16

void hexdump(const uint8_t *data, uint32_t len)
{
	char ascii[VALUES_PER_LINE + 1];
	int count;
	int offset;
	uint8_t *p;
	if (!data)
		return;
	p = data;

	memset( ascii, 0, VALUES_PER_LINE + 1 );
	count = 0;

	while (len--)
	{
		uint8_t b = *p++;
		printf("%02x ", b & 0xff);
		if ( b > 32 && b < 128 )
			ascii[count] = b;
		else
			ascii[count] = '.';
		count++;

		if (count == VALUES_PER_LINE) {
			printf("      %s\n", ascii);
			memset( ascii, 0, VALUES_PER_LINE + 1 );
			count = 0;
		}
	}

	if ( count != 0 )
	{
		while ( count++ < VALUES_PER_LINE )
		{
			printf( "   " );
		}
		printf("      %s\n", ascii);
	}
}

static int init_all(struct msmc_context *ctx)
{
	if (!ctx || strlen(ctx->serial_port) == 0) return;

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
	shutdown_relay_interface(ctx);

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

static void signal_handler(int signal)
{
	fprintf(stdout, "signal %u received\n", signal);

	switch (signal) {
		case SIGINT:
			/* FIXME how to get the current context? */
			/* shutdown_all(ctx); */
			exit(0);
			break;
		case SIGABRT:
		case SIGUSR1:
		case SIGUSR2:
			talloc_report_full(NULL, stderr);
			break;
		default:
			break;
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
		printf("...network port: %s:%s\n", ctx->network_addr, ctx->network_port);
	}
	printf("...network relay port: %i\n", MSMC_DEFAULT_NETWORK_PORT);
}

struct timer_list base_timer;

static void base_timer_cb(void *data)
{
	bsc_schedule_timer(&base_timer, 5, 0);
}

int main(int argc, char *argv[])
{
	int retval;
	struct msmc_context *ctx;
	int option_index;
	struct config *cf = NULL;
	
	log_change_target(LOG_TARGET_STDERR);

	printf("msmcommd (C) 2009-2010 by Simon Busch\n");
	printf("not ready for use ... just testing out how this damn protocol works\n");

	init_talloc();

	/* setup signal handlers */
	signal(SIGINT, &signal_handler);
	signal(SIGABRT, &signal_handler);
	signal(SIGUSR1, &signal_handler);
	signal(SIGUSR2, &signal_handler);
	signal(SIGPIPE, SIG_IGN);

	/* base timer */
	base_timer.cb = base_timer_cb;
	bsc_schedule_timer(&base_timer, 5, 0);

	/* default configuration */
	ctx = talloc(NULL, struct msmc_context);
	snprintf(ctx->serial_port, BUF_SIZE, MSMC_DEFAULT_SERIAL_PORT);
	snprintf(ctx->network_port, BUF_SIZE, "4242");
	snprintf(ctx->relay_addr, BUF_SIZE, "127.0.0.1");
	
	cf = config_load("/etc/msmcommd.conf");
	if (cf == NULL) {
		fprintf(stderr, "ERROR: could not parse the configuration file at /etc/msmcommd.conf\n");
		fprintf(stderr, "INFO: using default configuration values\n");
	}
	else {
		if (cf->source_type == SOURCE_TYPE_SERIAL) {
			use_serial_port = 1;
			snprintf(ctx->serial_port, BUF_SIZE, cf->serial_path);
		}
		else if (cf->source_type == SOURCE_TYPE_NETWORK) {
			use_serial_port = 0;
			snprintf(ctx->network_addr, BUF_SIZE, cf->network_addr);
			snprintf(ctx->network_port, BUF_SIZE, cf->network_port);
		}
	}
	
	/* react on options */
	init_talloc_late();

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

