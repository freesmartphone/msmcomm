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
extern void *talloc_llc_ctx;

LLIST_HEAD(data_handlers);
LLIST_HEAD(tx_queue);
LLIST_HEAD(ack_queue);

struct timer_list ack_timer;

static uint8_t next_sequence_nr(struct msmc_context *ctx)
{
	uint8_t seq = ctx->next_seq;
	ctx->next_seq = (ctx->next_seq + 1) % MSMC_LLC_MAX_SEQUENCE_NR;
	return seq;
}

static void serial_port_setup(int fd)
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

void send_frame(struct msmc_context *ctx, struct frame *fr)
{
	uint32_t len, encoded_payload_len;
	uint8_t *data, *encoded_payload;
	uint16_t crc;

	if (!ctx || !fr) return;

	/* encode data so 0x7e doesn't occur within the payload */
	encode_frame(fr);

	/* convert our frame struct to raw binary data */
	len = 3 + encoded_payload_len + 2 + 1;
	data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * len);

	data[0] = fr->adress & 0xff;
	data[1] = (fr->type << 4) & 0xff;
	data[2] = ((fr->seq << 4) | fr->ack) & 0xff;

	/* attach payload */
	memcpy(data + 3, encoded_payload, encoded_payload_len);

	/* computer crc over header + data and append it */
	crc = crc16_calc(&data[0], len - 4);
	crc ^= 0xffff;
	memcpy(data + (len - 3), &crc, 2);

	/* append end marker */
	data[len-1] = (char)0x7e;

	write(ctx->fds[MSMC_FD_SERIAL].fd, data, len);

	talloc_free(data);
	talloc_free(encoded_payload);
}

static struct timer_list sync_timer;

static void sync_timer_cb(void *_data)
{
	struct frame fr;
	struct msmc_context *ctx = (struct msmc_context*) _data;

	if (ctx->state == MSMC_STATE_NULL)
	{
		init_frame(&fr, MSMC_FRAME_TYPE_SYNC);
		send_frame(ctx, &fr);
	}

	bsc_schedule_timer(&sync_timer, 0, MSMC_SYNC_SENT_INTERVAL);
}

static void restart_link(struct msmc_context *ctx)
{
	if (!ctx)
		return;

	DEBUG_MSG("restarting link control layer ...\n");

	/* reset state and send out sync packet */
	ctx->state = MSMC_STATE_NULL;
	ctx->window_size = MSMC_LLC_WINDOW_SIZE;
	ctx->next_seq = 0;
	ctx->next_ack = 0;
	ctx->expected_seq = 0;

	/* the spec told us to send out three sync messages per second until we get a sync response from
	 * the other device */
	sync_timer.cb = sync_timer_cb;
	sync_timer.data = ctx;
	bsc_schedule_timer(&sync_timer, 0, MSMC_SYNC_SENT_INTERVAL);
}

static void handle_frame_type(struct msmc_context *ctx, struct frame *fr)
{
	struct frame frout;

	if (!ctx || !fr) return;

	switch (fr->type)
	{
		case MSMC_FRAME_TYPE_SYNC:
			init_frame(&frout, MSMC_FRAME_TYPE_SYNC_RESP);
			send_frame(ctx, &frout);
			break;
		case MSMC_FRAME_TYPE_CONFIG:
			init_frame(&frout, MSMC_FRAME_TYPE_CONFIG_RESP);
			/* FIXME include link configuration in frame header */
			send_frame(ctx, &frout);
			break;
		default:
			DEBUG_MSG("could not create response for unsupported frame type!\n");
			break;
	}
}

