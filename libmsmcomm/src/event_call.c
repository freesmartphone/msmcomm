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
 * Call status events
 */

unsigned int event_call_status_is_valid(struct msmcomm_message *msg)
{
    return msg->group_id == 0x2;
}

void event_call_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct call_status_event))
        return;

    msg->payload = data;
}

void event_call_status_free(struct msmcomm_message *msg)
{
}

unsigned int event_call_status_get_type(struct msmcomm_message *msg)
{
    switch (msg->msg_id)
    {
        case 0x00:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIGINATION;
        case 0x01:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ANSWER;
        case 0x02:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END_REQ;
        case 0x03:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END;
        case 0x04:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SUPS;
        case 0x05:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INCOMMING;
        case 0x06:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECT;
        case 0x07:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SRV_OPT;
        case 0x08:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PRIVACY;
        case 0x09:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PRIVACY_PREF;
        case 0x0a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALLER_ID;
        case 0x0b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_ALTER;
        case 0x0c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_REORDER;
        case 0x0d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_INTERCEPT;
        case 0x0e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SIGNAL;
        case 0x0f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_DISPLAY;
        case 0x10:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALLED_PARTY;
        case 0x11:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECTED_NUM;
        case 0x12:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INFO;
        case 0x13:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXT_DISP;
        case 0x14:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NDSS_START;
        case 0x15:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NDSS_CONNECT;
        case 0x16:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXT_BRST_INTL;
        case 0x17:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_CLIR_REC;
        case 0x18:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_REL_REC;
        case 0x19:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_AUD_CTRL;
        case 0x1a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_L2ACK_CALL_HOLD;
        case 0x1b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SETUP_IND;
        case 0x1c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SETUP_RES;
        case 0x1d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_CONF;
        case 0x1e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_ACTIVATE_IND;
        case 0x1f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_ACTIVATE_RES;
        case 0x20:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_REQ;
        case 0x21:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_IND;
        case 0x22:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_REJ;
        case 0x23:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_CONF;
        case 0x24:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REL_IND;
        case 0x25:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_IND;
        case 0x26:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_REQ;
        case 0x27:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_CONF;
        case 0x28:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_REJ;
        case 0x29:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_FAIL;
        case 0x2a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_DATA_AVAILABLE;
        case 0x2b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MNG_CALLS_CONF;
        case 0x2c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_BARRED;
        case 0x2d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_IS_WAITING;
        case 0x2e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_ON_HOLD;
        case 0x2f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_RETRIEVED;
        case 0x30:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIG_FWD_STATUS;
        case 0x31:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_FORWARDED;
        case 0x32:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_BEING_FORWARDED;
        case 0x33:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INCOM_FWD_CALL;
        case 0x34:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_RESTRICTED;
        case 0x35:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CUG_INFO_RECEIVED;
        case 0x36:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CNAP_INFO_RECEIVED;
        case 0x37:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EMERGENCY_FLASHED;
        case 0x38:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PROGRESS_INFO_IND;
        case 0x39:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_DEFLECTION;
        case 0x3a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_TRANSFERRED_CALL;
        case 0x3b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXIT_TC;
        case 0x3c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_REDIRECTING_NUMBER;
        case 0x3d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_PROMOTE_IND;
        case 0x3e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_UMTS_CDMA_HANDOVER_START;
        case 0x3f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_UMTS_CDMA_HANDOVER_END;
        case 0x40:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SECONDARY_MSM;
        case 0x41:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIG_MOD_TO_SS;
        case 0x42:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_USER_DATA_IND;
        case 0x43:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_USER_DATA_CONG_IND;
        case 0x44:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_IND;
        case 0x45:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_REQ;
        case 0x46:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_LINE_CTRL;
        case 0x47:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_ALLOWED;
        case 0x48:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ACT_CCBS_CNF;
        case 0x49:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_RECALL_IND;
        case 0x4a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_RECALL_RSP;
        case 0x4b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_ORIG_THR;
        case 0x4c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VS_AVAIL;
        case 0x4d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VS_NOT_AVAIL;
        case 0x4e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_COMPLETE_CONF;
        case 0x4f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_RES;
        case 0x50:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECT_ORDER_ACK;
        case 0x51:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_TUNNEL_MSG;
        case 0x52:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END_VOIP_CALL;
        case 0x53:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VOIP_CALL_END_CNF;
        case 0x54:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_REQ;
        case 0x55:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_CNF;
        case 0x56:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_IND;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_TYPE_INVALID;
}

uint8_t msmcomm_event_call_status_get_call_id(struct msmcomm_message * msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->call_id;
}

unsigned int msmcomm_event_call_status_get_call_type(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct call_status_event)->call_type)
    {
		case 0x2:
			return MSMCOMM_CALL_TYPE_AUDIO;
		case 0x1:
			return MSMCOMM_CALL_TYPE_DATA;
	}
	
	return MSMCOMM_CALL_TYPE_NONE;
}

char *msmcomm_event_call_status_get_caller_id(struct msmcomm_message *msg)
{
    char *tmp;

    int len = 0;

    if (msg->payload == NULL)
        return NULL;

    len = MESSAGE_CAST(msg, struct call_status_event)->caller_id_len;
    tmp = (char *)malloc(len + 1);
    memcpy(tmp, MESSAGE_CAST(msg, struct call_status_event)->caller_id, len);

    tmp[len] = 0;
    return tmp;
}

uint8_t msmcomm_event_call_status_get_reject_type(struct msmcomm_message * msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->reject_type;
}

uint8_t msmcomm_event_call_status_get_reject_value(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct call_status_event)->reject_value;
}

unsigned int msmcomm_event_call_status_get_cause_value(struct msmcomm_message *msg)
{
    uint8_t value = 0xff;

    if (MESSAGE_CAST(msg, struct call_status_event)->cause_value0 == 0)
        return MESSAGE_CAST(msg, struct call_status_event)->cause_value1;

    if (MESSAGE_CAST(msg, struct call_status_event)->cause_value2 == 0)
        return MESSAGE_CAST(msg, struct call_status_event)->cause_value2;

    if (MESSAGE_CAST(msg, struct call_status_event)->reject_type == 0x3)
        value = 0xe1;


    return 0;
}
