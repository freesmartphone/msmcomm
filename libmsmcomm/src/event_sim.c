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

extern void *talloc_msmc_ctx;

/*
 * MSMCOMM_EVENT_SIM_INSERTED
 */

struct sim_inserted_event
{
} __attribute__ ((packed));

unsigned int event_sim_inserted_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x11) && (msg->msg_id == 0x0);
}

void event_sim_inserted_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* no data to handle */
}

void event_sim_inserted_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_EVENT_PIN1_ENABLED
 */

struct pin1_enabled_event
{
} __attribute__ ((packed));

unsigned int event_pin1_enabled_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x11) && (msg->msg_id == 0xc);
}

void event_pin1_enabled_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* no data to handle */
}

void event_pin1_enabled_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_EVENT_PIN2_ENABLED
 */

struct pin2_enabled_event
{
} __attribute__ ((packed));

unsigned int event_pin2_enabled_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x11) && (msg->msg_id == 0x13);
}

void event_pin2_enabled_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* no data to handle */
}

void event_pin2_enabled_free(struct msmcomm_message *msg)
{
}

