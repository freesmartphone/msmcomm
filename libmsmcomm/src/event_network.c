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
 * MSMCOMM_EVENT_network_state_info
 */

#if 0
struct network_state_info_event
{
	uint8_t change_field[8];
	uint8_t new_value;
	uint8_t unknown1[7];
	uint8_t plmn[3];
	uint8_t unknown2[3];
	uint8_t operator_name_len;
	uint8_t operator_name[80];
	uint8_t unknown3[23];
	uint8_t rssi;
	uint8_t unknown4;
	uint8_t ecio;
	uint8_t unknown10[549];
} __attribute__ ((packed));
#endif

unsigned int event_network_state_info_is_valid(struct msmcomm_message *msg)
{
	/* event network_state_info seems to be have both msgId 0x0 and 0x1 */
	return ((msg->group_id == 0x8) && (msg->msg_id == 0x0 || msg->msg_id == 0x1));
}

void event_network_state_info_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{
	if (len != sizeof(struct network_state_info_event))
		return;

	msg->payload = data;
}

uint32_t msmcomm_event_network_state_info_get_change_field(struct msmcomm_message *msg)
{
	if (msg->payload == NULL) 
		return 0x0;

	return (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[0] <<  0) |
		   (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[1] <<  8) |
		   (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[2] << 16) |
		   (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[3] << 24);
}

#define notify_type_handler(value0, value1, type) \
	if (((field0 & value0) | (field1 & value1))) \
		type_handler(user_data, msg, type);

void msmcomm_event_network_state_info_trace_changes
	(struct msmcomm_message *msg, msmcomm_network_state_info_changed_field_type_cb type_handler, void *user_data)
{
	unsigned long long field0 = 0x0, field1 = 0x0;
	unsigned long long fields = 0x0;

	if (type_handler == NULL)
		return;

	field0 = (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[0] <<  0) |
			 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[1] <<  8) |
		 	 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[2] << 16) |
			 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[3] << 24);

	field1 = (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[4] <<  0) |
			 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[5] <<  8) |
		 	 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[6] << 16) |
			 (MESSAGE_CAST(msg, struct network_state_info_event)->change_field[7] << 24);

	notify_type_handler((0x1 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SID);
	notify_type_handler((0x2 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_NID);
	notify_type_handler((0x4 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_REGISTRATION_ZONE);
	notify_type_handler((0x8 << 0), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PACKET_ZONE);
	notify_type_handler((0x1 << 1), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASESTATION_P_REV);
	notify_type_handler((0x2 << 1), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_P_REV_IN_USE);
	notify_type_handler((0x4 << 1), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_CONCURRENT_SERVICES_SUPPORTED);
	notify_type_handler((0x8 << 1), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVING_STATUS);
	notify_type_handler((0x1 << 2), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVICE_DOMAIN);
	notify_type_handler((0x2 << 2), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_SERVICE_CAPABILITY);
	notify_type_handler((0x4 << 2), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_MODE);
	notify_type_handler((0x8 << 2), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_ROAMING_STATUS);
	notify_type_handler((0x1 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_ID);
	notify_type_handler((0x2 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERICE_INDICATOR);
	notify_type_handler((0x4 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_MOBILITY_MANAGEMENT);
	notify_type_handler((0x8 << 3), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_HDR);
	notify_type_handler((0x1 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SIM_CARD_STATUS);
	notify_type_handler((0x2 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PLMN);
	notify_type_handler((0x4 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PS_DATA_SUSPEND_MASK);
	notify_type_handler((0x8 << 4), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_UZ);
	/* FIXME 0x1 << 5 */
	/* FIXME 0x2 << 5 */
	notify_type_handler((0x4 << 5), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
	notify_type_handler((0x8 << 5), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
	notify_type_handler((0x1 << 6), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS);
	/* 0x2 << 6 is not used */
	notify_type_handler((0x4 << 6), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASE_STATION_PARAMETERS_CHANGED);
	notify_type_handler((0x2 << 7), 0x0, MSMCOMM_NETWORK_STATE_INFO_CHANGED_FILED_TYPE_ORIGINATION_STATUS);
}

void msmcomm_event_network_state_info_get_plmn(struct msmcomm_message *msg, uint8_t *plmn)
{
	if (msg->payload == NULL)
		return;
	plmn[0] = MESSAGE_CAST(msg, struct network_state_info_event)->plmn[0];
	plmn[1] = MESSAGE_CAST(msg, struct network_state_info_event)->plmn[1];
	plmn[2] = MESSAGE_CAST(msg, struct network_state_info_event)->plmn[2];
}

void msmcomm_event_network_state_info_get_operator_name
	(struct msmcomm_message *msg, int8_t *buffer, uint32_t len)
{
	if (msg->payload == NULL)
		return;

	if (len < MESSAGE_CAST(msg, struct network_state_info_event)->operator_name_len)
		return;

	snprintf(buffer, len, "%s", MESSAGE_CAST(msg, struct network_state_info_event)->operator_name);
}

uint16_t msmcomm_event_network_state_info_get_rssi(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->rssi[0] << 8 | 
		   MESSAGE_CAST(msg, struct network_state_info_event)->rssi[1];
}

uint16_t msmcomm_event_network_state_info_get_ecio(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->ecio[0] >> 8 |
		   MESSAGE_CAST(msg, struct network_state_info_event)->ecio[1];
}

uint8_t msmcomm_event_network_state_info_get_new_value(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->new_value == 2 ? 1 : 0;
}

uint8_t msmcomm_event_network_state_info_get_service_domain(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->servce_domain;
}

uint8_t msmcomm_event_network_state_info_get_service_capability(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->service_capability;
}

uint8_t msmcomm_event_network_state_info_get_gprs_attached(struct msmcomm_message *msg)
{
	if (msg->payload, NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->gprs_attached;
}

uint16_t msmcomm_event_network_state_info_get_roam(struct msmcomm_message *msg)
{
	if (msg->payload == NULL)
		return 0x0;

	return MESSAGE_CAST(msg, struct network_state_info_event)->roam[0] >> 8 |
		   MESSAGE_CAST(msg, struct network_state_info_event)->roam[1];
}

void event_network_state_info_free(struct msmcomm_message *msg)
{
}

