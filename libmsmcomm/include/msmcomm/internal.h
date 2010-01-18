/* 
 * (c) 2010 by Simon Busch <morphis@gravedo.de>
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

#ifndef INTERNAL_H_
#define INTERNAL_H_

#include <msmcomm/linuxlist.h>
#include <msmcomm/msmcomm.h>

struct msmcomm_context
{
	msmcomm_event_handler_cb event_cb;
	msmcomm_write_handler_cb write_cb;
};

struct msmcomm_message
{
	uint8_t group_id;
	uint8_t msg_id;
};

#endif

