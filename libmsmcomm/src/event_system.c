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

#if 0
struct reset_radio_ind_event
{
} __attribute__ ((packed));
#endif

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

#if 0
struct charger_status_event 
{
	uint8_t unknown0[6];
	uint16_t voltage;
	uint8_t unknown1[7];
} __attribute__ ((packed));
#endif

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

unsigned int msmcomm_event_charger_status_get_voltage(struct msmcomm_message *msg)
{
	/* FIXME */
	return MSMCOMM_CHARGE_USB_MODE_500mA;
}

/*
 * MSMCOMM_EVENT_OPERATOR_MODE
 */

#if 0
struct operator_mode_event
{
	uint8_t unknown[15];
} __attribute__ ((packed));
#endif

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

/*
 * MSMCOMM_EVENT_POWER_STATE
 */

/*
 * [NFY] tel.flightmodenotification disabled
 * notifyPowerState
 * PACKET: dir=read fd=11 fn='/dev/modemuart' len=18/0x12
 * frame (type=Data, seq=04, ack=0a)
 * 04 01 00 0e 00 00 00 05 00 01 ff ff ff ff 00      ............... 
 */

#if 0
struct power_state_event
{
	uint8_t unknown0[5];
	uint8_t power_state;
	uint8_t unknown1[7];
} __attribute__ ((packed));
#endif

unsigned int event_power_state_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x4) && (msg->msg_id == 0x1);
}

void event_power_state_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct power_state_event)) {
		/* FIXME logging! */
		return;
	}
	
	msg->payload = talloc_zero(talloc_msmc_ctx, struct power_state_event);
	memcpy(msg->payload, data, len);
}

void event_power_state_free(struct msmcomm_message *msg)
{
	if (msg->payload != NULL)
		talloc_free(msg->payload);
}

uint8_t msmcomm_event_power_state_get_state(struct msmcomm_message *msg)
{
	if (msg->payload == NULL) 
		return 0x0;
		
	return MESSAGE_CAST(msg, struct power_state_event)->power_state;	
}

