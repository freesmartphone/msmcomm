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
        COMMAND_STATE_SYS_SEL_PREF,

        COMMAND_MISC_TEST_ALIVE,
        COMMAND_MISC_GET_RADIO_FIRMWARE_VERSION,
        COMMAND_MISC_GET_CHARGER_STATUS,
        COMMAND_MISC_SET_CHARGE,
        COMMAND_MISC_SET_DATE,
        COMMAND_MISC_GET_IMEI,
        COMMAND_MISC_GET_HOME_NETWORK_NAME,

        COMMAND_SIM_VERIFY_PIN,
        COMMAND_SIM_ENABLE_PIN,
        COMMAND_SIM_DISABLE_PIN,
        COMMAND_SIM_CHANGE_PIN,
        COMMAND_SIM_GET_SIM_CAPABILITIES,
        COMMAND_SIM_GET_ALL_PIN_STATUS_INFO,
        COMMAND_SIM_READ,
        COMMAND_SIM_GET_CALL_FORWARD_INFO,

        COMMAND_PHONEBOOK_READ_RECORD,
        COMMAND_PHONEBOOK_READ_RECORD_BULK,
        COMMAND_PHONEBOOK_WRITE_RECORD,
        COMMAND_PHONEBOOK_GET_ALL_RECORD_ID,
        COMMAND_PHONEBOOK_EXTENDED_FILE_INFO,

        COMMAND_NETWORK_REPORT_RSSI,
        COMMAND_NETWORK_REPORT_NETWORK_HEALTH,

        COMMAND_SOUND_SET_DEVICE,

        COMMAND_SMS_READ_MESSAGE,
        COMMAND_SMS_SEND_MESSAGE,
        COMMAND_SMS_DELETE_MESSAGE,
        COMMAND_SMS_WRITE_MESSAGE,
        COMMAND_SMS_ACKNOWLDGE_MESSAGE,
        COMMAND_SMS_MESSAGE_READ_TEMPLATE,

        COMMAND_VOICEMAIL_GET_INFO,

        RESPONSE_CALL_CALLBACK,
        RESPONSE_CALL_RETURN,

        RESPONSE_STATE_CALLBACK,

        RESPONSE_MISC_TEST_ALIVE,
        RESPONSE_MISC_GET_RADIO_FIRMWARE_VERSION,
        RESPONSE_MISC_GET_CHARGER_STATUS,
        RESPONSE_MISC_SET_CHARGE,
        RESPONSE_MISC_SET_DATE,
        RESPONSE_MISC_GET_IMEI,
        RESPONSE_MISC_GET_HOME_NETWORK_NAME,

        RESPONSE_SIM_RETURN,
        RESPONSE_SIM_CALLBACK,

        RESPONSE_PHONEBOOK_RETURN,

        RESPONSE_NETWORK_CALLBACK,

        RESPONSE_SOUND_CALLBACK,

        RESPONSE_SMS_RETURN,
        RESPONSE_SMS_CALLBACK,

        RESPONSE_SUPS_CALLBACK,

        RESPONSE_VOICEMAIL_RETURN,

        UNSOLICITED_RESPONSE_CALL_ORIG,
        UNSOLICITED_RESPONSE_CALL_ANSWER,
        UNSOLICITED_RESPONSE_CALL_END_REQ,
        UNSOLICITED_RESPONSE_CALL_END,
        UNSOLICITED_RESPONSE_CALL_SUPS,
        UNSOLICITED_RESPONSE_CALL_INCOM,
        UNSOLICITED_RESPONSE_CALL_CONNECT,
        UNSOLICITED_RESPONSE_CALL_SRV_OPT,
        UNSOLICITED_RESPONSE_CALL_PRIVACY,
        UNSOLICITED_RESPONSE_CALL_PRIVACY_PREF,
        UNSOLICITED_RESPONSE_CALL_CALLER_ID,
        UNSOLICITED_RESPONSE_CALL_ABRV_ALERT,
        UNSOLICITED_RESPONSE_CALL_ABRV_REORDER,
        UNSOLICITED_RESPONSE_CALL_ABRV_INTERCEPT,
        UNSOLICITED_RESPONSE_CALL_SIGNAL,
        UNSOLICITED_RESPONSE_CALL_DISPLAY,
        UNSOLICITED_RESPONSE_CALL_CALLED_PARTY,
        UNSOLICITED_RESPONSE_CALL_CONNECTED_NUM,
        UNSOLICITED_RESPONSE_CALL_INFO,
        UNSOLICITED_RESPONSE_CALL_EXT_DISP,
        UNSOLICITED_RESPONSE_CALL_NDSS_START,
        UNSOLICITED_RESPONSE_CALL_NDSS_CONNECT,
        UNSOLICITED_RESPONSE_CALL_EXT_BRST_INTL,
        UNSOLICITED_RESPONSE_CALL_NSS_CLIR_REC,
        UNSOLICITED_RESPONSE_CALL_NSS_REL_REC,
        UNSOLICITED_RESPONSE_CALL_NSS_AUD_CTRL,
        UNSOLICITED_RESPONSE_CALL_L2ACK_CALL_HOLD,
        UNSOLICITED_RESPONSE_CALL_SETUP_IND,
        UNSOLICITED_RESPONSE_CALL_SETUP_RES,
        UNSOLICITED_RESPONSE_CALL_CALL_CONF,
        UNSOLICITED_RESPONSE_CALL_PDP_ACTIVATE_IND,
        UNSOLICITED_RESPONSE_CALL_PDP_ACTIVATE_RES,
        UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_REQ,
        UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_IND,
        UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_REJ,
        UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_CONF,
        UNSOLICITED_RESPONSE_CALL_RAB_REL_IND,
        UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_IND,
        UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_REQ,
        UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_CONF,
        UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_REJ,
        UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_FAIL,
        UNSOLICITED_RESPONSE_CALL_PS_DATA_AVAILABLE,
        UNSOLICITED_RESPONSE_CALL_MNG_CALLS_CONF,
        UNSOLICITED_RESPONSE_CALL_CALL_BARRED,
        UNSOLICITED_RESPONSE_CALL_CALL_IS_WAITING,
        UNSOLICITED_RESPONSE_CALL_CALL_ON_HOLD,
        UNSOLICITED_RESPONSE_CALL_CALL_RETRIEVED,
        UNSOLICITED_RESPONSE_CALL_ORIG_FWD_STATUS,
        UNSOLICITED_RESPONSE_CALL_CALL_FORWARDED,
        UNSOLICITED_RESPONSE_CALL_CALL_BEING_FORWARDED,
        UNSOLICITED_RESPONSE_CALL_INCOM_FWD_CALL,
        UNSOLICITED_RESPONSE_CALL_CALL_RESTRICTED,
        UNSOLICITED_RESPONSE_CALL_CUG_INFO_RECEIVED,
        UNSOLICITED_RESPONSE_CALL_CNAP_INFO_RECEIVED,
        UNSOLICITED_RESPONSE_CALL_EMERGENCY_FLASHED,
        UNSOLICITED_RESPONSE_CALL_PROGRESS_INFO_IND,
        UNSOLICITED_RESPONSE_CALL_CALL_DEFLECTION,
        UNSOLICITED_RESPONSE_CALL_TRANSFERRED_CALL,
        UNSOLICITED_RESPONSE_CALL_EXIT_TC,
        UNSOLICITED_RESPONSE_CALL_REDIRECTING_NUMBER,
        UNSOLICITED_RESPONSE_CALL_PDP_PROMOTE_IND,
        UNSOLICITED_RESPONSE_CALL_UMTS_CDMA_HANDOVER_START,
        UNSOLICITED_RESPONSE_CALL_UMTS_CDMA_HANDOVER_END,
        UNSOLICITED_RESPONSE_CALL_SECONDARY_MSM,
        UNSOLICITED_RESPONSE_CALL_ORIG_MOD_TO_SS,
        UNSOLICITED_RESPONSE_CALL_USER_DATA_IND,
        UNSOLICITED_RESPONSE_CALL_USER_DATA_CONG_IND,
        UNSOLICITED_RESPONSE_CALL_MODIFY_IND,
        UNSOLICITED_RESPONSE_CALL_MODIFY_REQ,
        UNSOLICITED_RESPONSE_CALL_LINE_CTRL,
        UNSOLICITED_RESPONSE_CALL_CCBS_ALLOWED,
        UNSOLICITED_RESPONSE_CALL_ACT_CCBS_CNF,
        UNSOLICITED_RESPONSE_CALL_CCBS_RECALL_IND,
        UNSOLICITED_RESPONSE_CALL_CCBS_RECALL_RSP,
        UNSOLICITED_RESPONSE_CALL_CALL_ORIG_THR,
        UNSOLICITED_RESPONSE_CALL_VS_AVAIL,
        UNSOLICITED_RESPONSE_CALL_VS_NOT_AVAIL,
        UNSOLICITED_RESPONSE_CALL_MODIFY_COMPLETE_CONF,
        UNSOLICITED_RESPONSE_CALL_MODIFY_RES,
        UNSOLICITED_RESPONSE_CALL_CONNECT_ORDER_ACK,
        UNSOLICITED_RESPONSE_CALL_TUNNEL_MSG,
        UNSOLICITED_RESPONSE_CALL_END_VOIP_CALL,
        UNSOLICITED_RESPONSE_CALL_VOIP_CALL_END_CNF,
        UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_REQ,
        UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_CNF,
        UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_IND,

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

        UNSOLICITED_RESPONSE_SIM_SIM_INSERTED,
        UNSOLICITED_RESPONSE_SIM_SIM_REMOVED,
        UNSOLICITED_RESPONSE_SIM_DRIVER_ERROR,
        UNSOLICITED_RESPONSE_SIM_CARD_ERROR,
        UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING,
        UNSOLICITED_RESPONSE_SIM_NO_SIM_EVENT,
        UNSOLICITED_RESPONSE_SIM_NO_SIM,
        UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED,
        UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_NO_PROV,
        UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED,
        UNSOLICITED_RESPONSE_SIM_PIN1_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED,
        UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED,
        UNSOLICITED_RESPONSE_SIM_PIN1_CHANGED,
        UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PIN2_VERIFIED,
        UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED,
        UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED,
        UNSOLICITED_RESPONSE_SIM_PIN2_CHANGED,
        UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_NO_EVENT,
        UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL,
        UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT,
        UNSOLICITED_RESPONSE_SIM_FDN_ENABLE,
        UNSOLICITED_RESPONSE_SIM_FDN_DISABLE,
        UNSOLICITED_RESPONSE_SIM_SIM_INSERTED_2,
        UNSOLICITED_RESPONSE_SIM_SIM_REMOVED_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERROR_2,
        UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING_2,
        UNSOLICITED_RESPONSE_SIM_NO_SIM_EVENT_2,
        UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_2,
        UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_NO_PROV_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_BLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_CHANGED_2,
        UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_VERIFIED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_CHANGED_2,
        UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_2,
        UNSOLICITED_RESPONSE_SIM_FDN_ENABLE_2,
        UNSOLICITED_RESPONSE_SIM_FDN_DISABLE_2,
        UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL_2,
        UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN,
        UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_FCN,
        UNSOLICITED_RESPONSE_SIM_REFRESH_FCN_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_FAILED,
        UNSOLICITED_RESPONSE_SIM_START_SWITCH_SLOT,
        UNSOLICITED_RESPONSE_SIM_FINISH_SWITCH_SLOT,
        UNSOLICITED_RESPONSE_SIM_PERSO_INIT_COMPLETED,
        UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP1,
        UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL,
        UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL_2,
        UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V2_COMPLETE,
        UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V1_COMPLETE,
        UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP2,
        UNSOLICITED_RESPONSE_SIM_INTERNAL_SIM_RESET,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE_2,
        UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET,
        UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET,
        UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET_2,
        UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET_2,
        UNSOLICITED_RESPONSE_SIM_APP_SELECTED,
        UNSOLICITED_RESPONSE_SIM_APP_SELECTED_2,
        UNSOLICITED_RESPONSE_SIM_PERSO_NW_FAILURE,
        UNSOLICITED_RESPONSE_SIM_PERSO_NS_FAILURE,
        UNSOLICITED_RESPONSE_SIM_PERSO_SP_FAILURE,
        UNSOLICITED_RESPONSE_SIM_PERSO_CP_FAILURE,
        UNSOLICITED_RESPONSE_SIM_PERSO_SIM_FAILURE,
        UNSOLICITED_RESPONSE_SIM_PERSO_NW_DEACTIVATED,
        UNSOLICITED_RESPONSE_SIM_PERSO_NS_DEACTIVATED,
        UNSOLICITED_RESPONSE_SIM_PERSO_SP_DEACTIVATED,
        UNSOLICITED_RESPONSE_SIM_PERSO_CP_DEACTIVATED,
        UNSOLICITED_RESPONSE_SIM_PERSO_SIM_DEACTIVATED,
        UNSOLICITED_RESPONSE_SIM_PERSO_NCK_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_NSK_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_SPK_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_CCK_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_PPK_BLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_NCK_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_NSK_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_SPK_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_CCK_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_PPK_UNBLOCKED,
        UNSOLICITED_RESPONSE_SIM_PERSO_SANITY_ERROR,
        UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP1,
        UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP2,
        UNSOLICITED_RESPONSE_SIM_PERSO_EVT_INIT_COMPLETED,
        UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_ENABLE,
        UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_DISABLE,

        UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_ADDED,
        UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_UPDATED,
        UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_DELETED,
        UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_FAILED,
        UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_START,
        UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_DONE,
        UNSOLICITED_RESPONSE_PHONEBOOK_PHONEBOOK_READY,
        UNSOLICITED_RESPONSE_PHONEBOOK_LOCKED,
        UNSOLICITED_RESPONSE_PHONEBOOK_UNLOCKED,
        UNSOLICITED_RESPONSE_PHONEBOOK_PH_UNIQUE_IDS_VALIDATED,
        UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_WRITE,
        UNSOLICITED_RESPONSE_PHONEBOOK_GET_ALL_RECORD_ID,
        UNSOLICITED_RESPONSE_PHONEBOOK_EXTENDED_FILE_INFO,

        UNSOLICITED_RESPONSE_NETWORK_NETWORK_HEALTH,
        UNSOLICITED_RESPONSE_NETWORK_SRV_CHANGED,
        UNSOLICITED_RESPONSE_NETWORK_RSSI,
        UNSOLICITED_RESPONSE_NETWORK_INFO,
        UNSOLICITED_RESPONSE_NETWORK_REG_SUCCESS,
        UNSOLICITED_RESPONSE_NETWORK_REG_FAILURE,
        UNSOLICITED_RESPONSE_NETWORK_HDR_RSSI,
        UNSOLICITED_RESPONSE_NETWORK_WLAN_RSSI,
        UNSOLICITED_RESPONSE_NETWORK_SRV_NEW,
        UNSOLICITED_RESPONSE_NETWORK_SECONDARY_MSM,
        UNSOLICITED_RESPONSE_NETWORK_PS_DATA_AVAIL,
        UNSOLICITED_RESPONSE_NETWORK_PS_DATA_FAIL,
        UNSOLICITED_RESPONSE_NETWORK_PS_DATA_SUCCESS,
        UNSOLICITED_RESPONSE_NETWORK_WLAN_STATS,
        UNSOLICITED_RESPONSE_NETWORK_ORIG_THR_TBL_UPDATE,
        UNSOLICITED_RESPONSE_NETWORK_EMERG_NUM_LIST,
        UNSOLICITED_RESPONSE_NETWORK_IPAPP_REG_STATUS,
        UNSOLICITED_RESPONSE_NETWORK_NO_TIME_RCVD_FROM_NETWORK,
        UNSOLICITED_RESPONSE_NETWORK_REG_REJECT,

        UNSOLICITED_RESPONSE_VOICEMAIL,

        UNSOLICITED_RESPONSE_SMS_MSG_GROUP,
    }
}
