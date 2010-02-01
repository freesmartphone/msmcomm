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
 * MSMCOMM_EVENT_RESET_RADIO_IND
 */

struct reset_radio_ind_event
{
} __attribute__ ((packed));

unsigned int event_radio_reset_ind_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x1d) && (msg->msg_id == 0x0);
}

void event_radio_reset_ind_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	/* no data to handle */
}

void event_radio_reset_ind_free(struct msmcomm_message *msg)
{
}

/*
 * MSMCOMM_EVENT_CHARGER_STATUS
 */

struct charger_status_event 
{
	uint8_t unknown[14];
} __attribute__ ((packed));

unsigned int event_charger_status_is_valid(struct msmcomm_message *msg) 
{
	return (msg->group_id == 0x1d) && (msg->msg_id == 0x1);
}

void event_charger_status_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct charger_status_event))
		return;

	msg->payload = talloc(talloc_msmc_ctx, struct charger_status_event);
	memcpy(msg->payload, data, len);
}

void event_charger_status_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

/*
 * MSMCOMM_EVENT_OPERATOR_MODE
 */

struct operator_mode_event
{
	uint8_t unknown[15];
} __attribute__ ((packed));

unsigned int event_operator_mode_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x4) && (msg->msg_id == 0x1);
}

void event_operator_mode_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct operator_mode_event))
		return;

	msg->payload = talloc(talloc_msmc_ctx, struct operator_mode_event);
	memcpy(msg->payload, data, len);
}

void event_operator_mode_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}

/*
 * MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE
 */

struct cm_ph_info_available_event
{
} __attribute__ ((packed));

unsigned int event_cm_ph_info_available_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x5) && (msg->msg_id == 0xe);
}

void event_cm_ph_info_available_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
}

void event_cm_ph_info_available_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}
