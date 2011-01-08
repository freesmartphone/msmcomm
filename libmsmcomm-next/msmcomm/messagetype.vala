/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm.LowLevel
{
    public enum MessageType
    {
        INVALID,
        COMMAND_CALL_ORIGINATION,
        COMMAND_CALL_ANSWER,
        COMMAND_CALL_END,
        COMMAND_CALL_SUPS,

        COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST,

        COMMAND_MISC_TEST_ALIVE,
        COMMAND_MISC_GET_RADIO_FIRMWARE_VERSION,
        COMMAND_MISC_GET_CHARGER_STATUS,
        COMMAND_MISC_SET_CHARGE,
        COMMAND_MISC_SET_DATE,
        COMMAND_MISC_GET_IMEI,

        RESPONSE_CALL_CALLBACK,
        RESPONSE_CALL_RETURN,

        RESPONSE_STATE_CALLBACK,

        RESPONSE_MISC_TEST_ALIVE,
        RESPONSE_MISC_GET_RADIO_FIRMWARE_VERSION,
        RESPONSE_MISC_GET_CHARGER_STATUS,
        RESPONSE_MISC_SET_CHARGE,
        RESPONSE_MISC_SET_DATE,
        RESPONSE_MISC_GET_IMEI,

        UNSOLICITED_RESPONSE_STATE_OPRT_MODE,
        UNSOLICITED_RESPONSE_STATE_TEST_CONTROL_TYPE,
        UNSOLICITED_RESPONSE_STATE_SYS_SEL_PREF,
        UNSOLICITED_RESPONSE_STATE_ANSWER_VOICE,
        UNSOLICITED_RESPONSE_STATE_NAM_SEL,
        UNSOLICITED_RESPONSE_STATE_CURR_NAM,
        UNSOLICITED_RESPONSE_STATE_IN_USE_STATE,
        UNSOLICITED_RESPONSE_STATE_CDMA_LOCK_MODE,
        UNSOLICITED_RESPONSE_STATE_UZ_CHANGED,
        UNSOLICITED_RESPONSE_STATE_MAINTREQ,
        UNSOLICITED_RESPONSE_STATE_STANDBY_SLEEP,
        UNSOLICITED_RESPONSE_STATE_STANDBY_WAKE,
        UNSOLICITED_RESPONSE_STATE_INFO,
        UNSOLICITED_RESPONSE_STATE_PACKET_STATE,
        UNSOLICITED_RESPONSE_STATE_INFO_AVAIL,
        UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_AVAILABLE,
        UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_NOT_AVAILABLE,
        UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_CHANGED,
        UNSOLICITED_RESPONSE_STATE_AVAILABLE_NETWORKS_CONF,
        UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_CONF,
        UNSOLICITED_RESPONSE_STATE_FUNDS_LOW,
        UNSOLICITED_RESPONSE_STATE_WAKEUP_FROM_STANDBY,
        UNSOLICITED_RESPONSE_STATE_NVRUIM_CONFIG_CHANGED,
        UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_SET,
        UNSOLICITED_RESPONSE_STATE_DDTM_PREF,
        UNSOLICITED_RESPONSE_STATE_PS_ATTACH_FAILED,
        UNSOLICITED_RESPONSE_STATE_RESET_ACM_COMPLETED,
        UNSOLICITED_RESPONSE_STATE_SET_ACMMAX_COMPLETED,
        UNSOLICITED_RESPONSE_STATE_CDMA_CAPABILITY_UPDATED,
        UNSOLICITED_RESPONSE_STATE_LINE_SWITCHING,
        UNSOLICITED_RESPONSE_STATE_SELECTED_LINE,
        UNSOLICITED_RESPONSE_STATE_SECONDARY_MSM,
        UNSOLICITED_RESPONSE_STATE_TERMINATE_GET_NETWORKS,
        UNSOLICITED_RESPONSE_STATE_DDTM_STATUS,
        UNSOLICITED_RESPONSE_STATE_CCBS_STORE_INFO_CHANGED,
        UNSOLICITED_RESPONSE_STATE_EVENT_UNFORCE_ORIG_COMPLETE,
        UNSOLICITED_RESPONSE_STATE_SEND_MANUAL_NET_SELECTN,

        UNSOLICITED_RESPONSE_MISC_RADIO_RESET_IND,
        UNSOLICITED_RESPONSE_MISC_CHARGER_STATUS,
    }

    public string messageTypeToString(MessageType type)
    {
        string result = "UNKNOWN";

        switch (type)
        {
            case MessageType.INVALID:
                result = "INVALID";
                break;
            case MessageType.COMMAND_CALL_ORIGINATION:
                result = "COMMAND_CALL_ORIGINATION";
                break;
            case MessageType.COMMAND_CALL_ANSWER:
                result = "COMMAND_CALL_ANSWER";
                break;
            case MessageType.COMMAND_CALL_END:
                result = "COMMAND_CALL_END";
                break;
            case MessageType.COMMAND_CALL_SUPS:
                result = "COMMAND_CALL_SUPS";
                break;

            case MessageType.COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST:
                result = "COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST";
                break;

            case MessageType.COMMAND_MISC_TEST_ALIVE:
                result = "COMMAND_MISC_TEST_ALIVE";
                break;
            case MessageType.COMMAND_MISC_GET_RADIO_FIRMWARE_VERSION:
                result = "COMMAND_MISC_GET_RADIO_FIRMWARE_VERSION";
                break;
            case MessageType.COMMAND_MISC_GET_CHARGER_STATUS:
                result = "COMMAND_MISC_GET_CHARGER_STATUS";
                break;
            case MessageType.COMMAND_MISC_SET_CHARGE:
                result = "COMMAND_MISC_SET_CHARGE";
                break;
            case MessageType.COMMAND_MISC_SET_DATE:
                result = "COMMAND_MISC_SET_DATE";
                break;
            case MessageType.COMMAND_MISC_GET_IMEI:
                result = "COMMAND_MISC_GET_IMEI";
                break;

            case MessageType.RESPONSE_CALL_CALLBACK:
                result = "RESPONSE_CALL_CALLBACK";
                break;
            case MessageType.RESPONSE_CALL_RETURN:
                result = "RESPONSE_CALL_RETURN";
                break;

            case MessageType.RESPONSE_STATE_CALLBACK:
                result = "RESPONSE_STATE_CALLBACK";
                break;

            case MessageType.RESPONSE_MISC_TEST_ALIVE:
                result = "RESPONSE_MISC_TEST_ALIVE";
                break;
            case MessageType.RESPONSE_MISC_GET_RADIO_FIRMWARE_VERSION:
                result = "RESPONSE_MISC_GET_RADIO_FIRMWARE_VERSION";
                break;
            case MessageType.RESPONSE_MISC_GET_CHARGER_STATUS:
                result = "RESPONSE_MISC_GET_CHARGER_STATUS";
                break;
            case MessageType.RESPONSE_MISC_SET_CHARGE:
                result = "RESPONSE_MISC_SET_CHARGE";
                break;
            case MessageType.RESPONSE_MISC_SET_DATE:
                result = "RESPONSE_MISC_SET_DATE";
                break;
            case MessageType.RESPONSE_MISC_GET_IMEI:
                result = "RESPONSE_MISC_GET_IMEI";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_OPRT_MODE:
                result = "UNSOLICITED_RESPONSE_STATE_OPRT_MODE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_TEST_CONTROL_TYPE:
                result = "UNSOLICITED_RESPONSE_STATE_TEST_CONTROL_TYPE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SYS_SEL_PREF:
                result = "UNSOLICITED_RESPONSE_STATE_SYS_SEL_PREF";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_ANSWER_VOICE:
                result = "UNSOLICITED_RESPONSE_STATE_ANSWER_VOICE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_NAM_SEL:
                result = "UNSOLICITED_RESPONSE_STATE_NAM_SEL";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_CURR_NAM:
                result = "UNSOLICITED_RESPONSE_STATE_CURR_NAM";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_IN_USE_STATE:
                result = "UNSOLICITED_RESPONSE_STATE_IN_USE_STATE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_CDMA_LOCK_MODE:
                result = "UNSOLICITED_RESPONSE_STATE_CDMA_LOCK_MODE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_UZ_CHANGED:
                result = "UNSOLICITED_RESPONSE_STATE_UZ_CHANGED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_MAINTREQ:
                result = "UNSOLICITED_RESPONSE_STATE_MAINTREQ";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_STANDBY_SLEEP:
                result = "UNSOLICITED_RESPONSE_STATE_STANDBY_SLEEP";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_STANDBY_WAKE:
                result = "UNSOLICITED_RESPONSE_STATE_STANDBY_WAKE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_INFO:
                result = "UNSOLICITED_RESPONSE_STATE_INFO";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_PACKET_STATE:
                result = "UNSOLICITED_RESPONSE_STATE_PACKET_STATE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_INFO_AVAIL:
                result = "UNSOLICITED_RESPONSE_STATE_INFO_AVAIL";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_AVAILABLE:
                result = "UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_AVAILABLE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_NOT_AVAILABLE:
                result = "UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_NOT_AVAILABLE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_CHANGED:
                result = "UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_CHANGED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_AVAILABLE_NETWORKS_CONF:
                result = "UNSOLICITED_RESPONSE_STATE_AVAILABLE_NETWORKS_CONF";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_CONF:
                result = "UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_CONF";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_FUNDS_LOW:
                result = "UNSOLICITED_RESPONSE_STATE_FUNDS_LOW";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_WAKEUP_FROM_STANDBY:
                result = "UNSOLICITED_RESPONSE_STATE_WAKEUP_FROM_STANDBY";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_NVRUIM_CONFIG_CHANGED:
                result = "UNSOLICITED_RESPONSE_STATE_NVRUIM_CONFIG_CHANGED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_SET:
                result = "UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_SET";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_DDTM_PREF:
                result = "UNSOLICITED_RESPONSE_STATE_DDTM_PREF";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_PS_ATTACH_FAILED:
                result = "UNSOLICITED_RESPONSE_STATE_PS_ATTACH_FAILED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_RESET_ACM_COMPLETED:
                result = "UNSOLICITED_RESPONSE_STATE_RESET_ACM_COMPLETED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SET_ACMMAX_COMPLETED:
                result = "UNSOLICITED_RESPONSE_STATE_SET_ACMMAX_COMPLETED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_CDMA_CAPABILITY_UPDATED:
                result = "UNSOLICITED_RESPONSE_STATE_CDMA_CAPABILITY_UPDATED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_LINE_SWITCHING:
                result = "UNSOLICITED_RESPONSE_STATE_LINE_SWITCHING";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SELECTED_LINE:
                result = "UNSOLICITED_RESPONSE_STATE_SELECTED_LINE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SECONDARY_MSM:
                result = "UNSOLICITED_RESPONSE_STATE_SECONDARY_MSM";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_TERMINATE_GET_NETWORKS:
                result = "UNSOLICITED_RESPONSE_STATE_TERMINATE_GET_NETWORKS";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_DDTM_STATUS:
                result = "UNSOLICITED_RESPONSE_STATE_DDTM_STATUS";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_CCBS_STORE_INFO_CHANGED:
                result = "UNSOLICITED_RESPONSE_STATE_CCBS_STORE_INFO_CHANGED";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_EVENT_UNFORCE_ORIG_COMPLETE:
                result = "UNSOLICITED_RESPONSE_STATE_EVENT_UNFORCE_ORIG_COMPLETE";
                break;
            case MessageType.UNSOLICITED_RESPONSE_STATE_SEND_MANUAL_NET_SELECTN:
                result = "UNSOLICITED_RESPONSE_STATE_SEND_MANUAL_NET_SELECTN";
                break;

            case MessageType.UNSOLICITED_RESPONSE_MISC_RADIO_RESET_IND:
                result = "UNSOLICITED_RESPONSE_MISC_RADIO_RESET_IND";
                break;
            case MessageType.UNSOLICITED_RESPONSE_MISC_CHARGER_STATUS:
                result = "UNSOLICITED_RESPONSE_MISC_CHARGER_STATUS";
                break;
        }

        return result;
    }
}

