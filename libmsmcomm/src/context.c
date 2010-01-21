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

void *talloc_msmc_ctx;

int msmcomm_init(struct msmcomm_context *ctx)
{
	talloc_msmc_ctx = talloc_named_const(talloc_msmc_ctx, 0, "msmcomm");
	ctx->write_cb = NULL;
	ctx->event_cb = NULL;
	return 0;
}

int msmcomm_read_from_modem(struct msmcomm_context *ctx, int modem_fd)
{
	return -1;
}

void msmcomm_register_event_handler(struct msmcomm_context *ctx, msmcomm_event_handler_cb
									event_handler)
{
	ctx->event_cb = event_handler;
}

void msmcomm_register_write_handler(struct msmcomm_context *ctx, msmcomm_write_handler_cb
									write_handler)
{
	ctx->write_cb = write_handler;
}

int msmcomm_shutdown(struct msmcomm_context *ctx)
{
}




