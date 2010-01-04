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

struct msmcterm_context 
{
	struct bsc_fd bfd;
	int subscription_done;
	char ifname[30];
	char remote_host[30];
};

static int udp_socket_open(const char *ifname)
{
	int fd, rc;
	struct sockaddr_in sa;
	
	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (fd < 0)
		return fd;

	if (ifname) {
		rc = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, ifname, strlen(ifname));
		if (rc < 0)
			goto err;
	}

	sa.sin_family = AF_INET;
	sa.sin_port = htons(MSMC_DEFAULT_NETWORK_PORT);
	sa.sin_addr.s_addr = INADDR_ANY;

	rc = bind(fd, (struct sockaddr*) &sa, sizeof(sa));
	if (rc < 0)
		goto err;
	
	return fd;

err:
	close(fd);
	return rc;
}

static void print_headline(void)
{
	printf("msmcterm - terminal program for the msmcomm daemon\n");
	printf("2009-2010 Simon Busch <morphis@gravedo.de>\n");
}

static void do_exit(void)
{
	exit(1);
}

static void do_subscribe(struct msmcterm_context *ctx)
{
	if (ctx->subscription_done) {
		DEBUG_MSG("Subscription was already send and acknowledged. Don't resending request.");
		return;
	}
	struct control_message *ctrl_msg = msmc_control_message_new();
	msmc_control_message_format_cmd(ctrl_msg, MSMC_CONTROL_MSG_CMD_SUBSCRIBE);
	msmc_control_message_send(ctx->bfd.fd, ctrl_msg);
	msmc_control_message_free(ctrl_msg);
}

static void do_help(void)
{
	printf("help            - this help\n");
	printf("[exit|quit]     - quit this application\n");
	printf("subscribe       - subscribe on remote host to let him forward incomming data to us\n");
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

	/* default configuration */
	/* FIXME let the user define this options through cmdline arguments */
	snprintf(ctx.ifname, 30, "usb0");
	snprintf(ctx.remote_host, 30, "192.168.0.202");

	ctx.subscription_done = 0;
	ctx.bfd.fd = udp_socket_open(ctx.ifname);

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
		if (!strncasecmp((char*)buf, "subscribe", 9)) {
			do_subscribe(&ctx);
			done = 1;
		}

		if (!done)
			printf("!!! no such command available: %s\n", buf);
	}

	return 0;
}

