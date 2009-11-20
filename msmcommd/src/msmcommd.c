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

#include <include/select.h>
#include <include/timer.h>

#define DEBUG

#define MSMC_DEFAULT_SERIAL_BAUDRATE	B115200
#define MSMC_DEFAULT_SERIAL_PORT		"/dev/modemuart"

#define MSMC_STATE_NULL					0
#define MSMC_STATE_INIT					1
#define MSMC_STATE_ACTIVE				2

#define MSMC_FRAME_TYPE_SYNC			1
#define MSMC_FRAME_TYPE_SYNC_RESP		2
#define MSMC_FRAME_TYPE_CONFIG			3
#define MSMC_FRAME_TYPE_CONFIG_RESP		4
#define MSMC_FRAME_TYPE_ACK				5
#define MSMC_FRAME_TYPE_DATA			6

#define MSMC_SYNC_SENT_INTERVAL			250

#define MSMC_FD_COUNT					2

#define MSMC_FD_SERIAL					0
#define MSMC_FD_NETWORK					1

#define MSMC_MAX_BUFFER_SIZE			4096

#define MSMC_LOG_LEVEL_DEBUG			0
#define MSMC_LOG_LEVEL_ERROR			1
#define MSMC_LOG_LEVEL_INFO				2

const char *log_level_color[] = {
	"\033[1;31m",
	"\033[1;32m",
	"\033[1;33m",
};

struct msmc_context
{
	/* Options, flags etc. */
	int network_port;
	const char serial_port[30];

	struct bsc_fd fds[MSMC_FD_COUNT];

	struct llist_head *in_buffer;
	struct llist_head *out_buffer;

	/* HCI LL specific */
	int state;
	char next_expected_seq;
};

struct frame
{
	char adress;
	char type;
	char seq;
	char ack;
	char *payload;
	unsigned int payload_len;
};

const char *frame_type_names[] = {
	"SYNC",
	"SYNC RESPONSE",
	"CONFIG",
	"CONFIG RESPONSE",
	"ACKNOWLEDGE",
	"DATA"
};

static const unsigned short crc16tab_fcs[256] = 
{
	0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf,
	0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7,
	0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e,
	0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876,
	0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd,
	0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5,
	0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c,
	0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974,
	0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb,
	0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3,
	0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a,
	0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72,
	0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9,
	0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1,
	0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738,
	0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70,
	0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7,
	0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff,
	0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036,
	0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e,
	0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5,
	0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd,
	0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134,
	0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c,
	0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3,
	0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb,
	0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232,
	0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a,
	0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1,
	0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9,
	0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330,
	0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78
};

unsigned short crc16_calc(const char *data, int len) 
{
	unsigned short sum = 0xffff;
	if (!data) return;

	while (len--)
		sum = (sum >> 8) ^ crc16tab_fcs[(sum ^ (*data++)) & 0xff];
	
	return sum;
}

void log_message(char *file, int line, int level, const char *format, ...)
{
	va_list ap;
	FILE *outfd = stderr;

	va_start(ap, format);
	
	/* color */
	fprintf(outfd, "%s", log_level_color[level]);

	char timestr[30];
	time_t t;
	t = time(NULL);
	strftime(&timestr[0], 30, "%F %H:%M:%S", localtime(&t));
	fprintf(outfd, "[%s] ", timestr);

	fprintf(outfd, "<%s:%d> ", file, line);
	vfprintf(outfd, format, ap);
	fprintf(outfd, "\033[0;m");
	fprintf(outfd, "\n");
	
	va_end(ap);

	fflush(outfd);
}

#ifdef DEBUG
#define DEBUG_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_DEBUG, fmt, ## args)
#else
#define DEBUG_MSG(fmt, args...)
#endif

struct msmc_context* msmc_context_new(void)
{
	struct msmc_context *ctx;

	ctx = (struct msmc_context*) malloc(sizeof(struct msmc_context));

	/* default settings */
	ctx->network_port = 4496;
	ctx->state = MSMC_STATE_NULL;
	ctx->next_expected_seq = 0;
}

void msmc_setup_modem(int fd)
{
	int ret;
	struct termios options;
	bzero(&options, sizeof(options));

	if (fd < 0)
		return;

	tcgetattr(fd, &options);
	cfsetispeed(&options, B115200);
	cfsetospeed(&options, B115200);

	/* local read */
	options.c_cflag |= (CLOCAL | CREAD);

	/* 8N1 */
	options.c_cflag &= ~PARENB;
	options.c_cflag &= ~CSTOPB;
	options.c_cflag &= ~CSIZE;
	options.c_cflag |= CS8;

	/* raw input */
	options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
	options.c_lflag &= ~(INLCR | ICRNL | IGNCR);

	/* raw output */
	options.c_cflag &= ~(OPOST | OLCUC | ONLRET | ONOCR | OCRNL);

	/* use hardware flow control */
	options.c_cflag &= CRTSCTS;
	options.c_iflag |= ~(IXON | IXOFF | IXANY);

	/* no special character handling */
	options.c_cc[VMIN] = 0;
	options.c_cc[VTIME] = 2;
	options.c_cc[VINTR] = 0;
	options.c_cc[VQUIT] = 0;
	options.c_cc[VSTART] = 0;
	options.c_cc[VSTOP] = 0;
	options.c_cc[VSUSP] = 0;

	ret = tcsetattr(fd, TCSANOW, &options);
	if (ret == -1) {
		DEBUG_MSG("could not configure fd %d\n", fd);
		exit(1);
	}

	/* if we use hardware flow control: set ready to read/write */
	int v24 = TIOCM_DTR | TIOCM_RTS;
	ioctl(fd, TIOCMBIS, &v24);
}
void msmc_setup_network(int fd)
{
}

