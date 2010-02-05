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

#include <signal.h>
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

#include <msmcomm.h>

struct bsc_fd net_fd;
struct bsc_fd con_fd;
char ifname[30];
char remote_host[30];
unsigned short remote_port;

int dump_enabled = 0;

static int tcp_sock_open()
{
	int fd, rc, on = 1;
	struct sockaddr_in sa;

	fd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (fd < 0) {
		perror("socket()");
		return fd;
	}

#if 0
	if (ctx->ifname) {
		rc = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, ctx->ifname,
						strlen(ctx->ifname));
		if (rc < 0) {
			close(fd);
			perror("setsockopt()");
			return rc;
		}
	}
#endif 

	rc = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
	if (rc < 0) {
		close(fd);
		perror("setsockopt()");
		return rc;
	}

	sa.sin_family = AF_INET;
	sa.sin_port = htons(remote_port);
	sa.sin_addr.s_addr = inet_addr(remote_host);

	rc = connect(fd, (struct sockaddr*) &sa, sizeof(sa));
	if (rc < 0) {
		perror("connect()");
		return rc;
	}

	return fd;
}

static void print_headline(void)
{
	printf("msmcterm - terminal program for the msmcomm daemon\n");
	printf("2009-2010 Simon Busch <morphis@gravedo.de>\n");
}

static void do_exit(void)
{		
	bsc_unregister_fd(&net_fd);
	bsc_unregister_fd(&con_fd);
	close(net_fd.fd);
	exit(1);
}

static void do_help(void)
{
	printf("help            - this help\n");
	printf("[exit|quit]     - quit this application\n");
	printf("get_imei		- receive imei from modem\n");
	printf("get_firmware_info - get firmware info string from modem\n");
	printf("change_operation_mode [mode] - change operation modem of the modem\n");
	printf("\tmodes: reset, online, offline\n");
	printf("get_phone_state_info - get current phone state\n");
	printf("test_alive - test if the modem is actually running\n");
	printf("verify_pin <pin> - authenticate to the sim card with your pin\n");
	printf("get_charger_status - query the current charging status\n");
	printf("charge_usb <voltage> - set the usb charging mode\n");
	printf("\tvoltage: 0=250mA, 1=500mA, 2=1A\n");
}

static void do_dump(char *args)
{
	char *end;
	int result;

	result = strtoul(args, &end, 0);
	if (result && !dump_enabled) {
		printf("-> enabled dumping of incomming data!\n");
		dump_enabled = 1;
	}
	else if(dump_enabled) {
		printf("-> disabled dumping of incomming data!\n");
		dump_enabled = 0;
	}
}

static void do_get_imei(struct msmcomm_context *ctx)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_GET_IMEI);
	msmcomm_send_message(ctx, msg);
}

static void do_change_operation_mode(struct msmcomm_context *ctx, char *args)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE);

	uint8_t mode = MSMCOMM_OPERATION_MODE_RESET;
	
	printf ("args = %s\n", args);
	
	if (!strncasecmp((char*)args+1, "reset", 5)) {
		printf("-> reset\n");
		mode = MSMCOMM_OPERATION_MODE_RESET;
	}
	if (!strncasecmp((char*)args+1, "online", 6)) {
		printf("-> online\n");
		mode = MSMCOMM_OPERATION_MODE_ONLINE;
	}
	if (!strncasecmp((char*)args+1, "offline", 7)) {
		printf("-> offline\n");
		mode = MSMCOMM_OPERATION_MODE_OFFLINE;
	}

	msmcomm_message_change_operation_mode_set_operation_mode(msg, mode);
	msmcomm_send_message(ctx, msg);
}

static void do_get_firmware_info(struct msmcomm_context *ctx)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx,
								 MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO);
	if (msg != NULL)
		msmcomm_send_message(ctx, msg);
}

static void do_test_alive(struct msmcomm_context *ctx)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_TEST_ALIVE);
	msmcomm_send_message(ctx, msg);
}

static void do_get_phone_state_info(struct msmcomm_context *ctx)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx,
								 MSMCOMM_MESSAGE_CMD_GET_PHONE_STATE_INFO);
	msmcomm_send_message(ctx, msg);
}

static void do_verify_pin(struct msmcomm_context *ctx, char *args)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_VERIFY_PIN);
	uint8_t pin[8];
	args++;
	snprintf(pin, 8, "%s", args);
	msmcomm_message_verify_pin_set_pin(msg, pin, 8);	
	msmcomm_send_message(ctx, msg);
}

static void do_get_charger_status(struct msmcomm_context *ctx)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_GET_CHARGER_STATUS);
	msmcomm_message_set_ref_id(msg, 0xa);
	msmcomm_send_message(ctx, msg);
}

