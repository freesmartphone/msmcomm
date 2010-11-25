
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

#ifndef MSMCOMM_H_
#define MSMCOMM_H_

#include <stdint.h>

typedef enum
{
	MSMCOMM_MESSAGE_CLASS_NONE,
	MSMCOMM_MESSAGE_CLASS_COMMAND,
	MSMCOMM_MESSAGE_CLASS_RESPONSE,
	MSMCOMM_MESSAGE_CLASS_EVENT,
} msmcomm_message_class_t;

typedef enum
{
	MSMCOMM_MESSAGE_TYPE_INVALID,
	MSMCOMM_MESSAGE_TYPE_NOT_USED,

	/*
	 * Various available commands
	 */

	MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_IMEI,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_FIRMWARE_INFO,
	MSMCOMM_MESSAGE_TYPE_COMMAND_TEST_ALIVE,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONE_STATE_INFO,
	MSMCOMM_MESSAGE_TYPE_COMMAND_VERIFY_PIN,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_VOICEMAIL_NR,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_LOCATION_PRIV_PREF,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CM_CALL_ANSWER,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SET_AUDIO_PROFILE,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CM_CALL_END,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_CHARGER_STATUS,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CHARGING,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CM_CALL_ORIGINATION,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SET_SYSTEM_TIME,
	MSMCOMM_MESSAGE_TYPE_COMMAND_RSSI_STATUS,
	MSMCOMM_MESSAGE_TYPE_COMMAND_READ_PHONEBOOK,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_NETWORKLIST,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SET_MODE_PREFERENCE,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONEBOOK_PROPERTIES,
	MSMCOMM_MESSAGE_TYPE_COMMAND_WRITE_PHONEBOOK,
	MSMCOMM_MESSAGE_TYPE_COMMAND_DELETE_PHONEBOOK,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_PIN,
	MSMCOMM_MESSAGE_TYPE_COMMAND_ENABLE_PIN,
	MSMCOMM_MESSAGE_TYPE_COMMAND_DISABLE_PIN,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SIM_INFO,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE,
	MSMCOMM_MESSAGE_TYPE_COMMAND_SMS_GET_SMS_CENTER_NUMBER,
	MSMCOMM_MESSAGE_TYPE_COMMAND_CM_CALL_SUPS,
	MSMCOMM_MESSAGE_TYPE_COMMAND_GET_HOME_NETWORK_NAME,

	/*
	 * Response types for the commands above 
	 */

	MSMCOMM_MESSAGE_TYPE_RESPONSE_TEST_ALIVE,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_FIRMWARE_INFO,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_IMEI,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_PDSM_PD_GET_POS,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_PDSM_PD_END_SESSION,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_PA_SET_PARAM,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_LCS_AGENT_CLIENT_RSP,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_XTRA_SET_DATA,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_SIM,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_VOICEMAIL_NR,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_SOUND,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_CALL_RETURN,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_CALL_CALLBACK,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_CHARGER_STATUS,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_CHARGING,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_PH,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_SET_SYSTEM_TIME,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_RSSI_STATUS,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_PHONEBOOK,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_PHONEBOOK_PROPERTIES,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_AUDIO_MODEM_TUNING_PARAMS,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_SMS_WMS,
	MSMCOMM_MESSAGE_TYPE_RESPONSE_GET_HOME_NETWORK_NAME,

	/* 
	 * Various possible events (unsolicited responses)
	 */

	MSMCOMM_MESSAGE_TYPE_EVENT_RESET_RADIO_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CHARGER_STATUS,
	MSMCOMM_MESSAGE_TYPE_EVENT_OPERATION_MODE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO_AVAILABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_NETWORK_STATE_INFO,
	MSMCOMM_MESSAGE_TYPE_EVENT_PD_POSITION_DATA,
	MSMCOMM_MESSAGE_TYPE_EVENT_PD_PARAMETER_CHANGE,
	MSMCOMM_MESSAGE_TYPE_EVENT_PDSM_LCS,

	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIGINATION,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ANSWER,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END_REQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SUPS,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INCOMMING,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECT,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SRV_OPT,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PRIVACY,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PRIVACY_PREF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALLER_ID,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_ALTER,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_REORDER,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ABRV_INTERCEPT,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SIGNAL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_DISPLAY,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALLED_PARTY,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECTED_NUM,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INFO,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXT_DISP,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NDSS_START,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NDSS_CONNECT,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXT_BRST_INTL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_CLIR_REC,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_REL_REC,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_NSS_AUD_CTRL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_L2ACK_CALL_HOLD,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SETUP_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SETUP_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_ACTIVATE_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_ACTIVATE_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_REQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_REJ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_MODIFY_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REL_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_REQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_REJ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_RAB_REESTAB_FAIL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_DATA_AVAILABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MNG_CALLS_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_BARRED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_IS_WAITING,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_ON_HOLD,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_RETRIEVED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIG_FWD_STATUS,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_FORWARDED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_BEING_FORWARDED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_INCOM_FWD_CALL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_RESTRICTED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CUG_INFO_RECEIVED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CNAP_INFO_RECEIVED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EMERGENCY_FLASHED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PROGRESS_INFO_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_DEFLECTION,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_TRANSFERRED_CALL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_EXIT_TC,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_REDIRECTING_NUMBER,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PDP_PROMOTE_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_UMTS_CDMA_HANDOVER_START,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_UMTS_CDMA_HANDOVER_END,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_SECONDARY_MSM,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ORIG_MOD_TO_SS,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_USER_DATA_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_USER_DATA_CONG_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_REQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_LINE_CTRL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_ALLOWED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_ACT_CCBS_CNF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_RECALL_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CCBS_RECALL_RSP,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CALL_ORIG_THR,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VS_AVAIL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VS_NOT_AVAIL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_COMPLETE_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_MODIFY_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_CONNECT_ORDER_ACK,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_TUNNEL_MSG,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_END_VOIP_CALL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_VOIP_CALL_END_CNF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_REQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_CNF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_CALL_PS_SIG_REL_IND,

	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_OPRT_MODE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_TEST_CONTROL_TYPE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SYS_SEL_PREF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_ANSWER_VOICE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_NAM_SEL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CURR_NAM,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_IN_USE_STATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CDMA_LOCK_MODE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_UZ_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_MAINTREQ,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_STANDBY_SLEEP,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_STANDBY_WAKE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PACKET_STATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_INFO_AVAIL,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_AVAILABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_NOT_AVAILABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SUBSCRIPTION_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_AVAILABLE_NETWORKS_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PREFERRED_NETWORKS_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_FUNDS_LOW,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_WAKEUP_FROM_STANDBY,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_NVRUIM_CONFIG_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PREFERRED_NETWORKS_SET,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_DDTM_PREF,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_PS_ATTACH_FAILED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_RESET_ACM_COMPLETED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SET_ACMMAX_COMPLETED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CDMA_CAPABILITY_UPDATED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_LINE_SWITCHING,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SELECTED_LINE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SECONDARY_MSM,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_TERMINATE_GET_NETWORKS,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_DDTM_STATUS,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_CCBS_STORE_INFO_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_EVENT_UNFORCE_ORIG_COMPLETE,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH_SEND_MANUAL_NET_SELECTN,

	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INSERTED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_VERIFIED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_BLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_UNBLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_ENABLED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_DISABLED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_PERM_BLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_VERIFIED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_BLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_UNBLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_ENABLED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_DISABLED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_CHANGED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_PERM_BLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_RESET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_INIT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_INIT_FCN,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_FAILED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_FDN_ENABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_FDN_DISABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_ILLEGAL,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_ILLEGAL_2,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_UHZI_V2_COMPLETE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_UHZI_V1_COMPLETE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_EVENT_GEN_PROP2,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REMOVED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_SIM_EVENT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_SIM,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_DRIVER_ERROR,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INTERNAL_RESET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INIT_COMPLETED_NO_PROV,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_MEMORY_WARNING,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_SIM2_EVENT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REAL_RESET_FAILURE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_CARD_ERROR,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_EVENT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_GET_PERSO_NW_FAILURE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_GET_PERSO_NW_BLOCKED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_APP_RESET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_3G_SESSION_RESET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_APP_SELECTED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_DEFAULT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_CARD_ERR_NOT_ATR_RECEIVED_WITH_MAX_VOLTAGE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_APP_RESET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_3G_SESSION_RESET_2,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_SANITY_ERROR,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_GEN_PROP1,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_GEN_PROP2,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_EVT_INIT_COMPLETED,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PLMN_SEL_MENU_ENABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PLMN_SEL_MENU_DISABLE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_PROCESS_USS,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_PROCESS_USS_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_USS_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_RELEASE_USS_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_USS_NOTIFY_IND,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_USS_NOTIFY_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_RELEASE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_ABORT,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_ERASE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_REGISTER,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_REGISTER_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_GET_PASSWORD_IN,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_GET_PASSWORD_RES,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_INTERROGATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_INTERROGATE_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_ACTIVATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_ACTIVATE_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_DEACTIVATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SUPS_DEACTIVATE_CONF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_MESSAGE_LIST,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_EVENT_ROUTES,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_MEMORY_STATUS,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_CFG_GW_READY,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_RECEIVED_MESSAGE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_WMS_READ_TEMPLATE,
	MSMCOMM_MESSAGE_TYPE_EVENT_SMS_INFO,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_READY,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_MODIFIED,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_ADDED,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_DELETED,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_UPDATED,
	MSMCOMM_MESSAGE_TYPE_EVENT_PHONEBOOK_RECORD_FAILED,
	MSMCOMM_MESSAGE_TYPE_EVENT_CM_PH,
	MSMCOMM_MESSAGE_TYPE_EVENT_GET_NETWORKLIST,
	MSMCOMM_MESSAGE_TYPE_EVENT_PDSM_PD_DONE,
	MSMCOMM_MESSAGE_TYPE_EVENT_PDSM_XTRA,
} msmcomm_message_type_t;


