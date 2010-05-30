
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

struct timer_list tx_timer;

unsigned int is_tx_timer = 0;

static uint8_t next_sequence_nr(struct msmc_context *ctx)
{
    uint8_t seq = ctx->next_seq;

    ctx->next_seq = (ctx->next_seq + 1) % (MSMC_LLC_MAX_SEQUENCE_NR + 1);
    return seq;
}

static uint8_t next_ack_nr(struct msmc_context *ctx)
{
    ctx->next_ack = (ctx->next_ack + 1) % (MSMC_LLC_MAX_SEQUENCE_NR + 1);
    return ctx->next_ack;
}

static int network_port_setup(struct msmc_context *ctx)
{
    int fd;

    /* FIXME enhance log output */

    fd = socket(PF_INET, SOCK_STREAM, 0);
    if (fd < 0)
    {
        perror("Failed to create network socket");
        return EXIT_FAILURE;
    }

    struct hostent *host = gethostbyname(ctx->network_addr);

    if (!host)
    {
        printf("Failed to get the hostent\n");
        return EXIT_FAILURE;
    }

    struct sockaddr_in addr = { 0, };
    addr.sin_family = PF_INET;
    addr.sin_port = htons(atoi(ctx->network_port));
    addr.sin_addr = *(struct in_addr *)host->h_addr;

    int result = connect(fd, (struct sockaddr *)&addr, sizeof (addr));

    if (result < 0)
    {
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
}

static void enqueue_frame_async(struct frame *fr)
{
    struct tx_item *ti;

    if (fr == NULL)
        return;

    ti = (struct tx_item *)malloc(sizeof (struct tx_item));
    if (ti == NULL)
    {
        ERROR_MSG("Could not allocate memory. No more memory available?");
        return;
    }

    /* add tx item to tx queue for sending */
    ti->frame = fr;
    ti->attempts = 0;
    llist_add_tail(&ti->list, &tx_queue);

    /* start tx timer if it is not already running */
    if (!is_tx_timer)
    {
        is_tx_timer = 1;
        bsc_schedule_timer(&tx_timer, 0, 50);
    }
}

void send_frame(struct msmc_context *ctx, struct frame *fr)
{
    uint32_t len, tmp;

    uint8_t *data;

    uint16_t crc;

    int rc;

    if (!ctx || !fr)
        return;

    /* convert our frame struct to raw binary data */
    len = 3 + fr->payload_len + 2 + 1;
    data = talloc_size(talloc_llc_ctx, sizeof (uint8_t) * len);

    data[0] = fr->address & 0xff;
    data[1] = ((fr->type << 4) | fr->unknown) & 0xff;
    data[2] = ((fr->seq << 4) | fr->ack) & 0xff;

    /* attach payload */
    memcpy(data + 3, fr->payload, fr->payload_len);

    /* computer crc over header + data and append it */
    crc = crc16_calc(&data[0], len - 3);
    crc ^= 0xffff;

    /* save len of payload */
    tmp = fr->payload_len;

    /* now encode whole frame payload */
    encode_frame(fr);

    if (tmp > fr->payload_len)
    {
        /* some bytes are now encoded so payload size has grown -> resize frame
         * data */
        len -= tmp + fr->payload_len;
        data = talloc_realloc(talloc_llc_ctx, data, uint8_t, len);

        /* reset frame data without touching the header */
        memset(data + 3, 0, len - 3);
    }

    /* attach payload again */
    memcpy(data + 3, fr->payload, fr->payload_len);

    memcpy(data + (len - 3), &crc, 2);
    /* append end marker */
    data[len - 1] = (char)0x7e;

    DEBUG_MSG("send frame to modem (seq=0x%x, ack=0x%x)", fr->seq, fr->ack);
    hexdump(data, len);

    rc = write(ctx->fds[MSMC_FD_SERIAL].fd, data, len);
    if (rc == -EAGAIN)
    {
        DEBUG_MSG("got EAGAIN !!!");
    }

    talloc_free(data);
}

static struct timer_list sync_timer;

static void sync_timer_cb(void *_data)
{
    struct frame fr;

    struct msmc_context *ctx = (struct msmc_context *)_data;

    if (ctx->state == MSMC_STATE_NULL)
    {
        init_frame(&fr, MSMC_FRAME_TYPE_SYNC);
        send_frame(ctx, &fr);
        bsc_schedule_timer(&sync_timer, MSMC_SYNC_SENT_INTERVAL_SEC, MSMC_SYNC_SENT_INTERVAL_MS);
    }
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
    ctx->last_ack = 0;

    /* the spec told us to send out three sync messages per second until we get a sync response from
     * the other device */
    sync_timer.cb = sync_timer_cb;
    sync_timer.data = ctx;
    bsc_schedule_timer(&sync_timer, MSMC_SYNC_SENT_INTERVAL_SEC, MSMC_SYNC_SENT_INTERVAL_MS);

    /* clean lists on restart */
    INIT_LLIST_HEAD(&ack_queue);
    INIT_LLIST_HEAD(&tx_queue);

    /* clear rx buffer */
    buffer_reset(ctx->rx_buf);
    ctx->rx_buf_size = 0;
}

static void tx_item_try_send(struct msmc_context *ctx, struct tx_item *ti)
{
    assert(ti != NULL);
    assert(ti->frame != NULL);

    if (ti->attempts >= MSMC_FRAME_MAX_ATTEMPTS)
    {
        DEBUG("We have send a packet more than %i times with no response, restarting link!");
        restart_link(ctx);
        return;
    }

    send_frame(ctx, ti->frame);
    ti->attempts++;
}

static void handle_frame_type(struct msmc_context *ctx, struct frame *fr)
{
    struct frame frout;

    uint8_t tmp;

    if (!ctx || !fr)
        return;

    switch (fr->type)
    {
        case MSMC_FRAME_TYPE_SYNC:
            DEBUG_MSG("send SYNC RESP frame");
            init_frame(&frout, MSMC_FRAME_TYPE_SYNC_RESP);

            /* FIXME found out why 0x8 is set beside the frame type */
            frout.unknown = 0x0;
            send_frame(ctx, &frout);
            break;
        case MSMC_FRAME_TYPE_CONFIG:
            DEBUG_MSG("send CONFIG RESP frame");
            init_frame(&frout, MSMC_FRAME_TYPE_CONFIG_RESP);

            /* FIXME found out why 0x8 is set beside the frame type */
            frout.unknown = 0x0;
            frout.payload_len = 1;
            frout.payload = talloc(talloc_llc_ctx, uint8_t);
            frout.payload[0] = 0x11;

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

    switch (ctx->state)
    {
        case MSMC_STATE_NULL:
            /* Ignore every other frame type than SYNC and SYNC RESP */
            if (fr->type == MSMC_FRAME_TYPE_SYNC)
            {
                DEBUG_MSG("received SYNC frame");
                handle_frame_type(ctx, fr);
            }
            else if (fr->type == MSMC_FRAME_TYPE_SYNC_RESP)
            {
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
            if (fr->type == MSMC_FRAME_TYPE_SYNC)
            {
                DEBUG_MSG("received SYNC frame");
                /* response with a SYNC RESP message */
                handle_frame_type(ctx, fr);
            }
            else if (fr->type == MSMC_FRAME_TYPE_CONFIG)
            {
                DEBUG_MSG("received CONFIG frame");
                /* response with CONFIG RESP message */
                handle_frame_type(ctx, fr);
            }
            else if (fr->type == MSMC_FRAME_TYPE_CONFIG_RESP)
            {
                DEBUG_MSG("received CONFIG RESP frame");
                /* Move on into ACTIVE state */
                DEBUG_MSG("entering ACTIVE state ...\n");
                ctx->state = MSMC_STATE_ACTIVE;
            }
            else
            {
                DEBUG_MSG("recieve %s frame in INIT state ... discard frame!",
                          frame_type_names[fr->type - 1]);
            }
            break;

        case MSMC_STATE_ACTIVE:
            if (fr->type == MSMC_FRAME_TYPE_SYNC)
            {
                DEBUG_MSG("received SYNC frame");
                DEBUG_MSG("got SYNC FRAME in ACTIVE state -> restart link!");
                /* The spec told us to restart the whole stack if we receive 
                 * a sync message in ACTIVE state */
                restart_link(ctx);
            }
            else if (fr->type == MSMC_FRAME_TYPE_CONFIG)
            {
                DEBUG_MSG("received CONFIG frame");
                /* If we receive a CONFIG message in ACTIVE state we send out a 
                 * CONFIG RESP with our currrent configuration settings */
                handle_frame_type(ctx, fr);
            }
            else
            {
                DEBUG_MSG("recieve %s frame in ACTIVE state ... discard frame!",
                          frame_type_names[fr->type - 1]);
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
    struct tx_item *ti, *tmp;

    uint32_t count;

    count = llist_count(&ack_queue);

    /* FIXME move this to ack_timer_cb as we only should handle acknowledging of
     * frames and not resending them! */
    /* count of frames which are not acknowledged should be less or equal than 
     * the max window size */
    if (llist_count(&ack_queue) > MSMC_LLC_WINDOW_SIZE)
    {
        /* resend and remove them from ack_queue */
        count = 0;
        llist_for_each_entry_safe(ti, tmp, &ack_queue, list)
        {
            if (count == MSMC_LLC_WINDOW_SIZE)
                break;

            llist_del(&ti->list);
            tx_item_try_send(ctx, ti);
            count++;
        }
    }

    /* check which frames are acknowledged with this ack */
    llist_for_each_entry_safe(ti, tmp, &ack_queue, list)
    {
        if (!is_valid_ack(ctx->last_ack, ti->frame->seq, ack))
        {
            break;
        }
        llist_del(&ti->list);
    }

    if (llist_empty(&ack_queue))
    {
        /* ack_queue is empty so stop ack timer */
        bsc_del_timer(&ack_timer);
    }

    ctx->last_ack = ack;
}

static void ack_frame(struct msmc_context *ctx, struct frame *fr)
{
    int count;

    struct frame ack_fr;

    /* check wether there are frames waiting for sending */
#if 0
    count = llist_count(&tx_queue);
    if (count > 0)
    {
        /* FIXME */
    }
    else
    {
#endif

        ack_fr.address = 0xfa;
        ack_fr.type = MSMC_FRAME_TYPE_ACK;
        ack_fr.seq = 0x0;
        ack_fr.ack = next_ack_nr(ctx);
        ctx->expected_seq = ack_fr.ack;
        ack_fr.unknown = 0x0;
        ack_fr.payload = NULL;
        ack_fr.payload_len = 0;

        send_frame(ctx, &ack_fr);
#if 0
    }
#endif
}

static void link_control(struct msmc_context *ctx, struct frame *fr)
{
    if (!ctx)
        return;

    switch (ctx->state)
    {
        case MSMC_STATE_ACTIVE:
            if (fr->type == MSMC_FRAME_TYPE_DATA)
            {
                /* Our frame is not the frame with the expected sequence nr */
                if (fr->seq != ctx->expected_seq)
                {
                    /* FIXME We should really drop this frame? */
                    return;
                }

                /* handle received acknowledge */
                process_rcvd_ack(ctx, fr->ack);

                /* acknowledge this frame */
                ack_frame(ctx, fr);

                DEBUG_MSG("receive data from modem (seq=0x%x, ack=0x%x)", fr->seq, fr->ack);
                DEBUG_MSG("payload is:");
                hexdump(fr->payload, fr->payload_len);

                /* we have new data for our registered data handlers */
                struct msmc_data_handler *dh;

                llist_for_each_entry(dh, &data_handlers, list)
                {
                    dh->cb(ctx, fr->payload, fr->payload_len);
                }
            }
            else if (fr->type == MSMC_FRAME_TYPE_ACK)
            {
                /* this frame is a pure ack frame and does not has a valid seq 
                   nr so ingore it */
                process_rcvd_ack(ctx, fr->ack);
            }
            break;

        default:
            ERROR_MSG("recieve frame in wrong state ... discard frame!");
            break;
    }
}

static void handle_frame(struct msmc_context *ctx, uint8_t * data, uint32_t len)
{
    unsigned short crc, fr_crc, crc_result = 0xf0b8;

    uint8_t *tmp;

    uint32_t tmp_len;

    struct frame *fr;

    fr = talloc_zero(talloc_llc_ctx, struct frame);

    /* copy data for decoding */
    tmp = talloc_size(talloc_llc_ctx, sizeof (uint8_t) * len);
    memcpy(tmp, data, len);
    fr->payload = tmp;
    fr->payload_len = len;

    /* decode frame */
    decode_frame(fr);
    tmp_len = fr->payload_len;

    /* the last two bytes are the crc checksum, check them! */
    fr_crc = (tmp[len - 2] << 8) | tmp[len - 1];
    crc = crc16_calc(tmp, tmp_len);
    if (crc != crc_result)
    {
        hexdump(tmp, tmp_len);
        return;
    }

    /* parse frame data */
    fr->address = tmp[0];
    fr->type = tmp[1] >> 4;
    fr->seq = tmp[2] >> 4;
    fr->ack = tmp[2] & 0xf;
    fr->payload = NULL;
    fr->payload_len = 0;
    if (len > 5)
    {
        fr->payload = &tmp[3];
        fr->payload_len = tmp_len - 5;
    }

    /* delegate frame handling corresponding to the frame type */
    if (fr->type < MSMC_FRAME_TYPE_ACK)
        link_establishment_control(ctx, fr);
    else
        link_control(ctx, fr);

    talloc_free(fr);
    talloc_free(tmp);
}

static void handle_llc_incomming_data(struct bsc_fd *bfd)
{
    struct msmc_context *ctx = bfd->data;

    char buffer[MSMC_MAX_BUFFER_SIZE];

    uint8_t *p, *start, *end;

    uint8_t len, success = 0, n = 0;

    ssize_t size = read(bfd->fd, buffer, sizeof (buffer));

    if (size <= 0)
    {
        /* FIXME shutdown !!! */
        return;
    }

    /* put everything into our rx buffer */
    buffer_put(ctx->rx_buf, buffer, size);
    ctx->rx_buf_size += size;

    /* try to find a valid frame */
    p = buffer_getstr(ctx->rx_buf);
    start = p;
    end = p + ctx->rx_buf_size;
    while (p <= end)
    {
        if (*p == 0x7e)
        {
            handle_frame(ctx, start, p - start);
            start = p + 1;
        }
        p++;
    }

    /* do we have some data left? */
    if (end - start <= 0)
    {
        ctx->rx_buf_size = 0;
        buffer_reset(ctx->rx_buf);
    }
    else
    {
        buffer_reset(ctx->rx_buf);
        ctx->rx_buf_size = end - start;
        buffer_put(ctx->rx_buf, start, end - start);
    }
}

void schedule_llc_data(struct msmc_context *ctx, const uint8_t * data, uint32_t len)
{
    struct frame *fr = talloc_zero(talloc_llc_ctx, struct frame);

    fr->address = 0xfa;
    fr->type = MSMC_FRAME_TYPE_DATA;
    fr->payload = talloc_zero_size(talloc_llc_ctx, sizeof (uint8_t) * len);
    memcpy(fr->payload, data, len);
    fr->payload_len = len;

    enqueue_frame_async(fr);

#if 0
    llist_add_tail(&fr->list, &tx_queue);

    /* start tx_queue timer */
    if (!is_tx_timer)
    {
        is_tx_timer = 1;
        bsc_schedule_timer(&tx_timer, 0, 50);
    }
#endif
}

static void ack_timer_cb(void *data)
{
    struct msmc_context *ctx = (struct msmc_context *)data;

    struct tx_item *ti, *tmp;

    /* ack timer event occured, so one or more frames are not acknowledged
     * in time, so we have to resend this frames */
    llist_for_each_entry_safe(ti, tmp, &ack_queue, list)
    {
        /* remove frame from ack_queue, send_frame will add it again later */
        tx_item_try_send(ctx, ti);
    }

    /* Reschedule ack timer as we are still waiting for the right acknowledge */
    bsc_reschedule_timer(&ack_timer, 1, 0);
}

static void add_ack_timer(struct msmc_context *ctx, struct tx_item *ti)
{
    /* FIXME inlude check if ack_queue length is greater than the current window 
     * size? */

    /* Save frame for resending if transmission goes wrong */
    llist_add_tail(&ti->list, &ack_queue);

    /* Reschedule timer cause we received a new frame */
    bsc_reschedule_timer(&ack_timer, 1, 0);
}

static void handle_llc_outgoing_data(void *data)
{
    struct msmc_context *ctx = data;

    struct tx_item *ti, *tmp;

    int res = 0;

    llist_for_each_entry_safe(ti, tmp, &tx_queue, list)
    {
        /* prepare frame with correct seq and ack */
        ti->frame->seq = next_sequence_nr(ctx);
        ti->frame->ack = ctx->next_ack;

        tx_item_try_send(ctx, ti);

        /* remove from tx queue and start ack timer */
        llist_del_init(&ti->list);
        add_ack_timer(ctx, ti);
    }

    is_tx_timer = 0;
}

static int _llc_cb(struct bsc_fd *bfd, uint32_t flags)
{
    if (flags & BSC_FD_READ)
        handle_llc_incomming_data(bfd);
    return 0;
}

void register_llc_data_handler(struct msmc_context *ctx, msmc_data_handler_cb_t cb)
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
    ctx->fds[MSMC_FD_SERIAL].when = BSC_FD_READ;

    if (use_serial_port)
        ctx->fds[MSMC_FD_SERIAL].fd = serial_port_setup(ctx);
    else
        ctx->fds[MSMC_FD_SERIAL].fd = network_port_setup(ctx);

    bsc_register_fd(&ctx->fds[MSMC_FD_SERIAL]);

    /* setup ack timer */
    ack_timer.cb = ack_timer_cb;
    ack_timer.data = ctx;

    /* setup tx timer */
    tx_timer.cb = handle_llc_outgoing_data;
    tx_timer.data = ctx;

    /* setup rx buffer */
    ctx->rx_buf = buffer_new(0);
    ctx->rx_buf_size = 0;

    restart_link(ctx);

    return 1;
}

void shutdown_llc(struct msmc_context *ctx)
{
    /* remove all data handlers */
    if (!llist_empty(&data_handlers))
    {
        struct msmc_data_handler *dh, *tmp;

        llist_for_each_entry_safe(dh, tmp, &data_handlers, list)
        {
            llist_del(&dh->list);
            talloc_free(dh);
        }
    }

    /* close serial port */
    bsc_unregister_fd(&ctx->fds[MSMC_FD_SERIAL]);
    close(ctx->fds[MSMC_FD_SERIAL].fd);
}
