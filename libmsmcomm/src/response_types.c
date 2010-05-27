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

#define NEW_TYPE(type, name) \
	extern unsigned int type##_##name##_is_valid(struct msmcomm_message *msg); \
	extern void type##_##name##_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len); \
	extern uint32_t type##_##name##_get_size(struct msmcomm_message *msg); 
	
#define RESPONSE_TYPE(name) NEW_TYPE(resp, name)
#define EVENT_TYPE(name) NEW_TYPE(event, name)

#define GROUP_TYPE(name) \
	NEW_TYPE(group, name) \
	extern unsigned int group_##name##_get_type(struct msmcomm_message *msg);

#define TYPE_DATA(type, subtype, name) \
	{	subtype, \
		type##_##name##_get_size, \
		NULL, NULL, NULL, \ 
		type##_##name##_handle_data, \
		type##_##name##_is_valid, \
		NULL \
		}

#define GROUP_DATA(name) \
	{	MSMCOMM_MESSAGE_INVALID, \
		NULL, NULL, NULL, NULL, \
		group_##name##_handle_data, \
		group_##name##_is_valid, \
		group_##name##_get_type }

#define EVENT_DATA(type, name) TYPE_DATA(event, type, name)
#define RESPONSE_DATA(type, name) TYPE_DATA(resp, type, name)

RESPONSE_TYPE(get_imei)
RESPONSE_TYPE(get_firmware_info)
RESPONSE_TYPE(test_alive)
/*
RESPONSE_TYPE(pdsm_pd_get_pos)
RESPONSE_TYPE(pdsm_pd_end_session)
RESPONSE_TYPE(pa_set_param)
RESPONSE_TYPE(lcs_agent_client_rsp)
RESPONSE_TYPE(xtra_set_data)
*/
RESPONSE_TYPE(get_sim_capabilities)
RESPONSE_TYPE(sound)
RESPONSE_TYPE(cm_call)
RESPONSE_TYPE(charging)
RESPONSE_TYPE(charger_status)
RESPONSE_TYPE(cm_ph)
RESPONSE_TYPE(set_system_time)

EVENT_TYPE(radio_reset_ind)
EVENT_TYPE(charger_status)
EVENT_TYPE(operator_mode)
EVENT_TYPE(cm_ph_info_available)
/*
EVENT_TYPE(pdsm_pd_done)
EVENT_TYPE(pd_position_data)
EVENT_TYPE(pd_parameter_change)
EVENT_TYPE(pdsm_lcs)
EVENT_TYPE(pdsm_xtra)
*/
EVENT_TYPE(power_state)
EVENT_TYPE(network_state_info)

GROUP_TYPE(sim)
GROUP_TYPE(call)
GROUP_TYPE(sups)

struct descriptor group_descriptors[] = {
	GROUP_DATA(sim),
	GROUP_DATA(call),
	GROUP_DATA(sups),
};


struct descriptor resp_descriptors[] = {
	/* events */
	EVENT_DATA(MSMCOMM_EVENT_RESET_RADIO_IND, radio_reset_ind),
	EVENT_DATA(MSMCOMM_EVENT_CHARGER_STATUS, charger_status),
	EVENT_DATA(MSMCOMM_EVENT_OPERATION_MODE, operator_mode),
	EVENT_DATA(MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE, cm_ph_info_available),
	/*
	EVENT_DATA(MSMCOMM_EVENT_PDSM_PD_DONE, pdsm_pd_done),
	EVENT_DATA(MSMCOMM_EVENT_PD_POSITION_DATA, pd_position_data),
	EVENT_DATA(MSMCOMM_EVENT_PD_PARAMETER_CHANGE, pd_parameter_change),
	EVENT_DATA(MSMCOMM_EVENT_PDSM_LCS, pdsm_lcs),
	EVENT_DATA(MSMCOMM_EVENT_PDSM_XTRA, pdsm_xtra),
	*/
	//EVENT_DATA(MSMCOMM_EVENT_POWER_STATE, power_state),
	EVENT_DATA(MSMCOMM_EVENT_NETWORK_STATE_INFO, network_state_info),

	/* responses */
	RESPONSE_DATA(MSMCOMM_RESPONSE_TEST_ALIVE, test_alive),
	RESPONSE_DATA(MSMCOMM_RESPONSE_GET_FIRMWARE_INFO, get_firmware_info),
	RESPONSE_DATA(MSMCOMM_RESPONSE_GET_IMEI, get_imei),
	/*
	RESPONSE_DATA(MSMCOMM_RESPONSE_PDSM_PD_GET_POS, pdsm_pd_get_pos),
	RESPONSE_DATA(MSMCOMM_RESPONSE_PDSM_PD_END_SESSION, pdsm_pd_end_session),
	RESPONSE_DATA(MSMCOMM_RESPONSE_PA_SET_PARAM, pa_set_param),
	RESPONSE_DATA(MSMCOMM_RESPONSE_LCS_AGENT_CLIENT_RSP, lcs_agent_client_rsp),
	RESPONSE_DATA(MSMCOMM_RESPONSE_XTRA_SET_DATA, xtra_set_data),
	*/
	RESPONSE_DATA(MSMCOMM_RESPONSE_GET_SIM_CAPABILITIES, get_sim_capabilities),
	RESPONSE_DATA(MSMCOMM_RESPONSE_SOUND, sound),
	RESPONSE_DATA(MSMCOMM_RESPONSE_CM_CALL, cm_call),
	RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGING, charging),
	RESPONSE_DATA(MSMCOMM_RESPONSE_CHARGER_STATUS, charger_status),
	RESPONSE_DATA(MSMCOMM_RESPONSE_CM_PH, cm_ph),
	RESPONSE_DATA(MSMCOMM_RESPONSE_SET_SYSTEM_TIME, set_system_time),
};