/*
 * Phonebook types
 */

typedef enum
{
	MSMCOMM_PHONEBOOK_TYPE_NONE,
	MSMCOMM_PHONEBOOK_TYPE_ADN,
	MSMCOMM_PHONEBOOK_TYPE_FDN,
	MSMCOMM_PHONEBOOK_TYPE_SDN,
	MSMCOMM_PHONEBOOK_TYPE_EFECC,
	MSMCOMM_PHONEBOOK_TYPE_MBDN,
	MSMCOMM_PHONEBOOK_TYPE_MBN,
	MSMCOMM_PHONEBOOK_TYPE_ALL,
	MSMCOMM_PHONEBOOK_TYPE_TEST1,
} msmcomm_phonebook_type_t;

/*
 * Operation modes
 */

typedef enum 
{
	MSMCOMM_OPERATION_MODE_RESET,
	MSMCOMM_OPERATION_MODE_ONLINE,
	MSMCOMM_OPERATION_MODE_OFFLINE,
	MSMCOMM_OPERATION_MODE_POWEROFF,
	MSMCOMM_OPERATION_MODE_LPM,
	MSMCOMM_OPERATION_MODE_LPM_DEFAULT,
} msmcomm_operation_mode_t;

/*
 * Charging modes
 */

typedef enum 
{
	MSMCOMM_CHARGING_MODE_USB,
	MSMCOMM_CHARGING_MODE_INDUCTIVE,
} msmcomm_charging_mode_t;