static void link_establishment_control(struct msmc_context *ctx, struct frame *fr)
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
			handle_frame_type(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_SYNC_RESP) {
			/* Move on into INIT state and send out config message */
			DEBUG_MSG("entering INIT state ...\n");
			ctx->state = MSMC_STATE_INIT;
			init_frame(&frout, MSMC_FRAME_TYPE_CONFIG);
			send_frame(ctx, &frout);
		}
		break;

	case MSMC_STATE_INIT:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			/* response with a SYNC RESP message */
			handle_frame_type(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* response with CONFIG RESP message */
			handle_frame_type(ctx, fr);
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
			restart_link(ctx);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			/* If we receive a CONFIG message in ACTIVE state we send out a CONFIG RESP with our
			   currrent configuration settings */
			handle_frame_type(ctx, fr);
		}
		else {
			DEBUG_MSG("recieve %s frame in ACTIVE state ... discard frame!",
					  frame_type_names[fr->type]);
		}
		break;

	default:
		ERROR_MSG("arrived in invalid state ... assuming restart!");
		restart_link(ctx);
		break;
	}
}

/* a <= b < c (modulo) */
static uint8_t is_valid_ack(uint8_t a, uint8_t b, uint8_t c)
{
	uint8_t valid = 0;
	if (((a <= b) && (b < c)) || ((c < a) && (a <= b)) || ((b < c) && (c < a)))
		valid = 1;
	return valid;
}

static void process_rcvd_ack(struct msmc_context *ctx, const uint8_t ack)
{
	struct frame *fr;
	uint32_t count;

	/* count of frames which are not acknowledged should be less or equal than 
	 * the max window size */
	if (llist_count(&ack_queue) > MSMC_LLC_WINDOW_SIZE) {
		/* resend and remove them from ack_queue */
		count = 0;
		llist_for_each_entry(fr, &ack_queue, list) {
			if (count == MSMC_LLC_WINDOW_SIZE)
				break;

			llist_del(&fr->list);
			send_frame(ctx, fr);

			count++;
		}
	}

	/* check which frames are acknowledged with this ack */
	llist_for_each_entry(fr, &ack_queue, list) {
		if (!is_valid_ack(ctx->last_ack, fr->seq, ack))
			break;
		llist_del(&fr->list);
	}

	if (llist_empty(&ack_queue)) {
		/* ack_queue is empty so stop ack timer */
		bsc_del_timer(&ack_timer);
	}

	ctx->last_ack = ack;
	ctx->expected_seq = ack;
}

static void link_control(struct msmc_context *ctx, struct frame *fr)
{
	if (!ctx) return;

	switch (ctx->state)
	{
		case MSMC_STATE_ACTIVE:
			if (fr->type == MSMC_FRAME_TYPE_DATA) {
				/* Our frame is not the frame with the expected sequence nr */
				if (fr->seq != ctx->expected_seq) {
					/* FIXME We should really drop this frame? */
					return;
				}
				
				/* handle received acknowledge */
				process_rcvd_ack(ctx, fr->ack);
				
				/* we have new data for our registered data handlers */
				struct msmc_data_handler *dh;
				llist_for_each_entry(dh, &data_handlers, list) {
					dh->cb(ctx, fr->payload, fr->payload_len);
				}
			}
			else if (fr->type == MSMC_FRAME_TYPE_ACK) {
				/* this frame is a pure ack frame and does not has a valid seq 
				   nr so ingore it */
				process_rcvd_ack(ctx, fr->ack);
			}
			break;

		default:
			ERROR_MSG("recieve invalid frame in ACTIVE state ... discard frame!");
			break;
	}
}

static void handle_frame(struct msmc_context *ctx, const uint8_t *data, uint32_t len)
{
	unsigned short crc, fr_crc;
	struct frame *fr = talloc_zero(talloc_llc_ctx, struct frame);

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
	fr->adress = data[0];
	fr->type = data[1] >> 4;
	fr->seq  = data[2] >> 4;
	fr->ack  = data[2] & 0xf;

	/* decode frame payload first */
	decode_frame(fr);

	/* delegate frame handling corresponding to the frame type */
	if (fr->type < MSMC_FRAME_TYPE_ACK)
		link_establishment_control(ctx, fr);
	else
		link_control(ctx, fr);

	talloc_free(fr);
}