const unsigned int resp_descriptors_count = sizeof(resp_descriptors)
											/ sizeof(struct descriptor);
const unsigned int group_descriptors_count = sizeof(group_descriptors)
											/ sizeof(struct descriptor);

int handle_response_data(struct msmcomm_context *ctx, uint8_t *data, uint32_t len)
{
	int n;
	struct msmcomm_message resp;

	/* we can already report events to our user? */
	if (ctx->event_cb == NULL)
		return 0;

	/* ensure response len: response should be groupId + msgId + one byte data
	 * as minimum*/
	if (len < 3)
		return 0;
	
	/* NOTE: in some cases (for sim messages) there is also a subsystem id 
	 * included in the message id. We assume that the is_valid handler
	 * of the descritors gets this out of the msgId set in the response
	 * structure.
	 */
	resp.group_id = data[0];
	resp.msg_id = data[1] | (data[2] << 8);
	resp.payload = NULL;
	resp.descriptor = NULL;
	
	/* first we check if we have a group which handle's this response or event */
	for (n=0; n<group_descriptors_count; n++) {
		/* is descriptor valid? */
		if (group_descriptors[n].is_valid == NULL ||
			group_descriptors[n].handle_data == NULL ||
			group_descriptors[n].get_type == NULL)
			continue;

		if (group_descriptors[n].is_valid(&resp)) {
			/* let our descriptor handle the left data */
			group_descriptors[n].handle_data(&resp, data + 3, len - 3);
			
			/* save descriptor for later use */
			resp.descriptor = &group_descriptors[n];

			/* tell the user about the received event/response */
			if (ctx->event_cb)
				ctx->event_cb(ctx, group_descriptors[n].get_type(&resp), &resp);
			
			return 1;
		}
	}

	/* find the right rsp descriptor */
	for (n=0; n<resp_descriptors_count; n++) {
		if (resp_descriptors[n].is_valid == NULL ||
			resp_descriptors[n].handle_data == NULL)
			continue;

		if (resp_descriptors[n].is_valid(&resp)) {
			/* let our descriptor handle the left data */
			resp_descriptors[n].handle_data(&resp, data + 3, len - 3);

			/* save descriptor for later use */
			resp.descriptor = &resp_descriptors[n];

			/* tell the user about the received event/response */
			if (ctx->event_cb)
				ctx->event_cb(ctx->event_data, resp_descriptors[n].type, &resp);

			return 1;
		}
	}

	return 0;
}

