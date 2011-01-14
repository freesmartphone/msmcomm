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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_OPERATION_MODE
 */

unsigned int event_operator_mode_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x5);
}

void event_operator_mode_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct cm_ph_event))
        return;

    msg->payload = data;
}

uint32_t event_operator_mode_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct cm_ph_event);
}

unsigned int event_cm_ph_get_type(struct msmcomm_message *msg)
{
    switch (msg->msg_id)
    {
        case 0x00:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_OPRT_MODE;
        case 0x01:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_TEST_CONTROL_TYPE;
        case 0x02:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SYS_SEL_PREF;
        case 0x03:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_ANSWER_VOICE;
        case 0x04:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_NAM_SEL;
        case 0x05:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CURR_NAM;
        case 0x06:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_IN_USE_STATE;
        case 0x07:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CDMA_LOCK_MODE;
        case 0x08:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_UZ_CHANGED;
        case 0x09:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_MAINTREQ;
        case 0x0a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_STANDBY_SLEEP;
        case 0x0b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_STANDBY_WAKE;
        case 0x0c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO;
        case 0x0d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PACKET_STATE;
        case 0x0e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO_AVAIL;
        case 0x0f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_AVAILABLE;
        case 0x10:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_NOT_AVAILABLE;
        case 0x11:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_CHANGED;
        case 0x12:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_AVAILABLE_NETWORKS_CONF;
        case 0x13:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PREFERRED_NETWORKS_CONF;
        case 0x14:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_FUNDS_LOW;
        case 0x15:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_WAKEUP_FROM_STANDBY;
        case 0x16:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_NVRUIM_CONFIG_CHANGED;
        case 0x17:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PREFERRED_NETWORKS_SET;
        case 0x18:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_DDTM_PREF;
        case 0x19:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PS_ATTACH_FAILED;
        case 0x1a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_RESET_ACM_COMPLETED;
        case 0x1b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SET_ACMMAX_COMPLETED;
        case 0x1c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CDMA_CAPABILITY_UPDATED;
        case 0x1d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_LINE_SWITCHING;
        case 0x1e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SELECTED_LINE;
        case 0x1f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SECONDARY_MSM;
        case 0x20:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_TERMINATE_GET_NETWORKS;
        case 0x21:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_DDTM_STATUS;
        case 0x22:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CCBS_STORE_INFO_CHANGED;
        case 0x23:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_EVENT_UNFORCE_ORIG_COMPLETE;
        case 0x24:
            return MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SEND_MANUAL_NET_SELECTN;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_TYPE_INVALID;
}