/*
 * Charging voltages (only for USB mode)
 */

typedef enum
{
	MSMCOMM_CHARGING_VOLTAGE_MODE_250mA,
	MSMCOMM_CHARGING_VOLTAGE_MODE_500mA, 
	MSMCOMM_CHARGING_VOLTAGE_MODE_1A
} msmcomm_charging_voltage_t;

/*
 * Network State Info changed field types
 */

typedef enum 
{
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_INVALID,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SID,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_NID,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PACKET_ZONE,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_REGISTRATION_ZONE,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASESTATION_P_REV,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVICE_DOMAIN,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_CONCURRENT_SERVICES_SUPPORTED,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_P_REV_IN_USE,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVING_STATUS,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_SERVICE_CAPABILITY,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_MODE,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_ROAMING_STATUS,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_ID,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERICE_INDICATOR,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_MOBILITY_MANAGEMENT,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_HDR,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SIM_CARD_STATUS,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PLMN,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PS_DATA_SUSPEND_MASK,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_UZ,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASE_STATION_PARAMETERS_CHANGED,
	MSMCOMM_NETWORK_STATE_INFO_CHANGED_FILED_TYPE_ORIGINATION_STATUS,
} msmcomm_network_state_info_changed_field_t;

/*
 * Error codes
 */

typedef enum
{
	MSMCOMM_ERROR_GROUPID_NOT_SUPPORTED,
	MSMCOMM_ERROR_MSGID_NOT_SUPPORTED,
	MSMCOMM_ERROR_INVALID_PAYLOAD_LENGTH,
} msmcomm_error_t;

/*
 * Message result codes
 */

