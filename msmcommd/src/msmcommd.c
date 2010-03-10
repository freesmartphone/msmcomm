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
	offset = 0;

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

	if(count <= VALUES_PER_LINE)
		printf("\n");
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

static void do_print_help()
{
	printf("help: \n");
	printf(" -s --serial-port <path> the serial port which provides the modem link\n");
	printf(" -n --network <addr> remote network adress to use instead of a serial port\n");
	printf(" -p --network-port <port> if you use a network connection instead of a " \
		   "serial port than you can specify the port\n");
	printf(" -t --talloc-report enable talloc memory report\n");
	printf(" -r --relay <addr> specifiy the address on which msmcommd should" \
		   " listen for incomming connections\n");
	printf(" -l --log-target [stderr|file] define where log messags should appear (default: stderr)\n");
	printf(" -h --help this help\n");
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

static void handle_options(struct msmc_context *ctx, int argc, char *argv[])
{
	opterr = 0;
	int option_index;
	int chr;
	int check_arg[2];
	check_arg[0] = 0;
	check_arg[1] = 0;
	char tmp[10];
	
	/* specify our default log target */
	log_change_target(LOG_TARGET_STDERR);

	struct option opts[] = {
		{ "serial-port", required_argument, 0, 's' },
		{ "network", required_argument, 0, 'n'},
		{ "network-port", required_argument, 0, 'p'},
		{ "relay", required_argument, 0, 'r' },
		{ "help", no_argument, 0, 'h' },
		{ "log-target", required_argument, 0, 'l' },
		{ "daemon", no_argument, 0, 'd' },
	};

	while (1) {
		option_index = 0;
		chr = getopt_long(argc, argv, "s:n:p:r:hl:dvt", opts, &option_index);

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
				exit(1);
			case 't':
				use_talloc_report = 1;
				break;
			case 'r':
				snprintf(ctx->relay_addr, 30, "%s", optarg);
				break;
			case 'l':
				snprintf(tmp, 10, "%s", optarg);
				if (strncmp(tmp, "file", 10) < 0) {
					log_change_target(LOG_TARGET_FILE);
				}
				break;
			case 'd':
				run_as_daemon = 1;
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
		printf("...network port: %s:%s\n", ctx->network_addr, ctx->network_port);
	}
	printf("...network relay port: %i\n", MSMC_DEFAULT_NETWORK_PORT);
}

struct timer_list base_timer;

static void base_timer_cb(void *data)
{
	bsc_schedule_timer(&base_timer, 5, 0);
}

static void daemonize()
{
	pid_t pid, sid;
	
	/* fork off the parent process */
	pid = fork();
	if (pid < 0)
		exit(1);
		
	/* change file mode mask */
	umask(0);
	
	/* create new sid for the child process */
	sid = setsid();
	if (sid < 0)
		exit(1);
		
	/* change current work-directory */
	/* FIXME check that the run-directory exists! */
	if ((chdir("/var/run/msmcommd")) < 0)
		exit(1);
	
	/* close std. file descriptors and log to file */
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);
	log_change_target(LOG_TARGET_FILE);
}

int main(int argc, char *argv[])
{
	int retval;
	struct msmc_context *ctx;
	int option_index;

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
	snprintf(ctx->serial_port, 30, MSMC_DEFAULT_SERIAL_PORT);
	snprintf(ctx->network_port, 10, "4242");
	snprintf(ctx->relay_addr, 30, "127.0.0.1");

	/* command line option handling */
	handle_options(ctx, argc, argv);
	
	/* should we run as daemon? */
	if (run_as_daemon)
		daemonize();

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

