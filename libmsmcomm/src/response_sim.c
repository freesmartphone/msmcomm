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

#include "internal.h"

/*
 * MSMCOMM_RESPONSE_GET_SIM_CAPABILITIES
 */

/* Notes:
 * - when the voice mail number is aquired, this messages contains it
 * - it's even the response for the verify-pin message
 */

unsigned int resp_get_sim_capabilities_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x10) && (msg->msg_id == 0x1);
}

void resp_get_sim_capabilities_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* FIXME */
}

void resp_get_sim_capabilities_free(struct msmcomm_message *msg)
{
}
