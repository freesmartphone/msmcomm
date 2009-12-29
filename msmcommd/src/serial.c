
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

extern const char *frame_type_names[];

LLIST_HEAD(data_handlers);

void _serial_modem_setup(int fd)
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

void _frame_send(struct msmc_context *ctx, struct frame *fr)
{
	unsigned int len, decoded_payload_len;
	char *data, *decoded_payload;
	unsigned short crc;

	if (!ctx || !fr) return;

	/* encode data so 0x7e doesn't occur within the payload */
	decoded_payload = msmc_frame_decode(&data[3], fr->payload_len, &decoded_payload_len);

	/* convert our frame struct to raw binary data */
	len = 3 + decoded_payload_len + 2 + 1;
	data = (unsigned char*) malloc(sizeof(unsigned char) * len);

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

static struct timer_list sync_timer;

static void sync_timer_cb(void *_data)
{
	struct frame fr;
	struct msmc_context *ctx = (struct msmc_context*) _data;

	if (ctx->state == MSMC_STATE_NULL)
	{
		msmc_frame_create(&fr, MSMC_FRAME_TYPE_SYNC);
		_frame_send(ctx, &fr);
	}

	bsc_schedule_timer(&sync_timer, 0, MSMC_SYNC_SENT_INTERVAL);
}

void _link_restart(struct msmc_context *ctx)
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

void _frame_type_handle(struct msmc_context *ctx, struct frame *fr)
{
	struct frame frout;

	if (!ctx || !fr) return;

	switch (fr->type)
	{
		case MSMC_FRAME_TYPE_SYNC:
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_SYNC_RESP);
			_frame_send(ctx, &frout);
			break;
		case MSMC_FRAME_TYPE_CONFIG:
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_CONFIG_RESP);
			/* FIXME include link configuration in frame header */
			_frame_send(ctx, &frout);
			break;
		default:
			DEBUG_MSG("could not create response for unsupported frame type!\n");
			break;
	}
}

void _link_establishment_control(struct msmc_context *ctx, struct frame *fr)
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
			_frame_type_handle(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_SYNC_RESP) {
			/* Move on into INIT state and send out config message */
			DEBUG_MSG("entering INIT state ...\n");
			ctx->state = MSMC_STATE_INIT;
			msmc_frame_create(&frout, MSMC_FRAME_TYPE_CONFIG);
			_frame_send(ctx, &frout);
		}
		break;

	case MSMC_STATE_INIT:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			/* response with a SYNC RESP message */
			_frame_type_handle(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* response with CONFIG RESP message */
			_frame_type_handle(ctx, fr);
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
			_link_restart(ctx);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* If we receive a CONFIG message in ACTIVE state we send out a CONFIG RESP with our
			   currrent configuration settings */
			_frame_type_handle(ctx, fr);
		}
		else {
			DEBUG_MSG("recieve %s frame in ACTIVE state ... discard frame!",
					  frame_type_names[fr->type]);
		}
		break;

	default:
		DEBUG_MSG("arrived in invalid state ... assuming restart!");
		_link_restart(ctx);
		break;
	}
}

void _link_control(struct msmc_context *ctx, struct frame *fr)
{
	if (!ctx) return;

	switch (ctx->state)
	{
		case MSMC_STATE_ACTIVE:
			if (fr->type == MSMC_FRAME_TYPE_DATA) {
				/* FIXME add handling of seq/ack number */

				/* we have new data for our registered data handlers */
				struct msmc_data_handler *dh;
				llist_for_each_entry(dh, &data_handlers, list) {
					dh->cb(ctx, fr->payload, fr->payload_len);
				}
			}
			else if (fr->type == MSMC_FRAME_TYPE_ACK) {
				/* FIXME add handling of seq/ack number */
			}
			break;

		default:
			DEBUG_MSG("recieve invalid frame in ACTIVE state ... discard frame!");
			break;
	}
}

void _frame_handle(struct msmc_context *ctx, const unsigned char *data, unsigned int len)
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

	/* delegate frame handling corresponding to the frame type */
	if (f->type < MSMC_FRAME_TYPE_ACK)
		_link_establishment_control(ctx, f);
	else
		_link_control(ctx, f);
}

void _serial_incomming_data_handle(struct bsc_fd *bfd)
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
			_frame_handle(ctx, p, last);
		}
		p++;
	}
}

void _serial_data_schedule(struct msmc_context *ctx, const unsigned char *data, unsigned int len)
{

}

void _serial_outgoing_data_handle(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;

	/* do we have data to send? */
	/* FIXME 
	 * - sequnce number handling
	 * - process list of packets we have to send
	 */
}

static void _serial_cb(struct bsc_fd *bfd, unsigned int flags)
{
	if (flags & BSC_FD_READ)
		_serial_incomming_data_handle(bfd);
	if (flags & BSC_FD_WRITE) 
		_serial_outgoing_data_handle(bfd);
}

void msmc_serial_data_handler_add (struct msmc_context *ctx, msmc_data_handler_cb_t cb)
{
	struct msmc_data_handler *dh = NEW(struct msmc_data_handler, 1);
	dh->cb = cb;
	llist_add_tail(&data_handlers, &dh->list);
}

void msmc_serial_init(struct msmc_context *ctx)
{
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

	_serial_modem_setup(ctx->fds[MSMC_FD_SERIAL].fd);
	bsc_register_fd(&ctx->fds[MSMC_FD_SERIAL]);

	_link_restart(ctx);
}

void msmc_serial_shutdown(struct msmc_context *ctx)
{
	/* close serial port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
	close(ctx->fds[MSMC_FD_SERIAL].fd);

}

