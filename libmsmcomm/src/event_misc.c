
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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_RESET_RADIO_IND
 */

unsigned int event_radio_reset_ind_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1d) && (msg->msg_id == 0x0);
}

void event_radio_reset_ind_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct radio_reset_ind_event))
        return;
    msg->payload = data;
}

uint32_t event_radio_reset_ind_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct radio_reset_ind_event);
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_CHARGER_STATUS
 */

unsigned int event_charger_status_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1d) && (msg->msg_id == 0x1);
}

void event_charger_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct charger_status_event))
        return;

    msg->payload = data;
}

unsigned int msmcomm_event_charger_status_get_voltage(struct msmcomm_message *msg)
{
    /* FIXME */
    return MSMCOMM_CHARGING_VOLTAGE_MODE_500mA;
}

uint32_t event_charger_status_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct charger_status_event);
}