static void do_charge_usb(struct msmcomm_context *ctx, char *args)
{
	struct msmcomm_message *msg;
	msg = msmcomm_create_message(ctx, MSMCOMM_MESSAGE_CMD_CHARGE_USB);
	msmcomm_message_set_ref_id(msg, 0xb);

	int mode = atoi(args+1);

	if (mode == 0)
		msmcomm_message_charge_usb_set_mode(msg, MSMCOMM_CHARGE_USB_MODE_250mA);
	else if (mode == 2)
		msmcomm_message_charge_usb_set_mode(msg, MSMCOMM_CHARGE_USB_MODE_1A);
	else
		msmcomm_message_charge_usb_set_mode(msg, MSMCOMM_CHARGE_USB_MODE_500mA);

	msmcomm_send_message(ctx, msg);
}

static int network_write_cb(void *_data, uint8_t *data, uint32_t len)
{
	return send(net_fd.fd, data, len, 0);
}

static int network_read_cb(void *_data, uint8_t *data, uint32_t len)
{
	return recv(net_fd.fd, data, len, 0);
}

static void network_event_cb(void *_data, int event, struct msmcomm_message *message)
{
	if (event == MSMCOMM_EVENT_RESET_RADIO_IND) {
		printf("got event: MSMCOMM_EVENT_RESET_RADIO_IND\n");
	}
	else if (event == MSMCOMM_RESPONSE_GET_IMEI) {
		printf("got response: MSMCOMM_RESPONSE_GET_IMEI\n");
	}
	else if (event == MSMCOMM_RESPONSE_GET_FIRMWARE_INFO) {
		printf("got response: MSMCOMM_RESPONSE_GET_FIRMWARE_INFO\n");
		
		char buffer[100];
		msmcomm_resp_get_firmware_info_get_info(message, &buffer, 100);
		printf("info: %s\n", buffer);
	}
	else if (event == MSMCOMM_EVENT_CHARGER_STATUS) {
		printf("got event: MSMCOMM_EVENT_CHARGER_STATUS\n");
	}
	else if (event == MSMCOMM_RESPONSE_GET_CHARGER_STATUS)
	{
		printf("got response MSMCOMM_RESPONSE_GET_CHARGER_STATUS\n");
	}
	else if (event == MSMCOMM_RESPONSE_CHARGE_USB) {
		printf("got response MSMCOMM_RESPONSE_CHARGE_USB\n");
	}
	else if (event == MSMCOMM_RESPONSE_TEST_ALIVE) {
		printf("got response. MSMCOMM_RESPONSE_TEST_ALIVE\n");
	}
	else if (event == MSMCOMM_EVENT_SIM_PIN1_ENABLED) {
		printf("got event MSMCOMM_EVENT_SIM_PIN1_ENABLED\n");
	}
	else if (event == MSMCOMM_EVENT_SIM_PIN2_ENABLED) {
		printf("got event MSMCOMM_EVENT_SIM_PIN2_ENABLED\n");
	}
	else if (event == MSMCOMM_EVENT_SIM_PIN1_VERIFIED) {
		printf("got event MSMCOMM_EVENT_SIM_PIN1_VERIFIED\n");
	}
	else if (event == MSMCOMM_EVENT_SIM_PIN1_BLOCKED) {
		printf("got event MSMCOMM_EVENT_SIM_PIN1_BLOCKED\n");
	}
	else if (event == MSMCOMM_EVENT_CALL_INCOMMING) {
		printf("got event MSMCOMM_EVENT_CALL_INCOMMING\n");
	}
	else if (event == MSMCOMM_EVENT_CALL_ORIGINATION) {
		printf("got event MSMCOMM_EVENT_CALL_ORIGINATION\n");
	}
	else if (event == MSMCOMM_EVENT_CALL_CONNECT) {
		printf("got event MSMCOMM_EVENT_CALL_CONNECT\n");
	}
	else if (event == MSMCOMM_EVENT_CALL_END) {
		printf("got event MSMCOMM_EVENT_CALL_END\n");
	}
}

static int network_cb(struct bsc_fd *bfd, unsigned int flags)
{
	struct msmcomm_context *ctx = (struct msmcomm_context*) bfd->data;
	int rc;

	/* read from modem */
	if (flags & BSC_FD_READ) {
		rc = msmcomm_read_from_modem(ctx);
		if (rc <= 0) {
			do_exit();
		}
	}
}


#define INBUF_SIZE		4096