typedef enum
{
	MSMCOMM_RESULT_NONE,
	MSMCOMM_RESULT_OK,
	MSMCOMM_RESULT_ERROR,
	MSMCOMM_RESULT_READ_SIMBOOK_INVALID_RECORD_ID,
	MSMCOMM_RESULT_SIM_BAD_STATE,
	MSMCOMM_RESULT_BAD_CALL_ID,
	MSMCOMM_RESULT_INVALID_AUDIO_PROFILE,
} msmcomm_result_t;

/*
 * Encoding types
 */

typedef enum
{
	MSMCOMM_ENCODING_TYPE_NONE,
	MSMCOMM_ENCODING_TYPE_ASCII,
	MSMCOMM_ENCODING_TYPE_BUCS2,
} msmcomm_encoding_t;

/*
 * Network modes
 */

typedef enum 
{
	MSMCOMM_NETWORK_MODE_AUTOMATIC,
	MSMCOMM_NETWORK_MODE_GSM,
	MSMCOMM_NETWORK_MODE_UMTS,
} msmcomm_network_mode_t;

/*
 * Call types
 */

typedef enum
{
	MSMCOMM_CALL_TYPE_NONE,
	MSMCOMM_CALL_TYPE_DATA,
	MSMCOMM_CALL_TYPE_AUDIO,
} msmcomm_call_type_t;

/*
 * SIM Pin Types
 */

typedef enum
{
	MSMCOMM_SIM_PIN_NONE,
	MSMCOMM_SIM_PIN_1,
	MSMCOMM_SIM_PIN_2,
} msmcomm_sim_pin_type_t;

/*
 * SIM Field Types
 */

typedef enum
{
	MSMCOMM_SIM_INFO_FIELD_TYPE_NONE,
	MSMCOMM_SIM_INFO_FIELD_TYPE_IMSI,
	MSMCOMM_SIM_INFO_FIELD_TYPE_MSISDN,
} msmcomm_sim_info_field_type_t;

typedef enum
{
	MSMCOMM_NETWORK_REGISTRATION_STATUS_INVALID,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_NO_SERVICE,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_HOME,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_SEARCHING,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_DENIED,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_ROAMING,
	MSMCOMM_NETWORK_REGISTRATION_STATUS_UNKNOWN,
} msmcomm_network_registration_status_t;

typedef enum
{
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_INVALID,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_ALL_OR_SEND_BUSY,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_ALL_AND_ACCEPT_WAITING_OR_HELD,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_ACTIVATE_HELD,
	MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_DROP_SELF_AND_CONNECT_ACTIVE,
} msmcomm_cm_call_sups_comand_type_t;

/*
 * Some constants
 */
#define MSMCOMM_MAX_IMSI_LENGTH                                     15
#define MSMCOMM_AUDIO_MODEM_TUNING_PARAMS_LENGTH                    16
#define MSMCOMM_DEFAULT_PLMN_LENGTH                                 3

struct msmcomm_context;
struct msmcomm_message;

typedef void (*msmcomm_response_handler_cb) (void *user_data, msmcomm_message_type_t event, struct msmcomm_message * message);
typedef void (*msmcomm_write_handler_cb) (void *user_data, uint8_t * data, uint32_t len);
typedef int (*msmcomm_read_handler_cb) (void *user_data, uint8_t * data, uint32_t len);
typedef void (*msmcomm_log_handler_cb) (void *user_data, char *buffer, unsigned int len);
typedef void (*msmcomm_error_handler_cb) (void *user_data, msmcomm_error_t error, void *data);
typedef void (*msmcomm_network_state_info_changed_field_type_cb) (void *user_data, struct msmcomm_message * msg, msmcomm_network_state_info_changed_field_t type);

int msmcomm_init(struct msmcomm_context *ctx);
int msmcomm_shutdown(struct msmcomm_context *ctx);
int msmcomm_read_from_modem(struct msmcomm_context *ctx);
int msmcomm_process_data(struct msmcomm_context *ctx, uint8_t *data, uint32_t length);
int msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg);
unsigned int msmcomm_check_hci_version(unsigned int hci_version);

void msmcomm_register_response_handler(struct msmcomm_context *ctx, msmcomm_response_handler_cb response_handler, void *data);
void msmcomm_register_write_handler(struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler, void *data);
void msmcomm_register_read_handler(struct msmcomm_context *ctx, msmcomm_read_handler_cb read_handler, void *data);
void msmcomm_register_error_handler(struct msmcomm_context *ctx, msmcomm_error_handler_cb error_handler, void *data);
void msmcomm_register_log_handler(struct msmcomm_context *ctx, msmcomm_log_handler_cb log_handler, void *data);

