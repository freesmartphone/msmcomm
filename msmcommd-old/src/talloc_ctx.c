
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

void *talloc_llc_ctx;

void *talloc_term_ctx;

void *talloc_relay_ctx;

int use_talloc_report = 0;

void init_talloc(void)
{
    talloc_llc_ctx = talloc_named_const(talloc_llc_ctx, 0, "llc");
    talloc_relay_ctx = talloc_named_const(talloc_relay_ctx, 0, "relay");
    talloc_term_ctx = talloc_named_const(talloc_term_ctx, 0, "term");
}

void init_talloc_late(void)
{
    if (use_talloc_report)
        talloc_enable_leak_report();
}
