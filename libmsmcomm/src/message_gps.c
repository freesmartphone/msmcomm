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
 * MSMCOMM_MESSAGE_CMD_GET_LOCATION_PRIV_PREF
 */
struct get_location_priv_pref_msg
{
	uint8_t unknown[13];
} __attribute__ ((packed));

void msg_get_location_priv_pref_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x21;
	msg->msg_id = 0x3;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct get_location_priv_pref_msg);
	
	MESSAGE_CAST(msg, struct get_location_priv_pref_msg)->unknown[5] = 0x3;
	MESSAGE_CAST(msg, struct get_location_priv_pref_msg)->unknown[9] = 0x11;
}

uint32_t msg_get_location_priv_pref_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct get_location_priv_pref_msg);
}

void msg_get_location_priv_pref_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_get_location_priv_pref_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}
