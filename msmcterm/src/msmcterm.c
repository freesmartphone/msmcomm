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

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netdb.h>

#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include <strings.h>
#include <stdarg.h>
#include <getopt.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>

#include <arpa/inet.h>

#include <msmcomm/timer.h>
#include <msmcomm/select.h>

struct msmcterm_context 
{
	struct bsc_fd bfd;
	char ifname[30];
	char remote_host[30];
};

static void print_headline(void)
{
	printf("msmcterm - terminal program for the msmcomm daemon\n");
	printf("2009-2010 Simon Busch <morphis@gravedo.de>\n");
}

static void do_exit(void)
{
	exit(1);
}

static void do_help(void)
{
	printf("help            - this help\n");
	printf("[exit|quit]     - quit this application\n");
}

static void do_dump(void)
{
	/* FIXME */
}

#define INBUF_SIZE		4096

struct timer_list default_timer;

static void default_timer_cb(void *_data)
{
	/* schedule again */
	bsc_schedule_timer(&default_timer, 0, 50);
}


int main(int argc, char *argv[])
{
	char buf[INBUF_SIZE];
	int ret;
	struct msmcterm_context ctx;

	init_talloc();

	/* default configuration */
	/* FIXME let the user define this options through cmdline arguments */
	snprintf(ctx.ifname, 30, "usb0");
	snprintf(ctx.remote_host, 30, "192.168.0.202");

/*	ctx.bfd.fd = udp_socket_open(ctx.ifname); */

	print_headline();

	/* basic timer */
	default_timer.cb = default_timer_cb;
	bsc_schedule_timer(&default_timer, 0 , 50); 

	while(1) {
		ret = bsc_select_main(0);
		if (ret < 0) {
			ERROR_MSG("bsc_select_main failed with: ");
			exit(3);
		}

		fprintf(stdout, ">> ");
		fflush(stdout);
		ret = read(fileno(stdin), buf, INBUF_SIZE);
		buf[ret] = 0;
		if(buf[ret-1] == '\n')
			buf[ret-1] = 0;
		int done = 0;
		if (!strncasecmp((char*)buf, "help", 4)) {
			do_help();
			done = 1;
		}
		if (!strncasecmp((char*)buf, "exit", 4)) {
			do_exit();
		}
		if (!strncasecmp((char*)buf, "dump", 4)) {
			do_dump();
		}

		if (!done)
			printf("!!! no such command available: %s\n", buf);
	}

	return 0;
}