char *msmcomm_message_type_to_string(msmcomm_message_type_t type);
char *msmcomm_message_class_to_string(msmcomm_message_class_t type);

/**
 * These are common operations which are valid for all kind of messages
 */

struct msmcomm_message *msmcomm_create_message(unsigned int type);
struct msmcomm_message *msmcomm_message_make_copy(struct msmcomm_message *msg);
uint32_t msmcomm_message_get_size(struct msmcomm_message *msg);
msmcomm_message_type_t msmcomm_message_get_type(struct msmcomm_message *msg);
uint32_t msmcomm_message_get_ref_id(struct msmcomm_message *msg);
void msmcomm_message_set_ref_id(struct msmcomm_message *msg, uint32_t ref_id);
msmcomm_result_t msmcomm_message_get_result(struct msmcomm_message *msg);
msmcomm_message_class_t msmcomm_message_get_class(struct msmcomm_message *msg);

/**
 * These are message/response/event specific operations which only should be
 * executed on the right message!
 */

void msmcomm_message_change_operation_mode_set_operation_mode(struct msmcomm_message *msg, msmcomm_operation_mode_t operation_mode);

void msmcomm_message_charging_set_voltage(struct msmcomm_message *msg, msmcomm_charging_voltage_t voltage);
void msmcomm_message_charging_set_mode(struct msmcomm_message *msg, msmcomm_charging_mode_t mode);

void msmcomm_message_set_mode_preference_status_set_mode(struct msmcomm_message *msg, unsigned int mode);

void msmcomm_message_cm_call_origination_set_caller_id(struct msmcomm_message *msg, const char *caller_id, unsigned int len);
void msmcomm_message_cm_call_origination_set_block(struct msmcomm_message *msg, unsigned int block);
void msmcomm_message_cm_call_answer_set_call_id(struct msmcomm_message *msg, uint8_t call_id);
void msmcomm_message_cm_call_end_set_call_id(struct msmcomm_message *msg, uint8_t call_id);

void msmcomm_message_verify_pin_set_pin(struct msmcomm_message *msg, const char *pin);

void msmcomm_message_enable_pin_set_pin_type(struct msmcomm_message *msg, msmcomm_sim_pin_type_t pin_type);

void msmcomm_message_disable_pin_set_pin_type(struct msmcomm_message *msg, msmcomm_sim_pin_type_t pin_type);
void msmcomm_message_disable_pin_set_pin(struct msmcomm_message *msg, const char *pin);

void msmcomm_message_read_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type);
void msmcomm_message_read_phonebook_set_position(struct msmcomm_message *msg, uint8_t position);

void msmcomm_message_write_phonebook_set_number(struct msmcomm_message *msg, const char *number, unsigned int len);
void msmcomm_message_write_phonebook_set_title(struct msmcomm_message *msg, const char *title, unsigned int len);
void msmcomm_message_write_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type);

void msmcomm_message_delete_phonebook_set_position(struct msmcomm_message *msg, uint8_t position);
void msmcomm_message_delete_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type);

void msmcomm_message_change_pin_set_old_pin(struct msmcomm_message *msg, const char *old_pin, unsigned int len);
void msmcomm_message_change_pin_set_new_pin(struct msmcomm_message *msg, const char *new_pin, unsigned int len);

void msmcomm_message_manage_calls_set_call_id(struct msmcomm_message *msg, uint8_t call_id);
void msmcomm_message_manage_calls_set_command_type(struct msmcomm_message *msg, msmcomm_cm_call_sups_comand_type_t command_type);