static int console_cb(struct bsc_fd *bfd, unsigned int flags)
{
	char buf[INBUF_SIZE];
	int ret;
	struct msmcomm_context *ctx = (struct msmcomm_context*) bfd->data;

	if (flags & BSC_FD_READ) {
		ret = read(fileno(stdin), buf, INBUF_SIZE);
		buf[ret] = 0;
		if(buf[ret-1] == '\n')
			buf[ret-1] = 0;
		int done = 0;

		/* internal commands */
		if (!strncasecmp((char*)buf, "help", 4)) {
			do_help();
			done = 1;
		}
		if (!strncasecmp((char*)buf, "exit", 4) ||
			!strncasecmp((char*)buf, "quit", 4)) {
			do_exit();
		}
		if (!strncasecmp((char*)buf, "dump", 4)) {
			do_dump(&buf[4]);
			done = 1;
		}

		/* msmcomm command */
		if (!strncasecmp((char*)buf, "change_operation_mode", 21)) {
			do_change_operation_mode(ctx, &buf[21]);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "get_imei", 8)) {
			do_get_imei(ctx);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "get_firmware_info", 17)) {
			do_get_firmware_info(ctx);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "get_phone_state_info", 20)) {
			do_get_phone_state_info(ctx);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "test_alive", 10)) {
			do_test_alive(ctx);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "verify_pin", 10)) {
			do_verify_pin(ctx, &buf[10]);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "get_charger_status", 18))
		{
			do_get_charger_status(ctx);
			done = 1;
		}
		if (!strncasecmp((char*)buf, "charge_usb", 11))
		{
			do_charge_usb(ctx, &buf[11]);
			done = 1;
		}

		if (!done)
			printf("!!! no such command available: %s\n", buf);
	}

	return 0;
}

static void signal_handler(int signal)
{
	switch (signal) {
	case SIGINT:
		do_exit();
	default:
		break;
	}
}

static void do_cmd_help()
{
	printf("usage: msmcterm [options]\n");
	printf("\t-f, --interface=INTERFACE   specify a interface for the connection\n");
	printf("\t-i, --ip-address=IP         specify the ip address to connect to\n");
	printf("\t-p, --port=PORT             specify the port msmcterm should for the connection\n");
	printf("\t-h, --help                  show this help\n");
	exit(1);
}

static void handle_options(int argc, char *argv[])
{
	opterr = 0;
	int option_index;
	int chr;
	int check_arg[2];
	memset(check_arg, 0, 2);
	
	struct option opts[] = {
		{ "interface", required_argument, 0, 'f' },
		{ "ip-address", required_argument, 0, 'i' },
		{ "port", required_argument, 0, 'p' },
		{ "help", required_argument, 0, 'h' },
	};

	while(1) {
		option_index = 0;
		chr = getopt_long(argc, argv, "f:i:ph", opts, &option_index);
		if (chr == -1)
			break;
		switch (chr) {
		case 'f':
			snprintf(ifname, 30, "%s", optarg);
			break;
		case 'i':
			snprintf(remote_host, 30, "%s", optarg);
			break;
		case 'p':
			remote_port = atoi(remote_port);
			break;
		case 'h':
			do_cmd_help();
			break;
		case '?':
			break;
		default:
			break;
		}
	}
}

int main(int argc, char *argv[])
{
	char buf[INBUF_SIZE];
	int ret;
	struct msmcomm_context ctx;

	/* default configuration */
	/* FIXME let the user define this options through cmdline arguments */
	snprintf(ifname, 30, "lo");
	snprintf(remote_host, 30, "127.0.0.1");
	remote_port = 3030;

	handle_options(argc, argv);

	printf("connecting to '%s:%i' on '%s'\n", remote_host, remote_port, ifname);

	con_fd.fd = fileno(stdin);
	con_fd.when = BSC_FD_READ;
	con_fd.cb = console_cb;
	con_fd.data = &ctx;
	bsc_register_fd(&con_fd);

	net_fd.fd = tcp_sock_open();
	if (net_fd.fd < 0) {
		printf("something went wrong while configuring the network" \
			   "interface!\n");
		exit(1);
	}

	net_fd.when = BSC_FD_READ;
	net_fd.cb = network_cb;
	net_fd.data = &ctx;
	bsc_register_fd(&net_fd);

	signal(SIGINT, &signal_handler);

	msmcomm_init(&ctx);
	msmcomm_register_write_handler(&ctx, network_write_cb, &ctx);
	msmcomm_register_event_handler(&ctx, network_event_cb, &ctx);
	msmcomm_register_read_handler(&ctx, network_read_cb, &ctx);

	print_headline();

	while(1) {
		ret = bsc_select_main(0);
		if (ret < 0) {
			printf("bsc_select_main failed with: ");
			exit(3);
		}
	}

	msmcomm_shutdown(&ctx);

	return 0;
}