static void handle_llc_incomming_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	char buffer[MSMC_MAX_BUFFER_SIZE];
	char *p;
	uint32_t start, len, last;

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
			handle_frame(ctx, p, last);
		}
		p++;
	}
}

void schedule_llc_data(struct msmc_context *ctx, const uint8_t *data, uint32_t len)
{
	struct frame *fr = talloc(talloc_llc_ctx, struct frame);
	fr->type = MSMC_FRAME_TYPE_DATA;
	fr->payload = data;
	fr->payload = len;

	llist_add_tail(&fr->list, &tx_queue);
}

static void ack_timer_cb(void *data)
{
	struct msmc_context *ctx = (struct msmc_context*) data;
	struct frame *fr;

	/* ack timer event occured, so one or more frames are not acknowledged
	 * in time, so we have to resend this frames */
	llist_for_each_entry(fr, &ack_queue, list) {
		/* remove frame from ack_queue, send_frame will add it again later */
		llist_del(&fr->list);
		send_frame(ctx, fr);
	}
}

static void add_ack_timer(struct msmc_context *ctx, struct frame *fr)
{
	/* FIXME inlude check if ack_queue length is greater than the current window 
	 * size? */

	/* Save frame for resending if transmission goes wrong */
	llist_add_tail(&fr->list, &ack_queue);

	/* Reschedule timer cause we received a new frame */
	bsc_reschedule_timer(&ack_timer, 1, 0);
}

static void handle_llc_outgoing_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	struct frame *fr;

	llist_for_each_entry(fr, &tx_queue, list) {
		/* prepare frame with correct seq and ack */
		fr->seq = next_sequence_nr(ctx);
		fr->ack = ctx->next_ack;

		send_frame(ctx, fr);

		/* remove from tx queue and start ack timer */
		llist_del(&fr->list);
		add_ack_timer(ctx, fr);
	}
}

static void _llc_cb(struct bsc_fd *bfd, uint32_t flags)
{
	if (flags & BSC_FD_READ)
		handle_llc_incomming_data(bfd);
	if (flags & BSC_FD_WRITE) 
		handle_llc_outgoing_data(bfd);
}

void register_llc_data_handler (struct msmc_context *ctx, msmc_data_handler_cb_t cb)
{
	struct msmc_data_handler *dh = talloc_zero(talloc_llc_ctx, struct msmc_data_handler);
	dh->cb = cb;
	llist_add_tail(&dh->list, &data_handlers);
}

int init_llc(struct msmc_context *ctx)
{
	/* setup modem port */
	ctx->fds[MSMC_FD_SERIAL].cb = _llc_cb;
	ctx->fds[MSMC_FD_SERIAL].data = ctx;
	ctx->fds[MSMC_FD_SERIAL].when = BSC_FD_READ | BSC_FD_WRITE;
	ctx->fds[MSMC_FD_SERIAL].fd = open(ctx->serial_port, O_RDWR | O_NOCTTY);

	if (ctx->fds[MSMC_FD_SERIAL].fd < 0) {
		ERROR_MSG("failed to open serial port '%s'", ctx->serial_port);
		return ctx->fds[MSMC_FD_SERIAL].fd;
	}

	serial_port_setup(ctx->fds[MSMC_FD_SERIAL].fd);
	bsc_register_fd(&ctx->fds[MSMC_FD_SERIAL]);

	restart_link(ctx);

	return 1;
}

void shutdown_llc(struct msmc_context *ctx)
{
	/* remove all data handlers */
	if (!llist_empty(&data_handlers)) {
		struct msmc_data_handler *dh;
		llist_for_each_entry(dh, &data_handlers, list) {
			llist_del(&dh->list);
			talloc_free(dh);
		}
	}

	/* close serial port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
	close(ctx->fds[MSMC_FD_SERIAL].fd);
}