void hexdump(const char *data, int len)
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


char* msmc_frame_decode(char *data, unsigned int len, unsigned int *new_len)
{
	char *decoded_data;
	if (!data) return;
	
	decoded_data = (char*) malloc(sizeof(char) * len);
	*new_len = 0;
	while(len--)
	{
		/* replace:
		 * - 0x7d 0x5d with 0x7d
		 * - 0x7d 0x5e with 0x7e
		 */
		if (*data == 0x7d && len > 0)
		{
			if (*(data+1) == 0x5d)
				*data++ = 0x7d;
			else if(*(data+1) == 0x5e)
				*data++ = 0x7e;
		}
		else 
			*decoded_data = *data;

		*new_len += 1;
		decoded_data++;
		data++;
	}


}

void msmc_frame_send(struct msmc_context *ctx, struct frame *fr)
{
	unsigned int len, decoded_payload_len;
	char *data, *decoded_payload;
	unsigned short crc;

	if (!ctx || !fr) return;

	/* encode data so 0x7e doesn't occur within the payload */
	decoded_payload = msmc_frame_decode(&data[3], fr->payload_len, &decoded_payload_len);

	/* convert our frame struct to raw binary data */
	len = 3 + decoded_payload_len + 2 + 1;
	data = (char*) malloc(sizeof(char) * len);

	data[0] = fr->adress & 0xff;
	data[1] = (fr->type << 4) & 0xff;
	data[2] = ((fr->seq << 4) | fr->ack) & 0xff;

	/* attach payload */
	memcpy(data + 3, decoded_payload, decoded_payload_len);

	/* computer crc over header + data and append it */
	crc = crc16_calc(&data[0], len - 3);
	crc ^= 0xffff;
	memcpy(data + (len - 3), &crc, 2);

	/* append end marker */
	data[len-1] = (char)0x7e;

	write(ctx->fds[MSMC_FD_SERIAL].fd, data, len);

	free(data);
	free(decoded_payload);
}

void msmc_frame_create(struct frame *fr, unsigned int type)
{
	if (!fr)
		fr = (struct frame*) malloc(sizeof(struct frame));
	
	fr->adress = 0xfa;
	fr->type = type;
	fr->seq = 0;
	fr->ack = 0;
	fr->payload = NULL;
	fr->payload_len = 0;
}

static struct timer_list sync_timer;

static void sync_timer_cb(void *_data)
{
	struct frame fr;
	struct msmc_context *ctx = (struct msmc_context*) _data;

	if (ctx->state == MSMC_STATE_NULL)
	{
		msmc_frame_create(&fr, MSMC_FRAME_TYPE_SYNC);
		msmc_frame_send(ctx, &fr);
	}

	bsc_schedule_timer(&sync_timer, 0, MSMC_SYNC_SENT_INTERVAL);
}

void msmc_link_restart(struct msmc_context *ctx)
{
	if (!ctx)
		return;

	DEBUG_MSG("restarting link control layer ...\n");

	/* reset state and send out sync packet */
	ctx->state = MSMC_STATE_NULL;

	/* the spec told us to send out three sync messages per second until we get a sync response from
	 * the other device */
	sync_timer.cb = sync_timer_cb;
	sync_timer.data = ctx;
	bsc_schedule_timer(&sync_timer, 0, MSMC_SYNC_SENT_INTERVAL);
}

void msmc_frame_type_response(struct msmc_context *ctx, struct frame *fr)
{
	struct frame frout;

	if (!ctx || !fr) return;

	switch (fr->type)
	{
		case MSMC_FRAME_TYPE_SYNC:
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_SYNC_RESP);
			msmc_frame_send(ctx, &frout);
			break;
		case MSMC_FRAME_TYPE_CONFIG:
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_CONFIG_RESP);
			/* FIXME include link configuration in frame header */
			msmc_frame_send(ctx, &frout);
			break;
		default:
			DEBUG_MSG("could not create response for unsupported frame type!\n");
			break;
	}
}