uint8_t msmcomm_event_sms_wms_read_template_get_digit_mode(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_mode(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_plan(struct msmcomm_message *msg);

unsigned int msmcomm_event_phonebook_ready_get_book_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_phonebook_modified_get_position(struct msmcomm_message *msg);
uint8_t msmcomm_event_phonebook_modified_get_book_type(struct msmcomm_message *msg);

unsigned int msmcomm_resp_phonebook_get_book_type(struct msmcomm_message *msg);
uint8_t msmcomm_resp_phonebook_get_position(struct msmcomm_message *msg);
unsigned int msmcomm_resp_phonebook_get_encoding_type(struct msmcomm_message *msg);
char *msmcomm_resp_phonebook_get_number(struct msmcomm_message *msg);
char *msmcomm_resp_phonebook_get_title(struct msmcomm_message *msg);
uint8_t msmcomm_resp_phonebook_get_modify_id(struct msmcomm_message *msg);

uint32_t msmcomm_resp_get_phonebook_properties_get_slot_count(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_slots_used(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_title(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_number(struct msmcomm_message *msg);

char *msmcomm_resp_get_firmware_info_get_info(struct msmcomm_message *msg);
uint8_t msmcomm_resp_get_firmware_info_get_hci_version(struct msmcomm_message *msg);

char *msmcomm_resp_get_imei_get_imei(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charging_get_voltage(struct msmcomm_message *msg);
unsigned int msmcomm_resp_charging_get_mode(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charger_status_get_voltage(struct msmcomm_message *msg);
unsigned int msmcomm_resp_charger_status_get_mode(struct msmcomm_message *msg);

void msmcomm_message_set_system_time_set(struct msmcomm_message *msg, uint16_t year, uint16_t month,
                                         uint16_t day, uint16_t hours, uint16_t minutes,
                                         uint16_t seconds, int32_t timezone_offset);

void msmcomm_message_rssi_status_set_status(struct msmcomm_message *msg, uint8_t status);

uint8_t msmcomm_resp_cm_ph_get_result(struct msmcomm_message *msg);

uint16_t msmcomm_resp_cm_call_callback_get_cmd_type(struct msmcomm_message *msg);

uint8_t msmcomm_event_power_state_get_state(struct msmcomm_message *msg);

unsigned int msmcomm_event_charger_status_get_voltage(struct msmcomm_message *msg);

char *msmcomm_event_cm_call_get_caller_id(struct msmcomm_message *msg);
uint8_t msmcomm_event_cm_call_get_reject_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_cm_call_get_reject_value(struct msmcomm_message *msg);
uint8_t msmcomm_event_cm_call_get_call_id(struct msmcomm_message *msg);
unsigned int msmcomm_event_cm_call_get_call_type(struct msmcomm_message *msg);

unsigned int msmcomm_event_network_state_info_is_only_rssi_update(struct msmcomm_message *msg);
uint32_t msmcomm_event_network_state_info_get_change_field(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_new_value(struct msmcomm_message *msg);
uint8_t *msmcomm_event_network_state_info_get_plmn(struct msmcomm_message *msg);
char *msmcomm_event_network_state_info_get_operator_name(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_rssi(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_ecio(struct msmcomm_message *msg);
void msmcomm_event_network_state_info_trace_changes(struct msmcomm_message *msg,
                                                    msmcomm_network_state_info_changed_field_type_cb
                                                    type_handler, void *user_data);
uint8_t msmcomm_event_network_state_info_get_service_domain(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_service_capability(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_gprs_attached(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_roam(struct msmcomm_message *msg);
msmcomm_network_registration_status_t msmcomm_event_network_state_info_get_registration_status(struct msmcomm_message *msg);

unsigned int msmcomm_event_get_networklist_get_network_count(struct msmcomm_message *msg);
unsigned int msmcomm_event_get_networklist_get_plmn(struct msmcomm_message *msg, int nnum);
char *msmcomm_event_get_networklist_get_network_name(struct msmcomm_message *msg, int nnum);

char* msmcomm_resp_sim_get_field_data(struct msmcomm_message *msg);
unsigned int msmcomm_resp_sim_info_get_field_type(struct msmcomm_message *msg);

void msmcomm_message_sim_info_set_field_type(struct msmcomm_message *msg, unsigned int field_type);
                                            
uint8_t *msmcomm_resp_audio_modem_tuning_params_get_params(struct msmcomm_message *msg, unsigned int *len);

void msmcomm_message_set_audio_profile_set_class(struct msmcomm_message *msg, uint8_t class);
void msmcomm_message_set_audio_profile_set_sub_class(struct msmcomm_message *msg, uint8_t sub_class);

uint8_t msmcomm_event_cm_ph_get_plmn_count(struct msmcomm_message *msg);
unsigned int msmcomm_event_cm_ph_get_plmn(struct msmcomm_message *msg, unsigned int n);

char* msmcomm_event_sms_recieved_message_get_sender(struct msmcomm_message *msg);
uint8_t* msmcomm_event_sms_recieved_message_get_pdu(struct msmcomm_message *msg, unsigned int *len);

#endif
