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
extern int use_serial_port;

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

static int network_port_setup(struct msmc_context *ctx)
{
	int fd;

	/* FIXME enhance log output */

	fd = socket(PF_INET, SOCK_STREAM, 0);
	if (fd < 0) {
		perror("Failed to create network socket");
		return EXIT_FAILURE;
	}

	struct hostent* host = gethostbyname(ctx->network_addr);
	if (!host) {
		printf("Failed to get the hostent\n");
		return EXIT_FAILURE;
	}

	struct sockaddr_in addr = { 0, };
	addr.sin_family = PF_INET;
	addr.sin_port = htons(atoi(ctx->network_port));
	addr.sin_addr = *(struct in_addr*)host->h_addr;

	int result = connect(fd, (struct sockaddr*)&addr, sizeof(addr));
	if (result < 0) {
		perror("Connection failed");
		return EXIT_FAILURE;
	}

	return fd;
}

static int serial_port_setup(struct msmc_context *ctx)
{
	int ret;
	int flush = 0;
	struct hsuart_mode mode;
	int fd;

	fd = open(ctx->serial_port, O_RDWR | O_NOCTTY);

	if (fd < 0)
		return;

	/* configure the hsuart like TelephonyInterfaceLayerGsm does */

	/* flush everything */
	flush = HSUART_RX_QUEUE | HSUART_TX_QUEUE | HSUART_RX_FIFO | HSUART_TX_FIFO;
	ioctl(fd, HSUART_IOCTL_FLUSH, flush);

	/* get current mode */
	ioctl(fd, HSUART_IOCTL_GET_UARTMODE, &mode);

	/* speed and flow control */
	mode.speed = HSUART_SPEED_115K;
	mode.flags |= HSUART_MODE_PARITY_NONE;
	mode.flags |= HSUART_MODE_FLOW_CTRL_HW;

	ioctl(fd, HSUART_IOCTL_SET_UARTMODE, &mode);

	/* we want flow control for the rx line */
	ioctl(fd, HSUART_IOCTL_RX_FLOW, HSUART_RX_FLOW_ON);

	return fd;

#if 0
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
#endif 
}

void send_frame(struct msmc_context *ctx, struct frame *fr)
{
	uint32_t len;
	uint8_t *data;
	uint16_t crc;

	if (!ctx || !fr) return;

	/* encode data so 0x7e doesn't occur within the payload */
	encode_frame(fr);

	/* convert our frame struct to raw binary data */
	len = 3 + fr->payload_len + 2 + 1;
	data = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * len);

	data[0] = fr->address & 0xff;
	data[1] = ((fr->type << 4) | fr->unknown) & 0xff;
	data[2] = ((fr->seq << 4) | fr->ack) & 0xff;

	/* attach payload */
	memcpy(data + 3, fr->payload, fr->payload_len);

	/* computer crc over header + data and append it */
	crc = crc16_calc(&data[0], len - 3);
	crc ^= 0xffff;
	memcpy(data + (len - 3), &crc, 2);

	/* append end marker */
	data[len-1] = (char)0x7e;
	
	DEBUG_MSG("send frame: ");
	hexdump(data, len);

	write(ctx->fds[MSMC_FD_SERIAL].fd, data, len);

	talloc_free(data);
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

	bsc_schedule_timer(&sync_timer, MSMC_SYNC_SENT_INTERVAL_SEC, MSMC_SYNC_SENT_INTERVAL_MS);
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
	bsc_schedule_timer(&sync_timer, MSMC_SYNC_SENT_INTERVAL_SEC, MSMC_SYNC_SENT_INTERVAL_MS);
}

