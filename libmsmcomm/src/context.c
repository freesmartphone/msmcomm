
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

#include "internal.h"

#define BUF_LEN			4096

void *talloc_msmc_ctx;

struct msmcomm_context *msmcomm_new()
{
    struct msmcomm_context *ctx = calloc(1, sizeof (struct msmcomm_context));

    return msmcomm_init(ctx) < 0 ? 0 : ctx;
}

int msmcomm_init(struct msmcomm_context *ctx)
{
    talloc_msmc_ctx = talloc_named_const(talloc_msmc_ctx, 0, "msmcomm");
    ctx->write_cb = NULL;
    ctx->event_cb = NULL;
    return 0;
}

int msmcomm_read_from_modem(struct msmcomm_context *ctx)
{
    int len;

    uint8_t buf[BUF_LEN];

    len = ctx->read_cb(ctx->read_data, buf, BUF_LEN);
    /* server disconnected? tell client about that! */
    if (len <= 0)
        return len;

    /* what should we do with the received data? */
    handle_response_data(ctx, buf, len);

    return len;
}

void msmcomm_register_event_handler
    (struct msmcomm_context *ctx, msmcomm_event_handler_cb event_handler, void *data)
{
    ctx->event_cb = event_handler;
    ctx->event_data = data;
}

void msmcomm_register_write_handler
    (struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler, void *data)
{
    ctx->write_cb = write_handler;
    ctx->write_data = data;
}

void msmcomm_register_read_handler
    (struct msmcomm_context *ctx, msmcomm_read_handler_cb read_handler, void *data)
{
    ctx->read_cb = read_handler;
    ctx->read_data = data;
}

void msmcomm_register_error_handler
    (struct msmcomm_context *ctx, msmcomm_error_handler_cb error_handler, void *data)
{
    ctx->error_cb = error_handler;
    ctx->error_data = data;
}

void msmcomm_register_log_handler
    (struct msmcomm_context *ctx, msmcomm_log_handler_cb log_handler, void *data)
{
    ctx->log_cb = log_handler;
    ctx->log_data = data;
}

void report_error(struct msmcomm_context *ctx, int error, void *data)
{
    if (ctx->error_cb)
        ctx->error_cb(ctx->error_data, error, data);
}

int msmcomm_shutdown(struct msmcomm_context *ctx)
{
    /* FIXME */
}

unsigned int msmcomm_check_hci_version(unsigned int hci_version)
{
    unsigned int supported = 0;

    if (hci_version == 0x6)
        supported = 1;
    return supported;
}