void msmc_link_establishment_control(struct msmc_context *ctx, struct frame *fr)
{
	struct frame frout;

	if (!ctx || !fr)
		return;

	DEBUG_MSG("handle incomming frame ...");

	switch (ctx->state)
	{
	case MSMC_STATE_NULL:
		/* Ignore every other frame type than SYNC and SYNC RESP */
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			bsc_del_timer(&sync_timer);
			msmc_frame_type_response(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_SYNC_RESP) {
			/* Move on into INIT state and send out config message */
			DEBUG_MSG("entering INIT state ...\n");
			ctx->state = MSMC_STATE_INIT;
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_CONFIG);
			msmc_frame_send(ctx, &frout);
		}
		break;

	case MSMC_STATE_INIT:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			/* response with a SYNC RESP message */
			msmc_frame_type_response(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* response with CONFIG RESP message */
			msmc_frame_type_response(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG_RESP) {
			/* Move on into ACTIVE state */
			DEBUG_MSG("entering ACTIVE state ...\n");
			ctx->state = MSMC_STATE_ACTIVE;
		}
		else {
			DEBUG_MSG("recieve %s frame in INIT state ... discard frame!",
					  frame_type_names[fr->type]);
		}
		break;

	case MSMC_STATE_ACTIVE:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			/* The spec told us to restart the whole stack if we receive a sync message in ACTIVE
			   state */
			msmc_link_restart(ctx);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* If we receive a CONFIG message in ACTIVE state we send out a CONFIG RESP with our
			   currrent configuration settings */
			msmc_frame_type_response(ctx, fr);
		}
		else {
			DEBUG_MSG("recieve %s frame in ACTIVE state ... discard frame!",
					  frame_type_names[fr->type]);
		}
		break;

	default:
		DEBUG_MSG("arrived in invalid state ... assuming restart!");
		msmc_link_restart(ctx);
		break;
	}
}

void msmc_link_control(struct msmc_context *ctx, struct frame *fr)
{
	if (!ctx) return;

	switch (ctx->state)
	{
		case MSMC_STATE_ACTIVE:
			if (fr->type == MSMC_FRAME_TYPE_DATA) {
			}
			else if (fr->type == MSMC_FRAME_TYPE_ACK) {
			}
			break;

		default:
			DEBUG_MSG("recieve invalid frame in ACTIVE state ... discard frame!");
			break;
	}
}

void msmc_handle_frame(struct msmc_context *ctx, const char *data, unsigned int len)
{
	unsigned short crc, fr_crc;
	struct frame *f = (struct frame*) malloc(sizeof(struct frame));

	/* the last two bytes are the crc checksum, check them! */
	fr_crc = (data[len - 1] << 4) | data[len - 2];
	crc = crc16_calc(data, len);
	if (crc != fr_crc)
	{
		DEBUG_MSG("crc checksum error! discarding frame ...\n");;
		return;
	}

	DEBUG_MSG("handle frame ...\n");
	
	/* parse frame data */
	f->adress = data[0];
	f->type = data[1] >> 4;
	f->seq  = data[2] >> 4;
	f->ack  = data[2] & 0xf;
	f->payload = data + 3;
	f->payload_len = len - 3;

	if (f->type < 5)
		msmc_link_establishment_control(ctx, f);
	else
		msmc_link_control(ctx, f);
}

void msmc_handle_incomming_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	char buffer[MSMC_MAX_BUFFER_SIZE];
	char *p;
	int start, len, last;

	DEBUG_MSG("data arrived ...\n");

	ssize_t size = read(bfd->fd, buffer, sizeof(buffer));
	DEBUG_MSG("data: len=%i\n", size);
	if (size < 0)
		return;

	/* try to find a valid frame */
	start = 0;
	last = 0;
	p = &buffer[start];
	while(*p)
	{
		if(*p == 0x7e)
		{
			DEBUG_MSG("found valid frame\n");
			last = p - start - 1;
			msmc_handle_frame(ctx, p, last);
		}
		p++;
	}
}

void msmc_handle_outgoing_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;

	/* do we have data to send? */
}

static void _serial_cb(struct bsc_fd *bfd, unsigned int flags)
{
	if (flags & BSC_FD_READ)
		return msmc_handle_incomming_data(bfd);
	if (flags & BSC_FD_WRITE) 
		return msmc_handle_outgoing_data(bfd);
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

	DEBUG_MSG("setting up ...\n");

	/* setup modem port */
	ctx->fds[MSMC_FD_SERIAL].cb = _serial_cb;
	ctx->fds[MSMC_FD_SERIAL].data = ctx;
	ctx->fds[MSMC_FD_SERIAL].when = BSC_FD_READ | BSC_FD_WRITE;
	ctx->fds[MSMC_FD_SERIAL].fd = open(ctx->serial_port, O_RDWR | O_NOCTTY);

	if (ctx->fds[MSMC_FD_SERIAL].fd < 0)
	{
		perror("Failed to open serial port!");
		return -1;
	}

	msmc_setup_modem(ctx->fds[MSMC_FD_SERIAL].fd);
	bsc_register_fd(&ctx->fds[MSMC_FD_SERIAL]);

	/* basic timer */
	timer.cb = timer_cb;
	timer.data = ctx;
	bsc_schedule_timer(&timer, 0 , 50); 

	msmc_link_restart(ctx);
}

void msmc_context_free(struct msmc_context *ctx)
{
	DEBUG_MSG("shutting down ...\n");

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

	/* parse options */
	while(1) {
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
	}
	
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