static void handle_frame_type(struct msmc_context *ctx, struct frame *fr)
{
	struct frame frout;

	if (!ctx || !fr) return;

	switch (fr->type)
	{
		case MSMC_FRAME_TYPE_SYNC:
			init_frame(&frout, MSMC_FRAME_TYPE_SYNC_RESP);

			/* FIXME found out why 0x8 is set beside the frame type */
			frout.unknown = 0x8;

			send_frame(ctx, &frout);
			DEBUG_MSG("send SYNC RESP frame");
			break;
		case MSMC_FRAME_TYPE_CONFIG:
			init_frame(&frout, MSMC_FRAME_TYPE_CONFIG_RESP);
			
			/* FIXME found out why 0x8 is set beside the frame type */
			frout.unknown = 0x8;

			/* FIXME include link configuration in frame header */
			send_frame(ctx, &frout);
			DEBUG_MSG("send CONFIG RESP frame");
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

	switch (ctx->state)
	{
	case MSMC_STATE_NULL:
		/* Ignore every other frame type than SYNC and SYNC RESP */
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			DEBUG_MSG("received SYNC frame");
			handle_frame_type(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_SYNC_RESP) {
			DEBUG_MSG("received SYNC RESP frame");
			/* Move on into INIT state and send out config message */
			DEBUG_MSG("entering INIT state ...");
			bsc_del_timer(&sync_timer);
			ctx->state = MSMC_STATE_INIT;
			
			DEBUG_MSG("send CONFIG frame");
			init_frame(&frout, MSMC_FRAME_TYPE_CONFIG);
			send_frame(ctx, &frout);
		}
		break;

	case MSMC_STATE_INIT:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			DEBUG_MSG("received SYNC frame");
			/* response with a SYNC RESP message */
			handle_frame_type(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			DEBUG_MSG("received CONFIG frame");
			/* response with CONFIG RESP message */
			handle_frame_type(ctx, fr);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG_RESP) {
			DEBUG_MSG("received CONFIG RESP frame");
			/* Move on into ACTIVE state */
			DEBUG_MSG("entering ACTIVE state ...\n");
			ctx->state = MSMC_STATE_ACTIVE;
		}
		else {
			DEBUG_MSG("recieve %s frame in INIT state ... discard frame!",
					  frame_type_names[fr->type-1]);
		}
		break;

	case MSMC_STATE_ACTIVE:
		if (fr->type == MSMC_FRAME_TYPE_SYNC) {
			DEBUG_MSG("received SYNC frame");
			/* The spec told us to restart the whole stack if we receive 
			 * a sync message in ACTIVE state */
			restart_link(ctx);
		}
		else if (fr->type == MSMC_FRAME_TYPE_CONFIG) {
			DEBUG_MSG("received CONFIG frame");
			/* If we receive a CONFIG message in ACTIVE state we send out a 
			 * CONFIG RESP with our currrent configuration settings */
			handle_frame_type(ctx, fr);
		}
		else {
			DEBUG_MSG("recieve %s frame in ACTIVE state ... discard frame!",
					  frame_type_names[fr->type-1]);
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
	struct frame *fr, *tmp;
	uint32_t count;
	
	DEBUG_MSG("enter");

	/* count of frames which are not acknowledged should be less or equal than 
	 * the max window size */
	if (llist_count(&ack_queue) > MSMC_LLC_WINDOW_SIZE) {
		/* resend and remove them from ack_queue */
		count = 0;
		llist_for_each_entry_safe(fr, tmp, &ack_queue, list) {
			if (count == MSMC_LLC_WINDOW_SIZE)
				break;

			llist_del(&fr->list);
			send_frame(ctx, fr);

			count++;
		}
	}

	/* check which frames are acknowledged with this ack */
	llist_for_each_entry_safe(fr, tmp, &ack_queue, list) {
		if (!is_valid_ack(ctx->last_ack, fr->seq, ack))
			break;
		llist_del(&fr->list);
		DEBUG_MSG("remove acked frame");
	}

	if (llist_empty(&ack_queue)) {
		/* ack_queue is empty so stop ack timer */
		bsc_del_timer(&ack_timer);
	}

	ctx->last_ack = ack;
	ctx->expected_seq = ack;
	
	DEBUG_MSG("leave");
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

static void handle_frame(struct msmc_context *ctx, uint8_t *data, uint32_t len)
{
	unsigned short crc, fr_crc, crc_result = 0xf0b8;
	struct frame *fr = talloc_zero(talloc_llc_ctx, struct frame);

	/* the last two bytes are the crc checksum, check them! */
	fr_crc = (data[len-2] << 4) | data[len-1];
	crc = crc16_calc(data, len);
	if (crc != crc_result)
	{
		DEBUG_MSG("crc checksum error! discarding frame ...\n");;
		return;
	}

	/* parse frame data */
	fr->address = data[0];
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
	uint8_t *p, *start, *end;
	uint8_t len;

	ssize_t size = read(bfd->fd, buffer, sizeof(buffer));
	if (size < 0)
		return;
		
	DEBUG_MSG("receive frame:");
	hexdump(buffer, size);

	/* try to find a valid frame */
	p = buffer;
	start = buffer;
	end = &buffer[size-1];
	while (p <= end) {
		if (*p == 0x7e) {
			len = p - start;
			handle_frame(ctx, start, len);
			start = p + 1;
		}
		p++;
	}
}

void schedule_llc_data(struct msmc_context *ctx, const uint8_t *data, uint32_t len)
{
	struct frame *fr = talloc_zero(talloc_llc_ctx, struct frame);
	fr->address = 0xfa;
	fr->type = MSMC_FRAME_TYPE_DATA;
	fr->payload = talloc_zero_size(talloc_llc_ctx, sizeof(uint8_t) * len);
	memcpy(fr->payload, data, len);
	fr->payload_len = len;

	llist_add_tail(&fr->list, &tx_queue);
}

static void ack_timer_cb(void *data)
{
	struct msmc_context *ctx = (struct msmc_context*) data;
	struct frame *fr, *tmp;

	/* ack timer event occured, so one or more frames are not acknowledged
	 * in time, so we have to resend this frames */
	llist_for_each_entry_safe(fr, tmp, &ack_queue, list) {
		/* remove frame from ack_queue, send_frame will add it again later */
		send_frame(ctx, fr);
		llist_del(&fr->list);
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
	printf("test");
}

static void handle_llc_outgoing_data(struct bsc_fd *bfd)
{
	struct msmc_context *ctx = bfd->data;
	struct frame *fr, *tmp;
	
	llist_for_each_entry_safe(fr, tmp, &tx_queue, list) {	
		/* prepare frame with correct seq and ack */
		fr->seq = next_sequence_nr(ctx);
		fr->ack = ctx->next_ack;

		DEBUG_MSG("fr->payload: 0x%x\n", fr->payload);
		send_frame(ctx, fr);
		
		/* remove from tx queue and start ack timer */
		llist_del_init(&fr->list);
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
	INIT_LLIST_HEAD(&ack_queue);
	INIT_LLIST_HEAD(&tx_queue);
	
	/* setup modem port */
	ctx->fds[MSMC_FD_SERIAL].cb = _llc_cb;
	ctx->fds[MSMC_FD_SERIAL].data = ctx;
	ctx->fds[MSMC_FD_SERIAL].when = BSC_FD_READ | BSC_FD_WRITE;
	
	if (use_serial_port)
		ctx->fds[MSMC_FD_SERIAL].fd = serial_port_setup(ctx);
	else 
		ctx->fds[MSMC_FD_SERIAL].fd = network_port_setup(ctx);

	ack_timer.cb = ack_timer_cb;
	ack_timer.data = ctx;

#if 0
	ctx->fds[MSMC_FD_SERIAL].fd = open(ctx->serial_port, O_RDWR | O_NOCTTY);

	if (ctx->fds[MSMC_FD_SERIAL].fd < 0) {
		ERROR_MSG("failed to open serial port '%s'", ctx->serial_port);
		return ctx->fds[MSMC_FD_SERIAL].fd;
	}

	serial_port_setup(ctx->fds[MSMC_FD_SERIAL].fd);
#endif 

	bsc_register_fd(&ctx->fds[MSMC_FD_SERIAL]);

	restart_link(ctx);

	return 1;
}

void shutdown_llc(struct msmc_context *ctx)
{
	/* remove all data handlers */
	if (!llist_empty(&data_handlers)) {
		struct msmc_data_handler *dh, *tmp;
		llist_for_each_entry_safe(dh, tmp, &data_handlers, list) {
			llist_del(&dh->list);
			talloc_free(dh);
		}
	}

	/* close serial port */
	bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
	close(ctx->fds[MSMC_FD_SERIAL].fd);
}
