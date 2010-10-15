/*
 * (C) 2009-2010 by Simon Busch <morphis@gravedo.de>
 * (C) 2010 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
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

[CCode (cheader_filename = "msmcomm.h")]
namespace Msmcomm
{
	[CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_MESSAGE_CLASS_", cheader_filename = "msmcomm.h")]
	public enum MessageClass
	{
		NONE,
		COMMAND,
		RESPONSE,
		EVENT,
	}

	public string messageClassToString(MessageClass class)
	{
		var result = "<unknown>";
		switch (class)
		{
			case MessageClass.NONE:
				result = "NONE";
				break;
			case MessageClass.COMMAND:
				result = "COMMAND";
                break;
            case MessageClass.RESPONSE:
                result = "RESPONSE";
                break;
            case MessageClass.EVENT:
                result = "EVENT";
                break;
        }
        return result;
    }
    
    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_MESSAGE_TYPE_", cheader_filename = "msmcomm.h")]
	public enum MessageType
	{
		INVALID,
		NOT_USED,
		COMMAND_CHANGE_OPERATION_MODE,
		COMMAND_GET_IMEI,
		COMMAND_GET_FIRMWARE_INFO,
		COMMAND_TEST_ALIVE,
		COMMAND_GET_PHONE_STATE_INFO,
		COMMAND_VERIFY_PIN,
		COMMAND_GET_VOICEMAIL_NR,
		COMMAND_GET_LOCATION_PRIV_PREF,
		COMMAND_ANSWER_CALL,
		COMMAND_SET_AUDIO_PROFILE,
		COMMAND_END_CALL,
		COMMAND_GET_CHARGER_STATUS,
		COMMAND_CHARGING,
		COMMAND_DIAL_CALL,
		COMMAND_SET_SYSTEM_TIME,
		COMMAND_RSSI_STATUS,
		COMMAND_READ_PHONEBOOK,
		COMMAND_GET_NETWORKLIST,
		COMMAND_SET_MODE_PREFERENCE,
		COMMAND_GET_PHONEBOOK_PROPERTIES,
		COMMAND_WRITE_PHONEBOOK,
		COMMAND_DELETE_PHONEBOOK,
		COMMAND_CHANGE_PIN,
		COMMAND_ENABLE_PIN,
		COMMAND_DISABLE_PIN,
		COMMAND_SIM_INFO,
		COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS,
		COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE,
		COMMAND_SMS_GET_SMS_CENTER_NUMBER,
        COMMAND_MANAGE_CALLS,
		RESPONSE_TEST_ALIVE,
		RESPONSE_GET_FIRMWARE_INFO,
		RESPONSE_GET_IMEI,
		RESPONSE_PDSM_PD_GET_POS,
		RESPONSE_PDSM_PD_END_SESSION,
		RESPONSE_PA_SET_PARAM,
		RESPONSE_LCS_AGENT_CLIENT_RSP,
		RESPONSE_XTRA_SET_DATA,
		RESPONSE_SIM,
		RESPONSE_GET_VOICEMAIL_NR,
		RESPONSE_SOUND,
		RESPONSE_CM_CALL,
		RESPONSE_CHARGER_STATUS,
		RESPONSE_CHARGING,
		RESPONSE_CM_PH,
		RESPONSE_SET_SYSTEM_TIME,
		RESPONSE_RSSI_STATUS,
		RESPONSE_PHONEBOOK,
		RESPONSE_GET_PHONEBOOK_PROPERTIES,
		RESPONSE_AUDIO_MODEM_TUNING_PARAMS,
		RESPONSE_SMS_WMS,
		EVENT_RESET_RADIO_IND,
		EVENT_CHARGER_STATUS,
		EVENT_OPERATION_MODE,
		EVENT_CM_PH_INFO_AVAILABLE,
		EVENT_NETWORK_STATE_INFO,
		EVENT_PDSM_PD_DONE,
		EVENT_PD_POSITION_DATA,
		EVENT_PD_PARAMETER_CHANGE,
		EVENT_PDSM_LCS,
		EVENT_PDSM_XTRA,
		EVENT_CALL_STATUS,
		EVENT_CALL_INCOMMING,
		EVENT_CALL_ORIGINATION,
		EVENT_CALL_CONNECT,
		EVENT_CALL_END,
		EVENT_SIM_INSERTED,
		EVENT_SIM_PIN1_VERIFIED,
		EVENT_SIM_PIN1_BLOCKED,
		EVENT_SIM_PIN1_UNBLOCKED,
		EVENT_SIM_PIN1_ENABLED,
		EVENT_SIM_PIN1_DISABLED,
		EVENT_SIM_PIN1_CHANGED,
		EVENT_SIM_PIN1_PERM_BLOCKED,
		EVENT_SIM_PIN2_VERIFIED,
		EVENT_SIM_PIN2_BLOCKED,
		EVENT_SIM_PIN2_UNBLOCKED,
		EVENT_SIM_PIN2_ENABLED,
		EVENT_SIM_PIN2_DISABLED,
		EVENT_SIM_PIN2_CHANGED,
		EVENT_SIM_PIN2_PERM_BLOCKED,
		EVENT_SIM_REFRESH_RESET,
		EVENT_SIM_REFRESH_INIT,
		EVENT_SIM_REFRESH_INIT_FCN,
		EVENT_SIM_REFRESH_FAILED,
		EVENT_SIM_FDN_ENABLE,
		EVENT_SIM_FDN_DISABLE,
		EVENT_SIM_ILLEGAL,
		EVENT_SIM_REMOVED,
		EVENT_SIM_NO_SIM_EVENT,
		EVENT_SIM_NO_SIM,
		EVENT_SIM_DRIVER_ERROR,
		EVENT_SIM_INTERNAL_RESET,
		EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL,
		EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL,
		EVENT_SIM_INIT_COMPLETED_NO_PROV,
		EVENT_SIM_MEMORY_WARNING,
		EVENT_SIM_SIM2_EVENT,
		EVENT_SIM_REAL_RESET_FAILURE,
		EVENT_SIM_CARD_ERROR,
		EVENT_SIM_NO_EVENT,
		EVENT_SIM_GET_PERSO_NW_FAILURE,
		EVENT_SIM_GET_PERSO_NW_BLOCKED,
		EVENT_SIM_REFRESH_APP_RESET,
		EVENT_SIM_REFRESH_3G_SESSION_RESET,
		EVENT_SIM_APP_SELECTED,
		EVENT_SIM_DEFAULT,
		EVENT_SUPS_PROCESS_USS,
		EVENT_SUPS_PROCESS_USS_CONF,
		EVENT_SUPS_USS_RES,
		EVENT_SUPS_RELEASE_USS_IND,
		EVENT_SUPS_USS_NOTIFY_IND,
		EVENT_SUPS_USS_NOTIFY_RES,
		EVENT_SUPS_RELEASE,
		EVENT_SUPS_ABORT,
		EVENT_SUPS_ERASE,
		EVENT_SUPS_REGISTER,
		EVENT_SUPS_REGISTER_CONF,
		EVENT_SUPS_GET_PASSWORD_IN,
		EVENT_SUPS_GET_PASSWORD_RES,
		EVENT_SUPS_INTERROGATE,
		EVENT_SUPS_INTERROGATE_CONF,
		EVENT_SUPS_ACTIVATE,
		EVENT_SUPS_ACTIVATE_CONF,
		EVENT_SUPS_DEACTIVATE,
		EVENT_SUPS_DEACTIVATE_CONF,
		EVENT_SMS_WMS_CFG_MESSAGE_LIST,
		EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF,
		EVENT_SMS_WMS_CFG_EVENT_ROUTES,
		EVENT_SMS_WMS_CFG_MEMORY_STATUS,
		EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET,
		EVENT_SMS_WMS_CFG_GW_READY,
		EVENT_SMS_RECEIVED_MESSAGE,
		EVENT_SMS_WMS_READ_TEMPLATE,
		EVENT_SMS_INFO,
		EVENT_PHONEBOOK_READY,
		EVENT_PHONEBOOK_MODIFIED,
		EVENT_CM_PH,
		EVENT_GET_NETWORKLIST,
	}

    public string messageTypeToString( MessageType t )
    {
        switch ( t )
        {
            case 0:
            return "INVALID";
            // CommandType
            case MessageType.COMMAND_CHANGE_OPERATION_MODE:
            return "COMMAND_CHANGE_OPERATION_MODE";
            case MessageType.COMMAND_GET_IMEI:
            return "COMMAND_GET_IMEI";
            case MessageType.COMMAND_GET_FIRMWARE_INFO:
            return "COMMAND_GET_FIRMWARE_INFO";
            case MessageType.COMMAND_TEST_ALIVE:
            return "COMMAND_TEST_ALIVE";
            case MessageType.COMMAND_GET_PHONE_STATE_INFO:
            return "COMMAND_GET_PHONE_STATE_INFO";
            case MessageType.COMMAND_VERIFY_PIN:
            return "COMMAND_VERIFY_PIN";
            case MessageType.COMMAND_GET_VOICEMAIL_NR:
            return "COMMAND_GET_VOICEMAIL_NR";
            case MessageType.COMMAND_GET_LOCATION_PRIV_PREF:
            return "COMMAND_GET_LOCATION_PRIV_PREF";
            case MessageType.COMMAND_ANSWER_CALL:
            return "COMMAND_ANSWER_CALL";
            case MessageType.COMMAND_SET_AUDIO_PROFILE:
            return "COMMAND_SET_AUDIO_PROFILE";
            case MessageType.COMMAND_END_CALL:
            return "COMMAND_END_CALL";
            case MessageType.COMMAND_GET_CHARGER_STATUS:
            return "COMMAND_GET_CHARGER_STATUS";
            case MessageType.COMMAND_CHARGING:
            return "COMMAND_CHARGING";
            case MessageType.COMMAND_DIAL_CALL:
            return "COMMAND_DIAL_CALL";
            case MessageType.COMMAND_SET_SYSTEM_TIME:
            return "COMMAND_SET_SYSTEM_TIME";
            case MessageType.COMMAND_RSSI_STATUS:
            return "COMMAND_RSSI_STATUS";
            case MessageType.COMMAND_READ_PHONEBOOK:
            return "COMMAND_READ_PHONEBOOK";
            case MessageType.COMMAND_GET_NETWORKLIST:
            return "COMMAND_GET_NETWORKLIST";
            case MessageType.COMMAND_SET_MODE_PREFERENCE:
            return "COMMAND_SET_MODE_PREFERENCE";
            case MessageType.COMMAND_ENABLE_PIN:
            return "COMMAND_ENABLE_PIN";
            case MessageType.COMMAND_DISABLE_PIN:
            return "COMMAND_DISABLE_PIN";
            case MessageType.COMMAND_SIM_INFO:
            return "COMMAND_SIM_INFO";
            case MessageType.COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS:
            return "COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS";
            case MessageType.COMMAND_SMS_GET_SMS_CENTER_NUMBER:
            return "COMMAND_SMS_GET_SMS_CENTER_NUMBER";
            case MessageType.COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE:
            return "COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE";
            case MessageType.COMMAND_MANAGE_CALLS:
            return "COMMAND_MANAGE_CALLS";

            case MessageType.RESPONSE_TEST_ALIVE:
            return "RESPONSE_TEST_ALIVE";
            case MessageType.RESPONSE_GET_FIRMWARE_INFO:
			return "RESPONSE_GET_FIRMWARE_INFO";
            case MessageType.RESPONSE_GET_IMEI:
			return "RESPONSE_GET_IMEI";
            case MessageType.RESPONSE_PDSM_PD_GET_POS:
			return "RESPONSE_PDSM_PD_GET_POS";
            case MessageType.RESPONSE_PDSM_PD_END_SESSION:
			return "RESPONSE_PDSM_PD_END_SESSION";
            case MessageType.RESPONSE_PA_SET_PARAM:
			return "RESPONSE_PA_SET_PARAM";
            case MessageType.RESPONSE_LCS_AGENT_CLIENT_RSP:
			return "RESPONSE_LCS_AGENT_CLIENT_RSP";
            case MessageType.RESPONSE_XTRA_SET_DATA:
			return "RESPONSE_XTRA_SET_DATA";
            case MessageType.RESPONSE_SIM:
			return "RESPONSE_SIM";
            case MessageType.RESPONSE_GET_VOICEMAIL_NR:
			return "RESPONSE_GET_VOICEMAIL_NR";
            case MessageType.RESPONSE_SOUND:
			return "RESPONSE_SOUND";
            case MessageType.RESPONSE_CM_CALL:
			return "RESPONSE_CM_CALL";
            case MessageType.RESPONSE_CHARGER_STATUS:
			return "RESPONSE_CHARGER_STATUS";
            case MessageType.RESPONSE_CHARGING:
            return "RESPONSE_CHARGING";
            case MessageType.RESPONSE_CM_PH:
            return "RESPONSE_CM_PH";
			case MessageType.RESPONSE_SET_SYSTEM_TIME:
			return "RESPONSE_SET_SYSTEM_TIME";
			case MessageType.RESPONSE_RSSI_STATUS:
			return "RESPONSE_RSSI_STATUS";
			case MessageType.RESPONSE_PHONEBOOK:
			return "RESPONSE_PHONEBOOK";
			case MessageType.RESPONSE_GET_PHONEBOOK_PROPERTIES:
			return "RESPONSE_GET_PHONEBOOK_PROPERTIES";
            case MessageType.RESPONSE_AUDIO_MODEM_TUNING_PARAMS:
            return "RESPONSE_AUDIO_MODEM_TUNING_PARAMS";

            // EventType
        	case MessageType.EVENT_RESET_RADIO_IND:
			return "URC_RESET_RADIO_IND";
        	case MessageType.EVENT_CHARGER_STATUS:
			return "URC_CHARGER_STATUS";
        	case MessageType.EVENT_OPERATION_MODE:
			return "URC_OPERATION_MODE";
        	case MessageType.EVENT_CM_PH_INFO_AVAILABLE:
			return "URC_CM_PH_INFO_AVAILABLE";
        	case MessageType.EVENT_NETWORK_STATE_INFO:
			return "URC_NETWORK_STATE_INFO";
        	case MessageType.EVENT_PDSM_PD_DONE:
			return "URC_PDSM_PD_DONE";
        	case MessageType.EVENT_PD_POSITION_DATA:
			return "URC_PD_POSITION_DATA";
        	case MessageType.EVENT_PD_PARAMETER_CHANGE:
			return "URC_PD_PARAMETER_CHANGE";
        	case MessageType.EVENT_PDSM_LCS:
			return "URC_PDSM_LCS";
        	case MessageType.EVENT_PDSM_XTRA:
			return "URC_PDSM_XTRA";
        	case MessageType.EVENT_CALL_STATUS:
			return "URC_CALL_STATUS";
        	case MessageType.EVENT_CALL_INCOMMING:
			return "URC_CALL_INCOMMING";
        	case MessageType.EVENT_CALL_ORIGINATION:
			return "URC_CALL_ORIGINATION";
        	case MessageType.EVENT_CALL_CONNECT:
			return "URC_CALL_CONNECT";
        	case MessageType.EVENT_CALL_END:
			return "URC_CALL_END";
        	case MessageType.EVENT_SIM_INSERTED:
			return "URC_SIM_INSERTED";
        	case MessageType.EVENT_SIM_PIN1_VERIFIED:
			return "URC_SIM_PIN1_VERIFIED";
        	case MessageType.EVENT_SIM_PIN1_BLOCKED:
			return "URC_SIM_PIN1_BLOCKED";
        	case MessageType.EVENT_SIM_PIN1_UNBLOCKED:
			return "URC_SIM_PIN1_UNBLOCKED";
        	case MessageType.EVENT_SIM_PIN1_ENABLED:
			return "URC_SIM_PIN1_ENABLED";
        	case MessageType.EVENT_SIM_PIN1_DISABLED:
			return "URC_SIM_PIN1_DISABLED";
        	case MessageType.EVENT_SIM_PIN1_CHANGED:
			return "URC_SIM_PIN1_CHANGED";
        	case MessageType.EVENT_SIM_PIN1_PERM_BLOCKED:
			return "URC_SIM_PIN1_PERM_BLOCKED";
        	case MessageType.EVENT_SIM_PIN2_VERIFIED:
			return "URC_SIM_PIN2_VERIFIED";
        	case MessageType.EVENT_SIM_PIN2_BLOCKED:
			return "URC_SIM_PIN2_BLOCKED";
        	case MessageType.EVENT_SIM_PIN2_UNBLOCKED:
			return "URC_SIM_PIN2_UNBLOCKED";
        	case MessageType.EVENT_SIM_PIN2_ENABLED:
			return "URC_SIM_PIN2_ENABLED";
        	case MessageType.EVENT_SIM_PIN2_DISABLED:
			return "URC_SIM_PIN2_DISABLED";
        	case MessageType.EVENT_SIM_PIN2_CHANGED:
			return "URC_SIM_PIN2_CHANGED";
        	case MessageType.EVENT_SIM_PIN2_PERM_BLOCKED:
			return "URC_SIM_PIN2_PERM_BLOCKED";
        	case MessageType.EVENT_SIM_REFRESH_RESET:
			return "URC_SIM_REFRESH_RESET";
        	case MessageType.EVENT_SIM_REFRESH_INIT:
			return "URC_SIM_REFRESH_INIT";
        	case MessageType.EVENT_SIM_REFRESH_INIT_FCN:
			return "URC_SIM_REFRESH_INIT_FCN";
        	case MessageType.EVENT_SIM_REFRESH_FAILED:
			return "URC_SIM_REFRESH_FAILED";
        	case MessageType.EVENT_SIM_FDN_ENABLE:
			return "URC_SIM_FDN_ENABLE";
        	case MessageType.EVENT_SIM_FDN_DISABLE:
			return "URC_SIM_FDN_DISABLE";
        	case MessageType.EVENT_SIM_ILLEGAL:
			return "URC_SIM_ILLEGAL";
        	case MessageType.EVENT_SIM_REMOVED:
			return "URC_SIM_REMOVED";
        	case MessageType.EVENT_SIM_NO_SIM_EVENT:
			return "URC_SIM_NO_SIM_EVENT";
        	case MessageType.EVENT_SIM_NO_SIM:
			return "URC_SIM_NO_SIM";
        	case MessageType.EVENT_SIM_DRIVER_ERROR:
			return "URC_SIM_DRIVER_ERROR";
        	case MessageType.EVENT_SIM_INTERNAL_RESET:
			return "URC_SIM_INTERNAL_RESET";
        	case MessageType.EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL:
			return "URC_SIM_OK_FOR_TERMINAL_PROFILE_DL";
        	case MessageType.EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL:
			return "URC_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL";
        	case MessageType.EVENT_SIM_INIT_COMPLETED_NO_PROV:
			return "URC_SIM_INIT_COMPLETED_NO_PROV";
        	case MessageType.EVENT_SIM_MEMORY_WARNING:
			return "URC_SIM_MEMORY_WARNING";
        	case MessageType.EVENT_SIM_SIM2_EVENT:
			return "URC_SIM_SIM2_EVENT";
        	case MessageType.EVENT_SIM_REAL_RESET_FAILURE:
			return "URC_SIM_REAL_RESET_FAILURE";
        	case MessageType.EVENT_SIM_CARD_ERROR:
			return "URC_SIM_CARD_ERROR";
        	case MessageType.EVENT_SIM_NO_EVENT:
			return "URC_SIM_NO_EVENT";
        	case MessageType.EVENT_SIM_GET_PERSO_NW_FAILURE:
			return "URC_SIM_GET_PERSO_NW_FAILURE";
        	case MessageType.EVENT_SIM_GET_PERSO_NW_BLOCKED:
			return "URC_SIM_GET_PERSO_NW_BLOCKED";
        	case MessageType.EVENT_SIM_REFRESH_APP_RESET:
			return "URC_SIM_REFRESH_APP_RESET";
        	case MessageType.EVENT_SIM_REFRESH_3G_SESSION_RESET:
			return "URC_SIM_REFRESH_3G_SESSION_RESET";
        	case MessageType.EVENT_SIM_APP_SELECTED:
			return "URC_SIM_APP_SELECTED";
        	case MessageType.EVENT_SIM_DEFAULT:
			return "URC_SIM_DEFAULT";
            case MessageType.EVENT_SUPS_PROCESS_USS:
            return "SUPS_PROCESS_USS";
            case MessageType.EVENT_SUPS_PROCESS_USS_CONF:
            return "SUPS_PROCESS_USS_CONF";
            case MessageType.EVENT_SUPS_USS_RES:
            return "SUPS_USS_RES";
            case MessageType.EVENT_SUPS_RELEASE_USS_IND:
            return "SUPS_RELEASE_USS_IND";
            case MessageType.EVENT_SUPS_USS_NOTIFY_IND:
            return "SUPS_USS_NOTIFY_IND";
            case MessageType.EVENT_SUPS_USS_NOTIFY_RES:
            return "SUPS_USS_NOTIFY_RES";
            case MessageType.EVENT_SUPS_RELEASE:
            return "SUPS_RELEASE";
            case MessageType.EVENT_SUPS_ABORT:
            return "SUPS_ABORT";
            case MessageType.EVENT_SUPS_ERASE:
            return "SUPS_ERASE";
            case MessageType.EVENT_SUPS_REGISTER:
            return "SUPS_REGISTER";
            case MessageType.EVENT_SUPS_REGISTER_CONF:
            return "SUPS_REGISTER_CONF";
            case MessageType.EVENT_SUPS_GET_PASSWORD_IN:
            return "SUPS_GET_PASSWORD_IN";
            case MessageType.EVENT_SUPS_GET_PASSWORD_RES:
            return "SUPS_GET_PASSWORD_RES";
            case MessageType.EVENT_SUPS_INTERROGATE:
            return "SUPS_INTERROGATE";
            case MessageType.EVENT_SUPS_INTERROGATE_CONF:
            return "SUPS_INTERROGATE_CONF";
            case MessageType.EVENT_SUPS_ACTIVATE:
            return "SUPS_ACTIVATE";
            case MessageType.EVENT_SUPS_ACTIVATE_CONF:
            return "SUPS_ACTIVATE_CONF";
            case MessageType.EVENT_SUPS_DEACTIVATE:
            return "SUPS_DEACTIVATE";
            case MessageType.EVENT_SUPS_DEACTIVATE_CONF:
            return "SUPS_DEACTIVATE_CONF";
			case MessageType.EVENT_SMS_WMS_CFG_MESSAGE_LIST:
			return "SMS_WMS_CFG_MESSAGE_LIST";
			case MessageType.EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF:
			return "SMS_WMS_CFG_GW_DOMAIN_PREF";
			case MessageType.EVENT_SMS_WMS_CFG_EVENT_ROUTES:
			return "SMS_WMS_CFG_EVENT_ROUTES";
			case MessageType.EVENT_SMS_WMS_CFG_MEMORY_STATUS:
			return "SMS_WMS_CFG_MEMORY_STATUS";
			case MessageType.EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET:
			return "SMS_WMS_CFG_MEMORY_STATUS_SET";
			case MessageType.EVENT_SMS_WMS_CFG_GW_READY:
			return "SMS_WMS_CFG_GW_READY";
			case MessageType.EVENT_SMS_WMS_READ_TEMPLATE:
			return "SMS_WMS_READ_TEMPLATE";
			case MessageType.EVENT_GET_NETWORKLIST:
			return "URC_GET_NETWORKLIST";
			case MessageType.EVENT_PHONEBOOK_READY:
			return "URC_PHONEBOOK_READY";
            case MessageType.EVENT_PHONEBOOK_MODIFIED:
            return "URC_PHONEBOOK_MODIFIED";
            case MessageType.EVENT_CM_PH:
            return "URC_CM_PH";
            case MessageType.EVENT_SMS_RECEIVED_MESSAGE:
            return "URC_SMS_RECIEVED_MESSAGE";
            default:
			return "%d (unknown)".printf( t );
        }
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_OPERATION_MODE_", cheader_filename = "msmcomm.h")]
    public enum OperationMode
    {
        RESET,
        ONLINE,
        OFFLINE
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_CHARGING_VOLTAGE_", cheader_filename = "msmcomm.h")]
    public enum UsbVoltageMode
    {
        MODE_250mA,
        MODE_500mA,
        MODE_1A
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_CHARGING_MODE_", cheader_filename = "msmcomm.h")]
    public enum ChargingMode
    {
        USB,
        INDUCTIVE
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_ENCODING_TYPE_", cheader_filename = "msmcomm.h")]
    public enum EncodingType
    {
        NONE,
        ASCII,
        BUCS2,
    }

    public string encodingTypeToString(EncodingType type)
    {
		var result = "<unknown>";
		switch (type)
		{
			case EncodingType.NONE:
				result = "NONE";
				break;
			case EncodingType.ASCII:
				result = "ASCII";
				break;
			case EncodingType.BUCS2:
				result = "BUCS2";
				break;
		}
		return result;
	}

	[CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_RESULT_", cheader_filename = "msmcomm.h")]
	public enum ResultType
	{
		NONE,
		OK,
		ERROR,
		READ_SIMBOOK_INVALID_RECORD_ID,
        SIM_BAD_STATE,
        BAD_CALL_ID,
        INVALID_AUDIO_PROFILE,
	}

	public string resultTypeToString(ResultType type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case ResultType.NONE:
				result = "RESULT_NONE";
				break;
			case ResultType.OK:
				result = "RESULT_OK";
				break;
			case ResultType.ERROR:
				result = "RESULT_ERROR";
				break;
			case ResultType.READ_SIMBOOK_INVALID_RECORD_ID:
				result = "RESULT_READ_SIMBOOK_INVALID_RECORD_ID";
				break;
            case ResultType.SIM_BAD_STATE:
                result = "RESULT_SIM_BAD_STATE";
                break;
            case ResultType.BAD_CALL_ID:
                result = "RESULT_BAD_CALL_ID";
                break;
            case ResultType.INVALID_AUDIO_PROFILE:
                result = "RESULT_INVALID_AUDIO_PROFILE";
                break;
		}
		return result;
	}

	[CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_NETWORK_MODE_", cheader_filename = "msmcomm.h")]
	public enum NetworkMode
	{
		AUTOMATIC,
		GSM,
		UMTS,
	}

	public string networkModeToString(NetworkMode type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case NetworkMode.AUTOMATIC:
				result = "NETWORK_MODE_AUTOMATIC";
				break;
			case NetworkMode.GSM:
				result = "NETWORK_MODE_GSM";
				break;
			case NetworkMode.UMTS:
				result = "NETWORK_MODE_UMTS";
				break;
		}
		return result;
	}

	[CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_PHONEBOOK_TYPE_", cheader_filename = "msmcomm.h")]
	public enum PhonebookType
	{
		NONE,
		ALL,
		MBDN,
		MBN,
		ADN,
		SDN,
		FDN,
		EFECC,
        TEST1,
	}

	public string phonebookTypeToString(PhonebookType type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case PhonebookType.NONE:
				result = "PHONEBOOK_TYPE_NONE";
				break;
			case PhonebookType.ALL:
				result = "PHONEBOOK_TYPE_ALL";
				break;
			case PhonebookType.MBDN:
				result = "PHONEBOOK_TYPE_MBDN";
				break;
			case PhonebookType.MBN:
				result = "PHONEBOOK_TYPE_MBN";
				break;
			case PhonebookType.ADN:
				result = "PHONEBOOK_TYPE_ADN";
				break;
			case PhonebookType.SDN:
				result = "PHONEBOOK_TYPE_SDN";
				break;
			case PhonebookType.FDN:
				result = "PHONEBOOK_TYPE_FDN";
				break;
			case PhonebookType.EFECC:
				result = "PHONEBOOK_TYPE_EFECC";
				break;
            case PhonebookType.TEST1:
                result = "PHONEBOOK_TYPE_TEST1";
                break;
		}
		return result;
	}

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_CALL_TYPE_", cheader_filename = "msmcomm.h")]
	public enum CallType
	{
		NONE,
		AUDIO,
        DATA,
	}

	public string callTypeToString(CallType type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case CallType.NONE:
				result = "CALL_TYPE_NONE";
				break;
			case CallType.AUDIO:
				result = "CALL_TYPE_AUDIO";
				break;
			case CallType.DATA:
				result = "CALL_TYPE_DATA";
				break;
		}
		return result;
	}

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_SIM_", cheader_filename = "msmcomm.h")]
    public enum SimPinType
    {
        PIN_NONE,
        PIN_1,
        PIN_2,
    }

    public string simPinTypeToString(SimPinType type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case SimPinType.PIN_NONE:
				result = "SIM_PIN_NONE";
				break;
			case SimPinType.PIN_1:
				result = "SIM_PIN_1";
				break;
			case SimPinType.PIN_2:
				result = "SIM_PIN_2";
				break;
		}
		return result;
	}

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_SIM_INFO_FIELD_TYPE_", cheader_filename = "msmcomm.h")]
    public enum SimInfoFieldType
    {
        NONE,
        MSISDN,
        IMSI,
    }

    public string simInfoTypeToString(SimInfoFieldType type)
	{
		var result = "<unknown>";
		switch (type)
		{
			case SimInfoFieldType.NONE:
				result = "SIM_INFO_FIELD_TYPE_NONE";
				break;
			case SimInfoFieldType.IMSI:
				result = "SIM_INFO_FIELD_TYPE_IMSI";
				break;
			case SimInfoFieldType.MSISDN:
				result = "SIM_INFO_FIELD_TYPE_MSISDN";
				break;
		}
		return result;
	}
    
    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_", cheader_filename = "msmcomm.h")]
    public enum ChangedFieldType
    {
        INVALID,
        SID,
        NID,
        PACKET_ZONE,
        REGISTRATION_ZONE,
        BASESTATION_P_REV,
        SERVICE_DOMAIN,
        CONCURRENT_SERVICES_SUPPORTED,
        P_REV_IN_USE,
        SERVING_STATUS,
        SYSTEM_SERVICE_CAPABILITY,
        SYSTEM_MODE,
        ROADMING_STATUS,
        SYSTEM_ID,
        SERVICE_INDICATOR,
        MOBILITY_MANAGEMENT,
        HDR,
        SIM_CARD_STATUS,
        PLMN,
        PS_DATA_SUSPEND_MASK,
        UZ,
        BCMS,
        BASE_STATION_PARAMETERS_CHANGED,
        ORIGINATION_STATUS,
    }
    
    public string changedFieldTypeToString(ChangedFieldType type)
	{
		var result = "<unknown>";
		switch (type)
		{
            case ChangedFieldType.INVALID:
                result = "INVALID";
                break;
            case ChangedFieldType.NID:
                result = "NID";
                break;
            case ChangedFieldType.SID:
                result = "SID";
                break;
            case ChangedFieldType.PACKET_ZONE:
                result = "PACKET_ZONE";
                break;
            case ChangedFieldType.REGISTRATION_ZONE:
                result = "REGISTRATION_ZONE";
                break;
            case ChangedFieldType.BASESTATION_P_REV:
                result = "INVALID";
                break;
            case ChangedFieldType.SERVICE_DOMAIN:
                result = "SERVICE_DOMAIN";
                break;
            case ChangedFieldType.CONCURRENT_SERVICES_SUPPORTED:
                result = "CONCURRENT_SERVICES_SUPPORTED";
                break;
            case ChangedFieldType.P_REV_IN_USE:
                result = "P_REV_IN_USE";
                break;
            case ChangedFieldType.SERVING_STATUS:
                result = "SERVING_STATUS";
                break;
            case ChangedFieldType.SYSTEM_SERVICE_CAPABILITY:
                result = "SYSTEM_SERVICE_CAPABILITY";
                break;
            case ChangedFieldType.SYSTEM_MODE:
                result = "SYSTEM_MODE";
                break;
            case ChangedFieldType.ROADMING_STATUS:
                result = "ROADMING_STATUS";
                break;
            case ChangedFieldType.SYSTEM_ID:
                result = "SYSTEM_ID";
                break;
            case ChangedFieldType.SERVICE_INDICATOR:
                result = "SERVICE_INDICATOR";
                break;
            case ChangedFieldType.MOBILITY_MANAGEMENT:
                result = "MOBILITY_MANAGEMENT";
                break;
            case ChangedFieldType.HDR:
                result = "HDR";
                break;
            case ChangedFieldType.SIM_CARD_STATUS:
                result = "SIM_CARD_STATUS";
                break;
            case ChangedFieldType.PLMN:
                result = "PLMN";
                break;
            case ChangedFieldType.PS_DATA_SUSPEND_MASK:
                result = "PS_DATA_SUSPEND_MASK";
                break;
            case ChangedFieldType.UZ:
                result = "UZ";
                break;
            case ChangedFieldType.BCMS:
                result = "INVALID";
                break;
            case ChangedFieldType.BASE_STATION_PARAMETERS_CHANGED:
                result = "BASE_STATION_PARAMETERS_CHANGED";
                break;
            case ChangedFieldType.ORIGINATION_STATUS:
                result = "ORIGINATION_STATUS";
                break;
        }
		return result;
	}

	// FIXME public enum ErrorType ...

    [CCode (cname = "msmcomm_response_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ResponseHandlerCb(MessageType event, Message message);
    [CCode (cname = "msmcomm_write_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void WriteHandlerCb(uint8[] data);
    [CCode (cname = "msmcomm_read_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ReadHandlerCb(uint8[] data);
    [CCode (cname = "msmcomm_network_state_info_changed_field_type_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ChangedFieldTypeCb(Message message, ChangedFieldType type);
    // FIXME
	//[CCode (cname = "msmcomm_error_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    // public delegate void ErrorHandlerCb(ErrorType error, void *data);

    [CCode (cname = "msmcomm_check_hci_version", cheader_filename = "msmcomm.h")]
    public bool checkHciVersion(uint version);

    [Compact]
    [CCode (cname = "struct msmcomm_context", free_function = "msmcomm_shutdown", cheader_filename = "msmcomm.h")]
    public class Context
    {
        [CCode (cname = "msmcomm_new")]
        public Context();

        [CCode (cname = "msmcomm_read_from_modem")]
        public bool readFromModem();

        [CCode (cname = "msmcomm_process_data")]
        public bool processData(void *data, int len);

        [CCode (cname = "msmcomm_send_message")]
        public void sendMessage(Message message);

        [CCode (cname = "msmcomm_register_response_handler")]
        public void registerResponseHandler(ResponseHandlerCb responseHandlerCb);

        [CCode (cname = "msmcomm_register_write_handler")]
        public void registerWriteHandler(WriteHandlerCb writeHandlerCb);

        [CCode (cname = "msmcomm_register_read_handler")]
        public void registerReadHandler(ReadHandlerCb readHandlerCb);

		// FIXME
        //[CCode (cname = "msmcomm_register_error_handler")]
        //public void registerErrorHandler(ErrorHandlerCb errorHandlerCb);
    }

    [Compact]
    [CCode (cname = "struct msmcomm_message", free_function = "", copy_function = "msmcomm_message_make_copy", cheader_filename = "msmcomm.h")]
    public abstract class Message
    {
        [CCode (cname = "msmcomm_create_message")]
        public Message(MessageType type);

        public int size {
            [CCode (cname = "msmcomm_message_get_size")]
            get;
        }

        public MessageType type {
            [CCode (cname = "msmcomm_message_get_type")]
            get;
        }

        public uint32  index {
            [CCode (cname = "msmcomm_message_get_ref_id")]
            get;
            [CCode (cname = "msmcomm_message_set_ref_id")]
            set;
        }

        public ResultType result {
			[CCode (cname = "msmcomm_message_get_result")]
			get;
		}

        public MessageClass class {
            [CCode (cname = "msmcomm_message_get_class")]
            get;
        }

        [CCode (cname = "msmcomm_message_make_copy")]
        public Message copy();

        public string to_string()
        {
            var str = "[MSM] type %s rc %s ref %02x len %d : %s".printf( messageClassToString(class), resultTypeToString(result), index, size, Msmcomm.messageTypeToString( type ) );
            var details = "";

            switch ( type )
            {
                case Msmcomm.MessageType.RESPONSE_GET_IMEI:
                    var msg = (Msmcomm.Reply.GetImei) this.copy();
                    details = @"IMEI = $(msg.imei)";
                    break;
                case Msmcomm.MessageType.RESPONSE_GET_FIRMWARE_INFO:
                    var msg = (Msmcomm.Reply.GetFirmwareInfo) this.copy();
                    details = @"FIRMWARE = $(msg.info) | HCI = $(msg.hci)";
                    break;
                case Msmcomm.MessageType.RESPONSE_CM_CALL:
                    var msg = (Msmcomm.Reply.Call) this.copy();
                    details = @"cmd = $(msg.cmd_type)";
                    break;
                case Msmcomm.MessageType.RESPONSE_CHARGER_STATUS:
                    var msg = (Msmcomm.Reply.ChargerStatus) this.copy();
                    string mode = "<unknown>", voltage = "<unknown>";

                    switch ( msg.mode )
                    {
                        case Msmcomm.ChargingMode.USB:
                            mode = "USB";
                            break;
                        case Msmcomm.ChargingMode.INDUCTIVE:
                            mode = "INDUCTIVE";
                            break;
                        default:
                            mode = "UNKNOWN";
                            break;
                    }

                    switch ( msg.voltage )
                    {
                        case Msmcomm.UsbVoltageMode.MODE_250mA:
                            voltage = "250mA";
                            break;
                        case Msmcomm.UsbVoltageMode.MODE_500mA:
                            voltage = "500mA";
                            break;
                        case Msmcomm.UsbVoltageMode.MODE_1A:
                            voltage = "1A";
                            break;
                        default:
                            voltage = "UNKNOWN";
                            break;
                    }

                    details = @"mode = $(mode) voltage = $(voltage)";
                    break;
                case Msmcomm.MessageType.EVENT_NETWORK_STATE_INFO:
					var msg = (Msmcomm.Unsolicited.NetworkStateInfo) this.copy();
					if (msg.only_rssi_update) {
						details += @"rssi = $(msg.rssi) ";
					}
					else {
						details = @"new_value = $(msg.new_value) ";
						details += @"change_field = $(msg.change_field) ";
						details += @"operator_name = $(msg.operator_name) ";
						details += @"rssi = $(msg.rssi) ";
						details += @"ecio = $(msg.ecio) ";
						details += @"service_domain = $(msg.service_domain) ";
						details += @"service_capabilitiy = $(msg.service_capability) ";
						details += @"gprs_attached = $(msg.gprs_attached) ";
						details += @"roam = $(msg.roam)";
                    
                        /*
                        msg.traceChanges( ( msg, type ) => {
                            unowned Msmcomm.Unsolicited.NetworkStateInfo networkStateInfoMessage = 
                                (Msmcomm.Unsolicited.NetworkStateInfo) msg;
                            details += @" changed_field [ type =  $(changedFieldTypeToString(type)) ";
                            details += "value = %02x ]".printf( networkStateInfoMessage.new_value );
                        });
                        */
					}
					break;
				case Msmcomm.MessageType.EVENT_SMS_WMS_READ_TEMPLATE:
					var msg = (Msmcomm.Unsolicited.SMS.WmsReadTemplate) this.copy();
					details = @"digit_mode = $(msg.digit_mode) ";
					details += @"number_mode = $(msg.number_mode) ";
					details += @"number_type = $(msg.number_type) ";
					details += @"number_plan = $(msg.number_plan) ";
					break;
				case Msmcomm.MessageType.RESPONSE_PHONEBOOK:
					var msg = (Msmcomm.Reply.Phonebook) this.copy();
					details = @"book_type = $(phonebookTypeToString(msg.book_type)) ";
					details += @"position = $(msg.position) ";
					details += @"number = '$(msg.number)' ";
					details += @"title = '$(msg.title)' ";
					details += @"encoding_type = $(encodingTypeToString(msg.encoding_type))";
					break;
				case Msmcomm.MessageType.EVENT_GET_NETWORKLIST:
					var msg = (Msmcomm.Unsolicited.GetNetworkList) this.copy();
					var count = msg.network_count;
					details = @"network_count = $(count) ";
					for (int n=0; n<count; n++) {
						uint plmn = msg.getPlmn(n);
						string name = msg.getNetworkName(n);
						details += @"[ plmn = $(plmn) ";
						details += @"name = '$(name)' ] ";
					}
					break;
				case Msmcomm.MessageType.RESPONSE_CM_PH:
					var msg = (Msmcomm.Reply.CmPh) this.copy();
					details = @"result = $(msg.result)";
					break;
				case Msmcomm.MessageType.EVENT_PHONEBOOK_READY:
					var msg = (Msmcomm.Unsolicited.PhonebookReady) this.copy();
					details = @"book_type = $(phonebookTypeToString(msg.book_type))";
					break;
				case Msmcomm.MessageType.RESPONSE_GET_PHONEBOOK_PROPERTIES:
					var msg= (Msmcomm.Reply.GetPhonebookProperties) this.copy();
					details = @"slot_count = $(msg.slot_count) slots_used = $(msg.slots_used) ";
					details += @"max_chars_per_title = $(msg.max_chars_per_title) max_chars_per_number = $(msg.max_chars_per_number)";
					break;
				case Msmcomm.MessageType.EVENT_CALL_INCOMMING:
				case Msmcomm.MessageType.EVENT_CALL_ORIGINATION:
				case Msmcomm.MessageType.EVENT_CALL_CONNECT:
				case Msmcomm.MessageType.EVENT_CALL_END:
				case Msmcomm.MessageType.EVENT_CALL_STATUS:
					var msg = (Msmcomm.Unsolicited.CallStatus) this.copy();
					details = @"caller_id = '$(msg.number)' ";
					details += @"call_id = $(msg.id) ";
                    details += @"call_type = $(callTypeToString(msg.type)) ";
					details += @"reject_type = $(msg.reject_type) ";
					details += @"reject_value = $(msg.reject_value) ";
                    break;
                case Msmcomm.MessageType.EVENT_PHONEBOOK_MODIFIED:
                    var msg = (Msmcomm.Unsolicited.PhonebookModified) this.copy();
                    details = @"book_type = $(phonebookTypeToString(msg.book_type)) ";
                    details += @"position = $(msg.position)";
                    break;
                case Msmcomm.MessageType.RESPONSE_SIM:
                    var msg = (Msmcomm.Reply.Sim) this.copy();
                    details = @"field_type = $(simInfoTypeToString(msg.field_type)) ";
                    if (msg.field_data != null)
                        details += @"field_data = '$(msg.field_data)'";
                    break;
                case Msmcomm.MessageType.RESPONSE_AUDIO_MODEM_TUNING_PARAMS:
                    var msg = (Msmcomm.Reply.AudioModemTuningParams) this.copy();
                    details = "params [ ";
                    var params = msg.params;
                    for (var n = 0; n < params.length; n++)
                        details += "%02x ".printf(params[n]);
                    details += "]";
                    break;
                case Msmcomm.MessageType.EVENT_CM_PH:
                    var msg = (Msmcomm.Unsolicited.CmPh) this.copy();
                    var count = msg.plmn_count;
                    details = @"plmn_count = $(count) plmns [ ";
                    for (var n = 0; n < count; n++)
                    {
                        var plmn = msg.plmn(n);
                        details += @"$(plmn) ";
                    }
                    details += " ]";
                    break;
                default:
                    break;
            }

            return @"$str [ %s ]".printf( details );
        }
    }

    namespace Command
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChangeOperationMode : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public ChangeOperationMode(MessageType t = MessageType.COMMAND_CHANGE_OPERATION_MODE);

            public OperationMode mode
            {
                [CCode (cname = "msmcomm_message_change_operation_mode_set_operation_mode")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Charging : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public Charging(MessageType t = MessageType.COMMAND_CHARGING);

            public UsbVoltageMode voltage {
                [CCode (cname = "msmcomm_message_charging_set_voltage")]
                set;
            }

            public ChargingMode mode {
                [CCode (cname = "msmcomm_message_charging_set_mode")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetImei : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetImei(MessageType t = MessageType.COMMAND_GET_IMEI);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetChargerStatus : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetChargerStatus(MessageType t = MessageType.COMMAND_GET_CHARGER_STATUS);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetFirmwareInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetFirmwareInfo(MessageType t = MessageType.COMMAND_GET_FIRMWARE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetPhoneStateInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetPhoneStateInfo(MessageType t = MessageType.COMMAND_GET_PHONE_STATE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class TestAlive : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public TestAlive(MessageType t = MessageType.COMMAND_TEST_ALIVE);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class VerifyPin : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public VerifyPin(MessageType t = MessageType.COMMAND_VERIFY_PIN);

            public string pin {
                [CCode (cname = "msmcomm_message_verify_pin_set_pin")]
                set;
            }

            public SimPinType pin_type {
                [CCode (cname = "msmcomm_message_verify_pin_set_pin_type")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class EndCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public EndCall(MessageType t = MessageType.COMMAND_END_CALL);

            public uint8 call_id {
                [CCode (cname = "msmcomm_message_end_call_set_call_id")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class AnswerCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public AnswerCall(MessageType t = MessageType.COMMAND_ANSWER_CALL);

            public uint8 call_id {
                [CCode (cname = "msmcomm_message_answer_call_set_call_id")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ManageCalls : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public ManageCalls(MessageType t = MessageType.COMMAND_MANAGE_CALLS);

            [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_MANAGE_CALLS_COMMAND_TYPE_", cheader_filename = "msmcomm.h")]
            public enum CommandType
            {
                DROP_ALL_OR_SEND_BUSY,
                DROP_ALL_AND_ACCEPT_WAITING_OR_HELD,
                DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
                HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD,
                HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
                ACTIVATE_HELD,
                DROP_SELF_AND_CONNECT_ACTIVE,
            }

            public CommandType command_type
            {
                [CCode (cname = "msmcomm_message_manage_calls_set_command_type")]
                set;
            }

            public uint8 call_id {
                [CCode (cname = "msmcomm_message_manage_calls_set_call_id")]
                set;
            }
        }


        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class DialCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public DialCall(MessageType t = MessageType.COMMAND_DIAL_CALL);

            [CCode (cname = "msmcomm_message_dial_call_set_caller_id")]
            private void _setCallerId(string callerId, uint length);

            public string number 
            {
                set
                {
                    _setCallerId(value, (uint)value.length);
                }
            }

            public bool block {
                [CCode (cname = "msmcomm_message_dial_call_set_block")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SetSystemTime : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public SetSystemTime(MessageType t = MessageType.COMMAND_SET_SYSTEM_TIME);

			[CCode (cname = "msmcomm_message_set_system_time_set")]
			public void setData(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset);
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class RssiStatus : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public RssiStatus(MessageType t = MessageType.COMMAND_RSSI_STATUS);

			[CCode (cname = "msmcomm_message_rssi_status_set_status")]
			private void _setStatus(uint8 status);

			public bool status {
				public set {
					if (value) _setStatus(1);
					else _setStatus(0);
				}
			}
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ReadPhonebook : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public ReadPhonebook(MessageType t = MessageType.COMMAND_READ_PHONEBOOK);


			public PhonebookType book_type {
				[CCode (cname = "msmcomm_message_read_phonebook_set_book_type")]
				set;
			}

			public uint8 position {
				[CCode (cname = "msmcomm_message_read_phonebook_set_position")]
				set;
			}
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class WritePhonebook : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public WritePhonebook(MessageType t = MessageType.COMMAND_WRITE_PHONEBOOK);

            [CCode (cname = "msmcomm_message_write_phonebook_set_number")]
            private void _setNumber(string number, uint length);

            [CCode (cname = "msmcomm_message_write_phonebook_set_title")]
            private void _setTitle(string title, uint length);

            public string number {
                set {
                    var number = value;
                    _setNumber(number, (uint)number.length);
                }
            }

            public string title {
                set {
                    var title = value;
                    _setTitle(title, (uint)title.length);
                }
            }

            public PhonebookType book_type {
                [CCode (cname = "msmcomm_message_write_phonebook_set_book_type")]
                set;
            }
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class DeletePhonebook : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public DeletePhonebook(MessageType t = MessageType.COMMAND_DELETE_PHONEBOOK);

            public uint8 position {
                [CCode (cname = "msmcomm_message_delete_phonebook_set_position")]
                set;
            }

            public PhonebookType book_type {
                [CCode (cname = "msmcomm_message_delete_phonebook_set_book_type")]
                set;
            }
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetNetworkList : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public GetNetworkList(MessageType t = MessageType.COMMAND_GET_NETWORKLIST);
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SetModePreference : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public SetModePreference(MessageType t = MessageType.COMMAND_SET_MODE_PREFERENCE);

			public NetworkMode mode {
				[CCode (cname = "msmcomm_message_set_mode_preference_status_set_mode")]
				set;
			}
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetPhonebookProperties : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public GetPhonebookProperties(MessageType t = MessageType.COMMAND_GET_PHONEBOOK_PROPERTIES);

			public PhonebookType book_type {
				[CCode (cname = "msmcomm_message_get_phonebook_properties_set_book_type")]
				set;
			}
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChangePin : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public ChangePin(MessageType t = MessageType.COMMAND_CHANGE_PIN);

            [CCode (cname = "msmcomm_message_change_pin_set_new_pin")]
            private void _setNewPin(string new_pin, uint len);

            [CCode (cname = "msmcomm_message_change_pin_set_old_pin")]
            private void _setOldPin(string old_pin, uint len);

			public string new_pin {
				set {
                    var pin = value;
                    _setNewPin(pin, (uint)pin.length);
                }
			}

            public string old_pin {
				set {
                    var pin = value;
                    _setOldPin(pin, (uint)pin.length);
                }
			}
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class EnablePin : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public EnablePin(MessageType t = MessageType.COMMAND_ENABLE_PIN);

            public string pin {
                [CCode (cname = "msmcomm_message_enable_pin_set_pin")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class DisablePin : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public DisablePin(MessageType t = MessageType.COMMAND_DISABLE_PIN);

            public string pin {
                [CCode (cname = "msmcomm_message_disable_pin_set_pin")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SimInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public SimInfo(MessageType t = MessageType.COMMAND_SIM_INFO);

            public SimInfoFieldType field_type {
                [CCode (cname = "msmcomm_message_sim_info_set_field_type")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetAudioModemTuningParams : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetAudioModemTuningParams(MessageType t = MessageType.COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SetAudioProfile : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public SetAudioProfile(MessageType t = MessageType.COMMAND_SET_AUDIO_PROFILE);

            public uint8 class {
                [CCode (cname = "msmcomm_message_set_audio_profile_set_class")]
                set;
            }

            public uint8 sub_class {
                [CCode (cname = "msmcomm_message_set_audio_profile_set_sub_class")]
                set;
            }
        }
        
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SmsAcknowledgeIncommingMessage : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public SmsAcknowledgeIncommingMessage(MessageType t = MessageType.COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE);
        }
        
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SmsGetSmsCenterNumber : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public SmsGetSmsCenterNumber(MessageType t = MessageType.COMMAND_SMS_GET_SMS_CENTER_NUMBER);
        }
    }

    namespace Reply
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetFirmwareInfo : Message
        {
            public string info {
                [CCode (cname = "msmcomm_resp_get_firmware_info_get_info")]
                get;
            }

            public uint8 hci {
                [CCode (cname = "msmcomm_resp_get_firmware_info_get_hci_version")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class TestAlive : Message
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetImei : Message
        {
            public string imei {
                [CCode (cname = "msmcomm_resp_get_imei_get_imei")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Charging : Message
        {
            public UsbVoltageMode voltage {
                [CCode (cname = "msmcomm_resp_charging_get_voltage")]
                get;
            }

            public ChargingMode mode {
                [CCode (cname = "msmcomm_resp_charging_get_mode")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChargerStatus : Message
        {
            public UsbVoltageMode voltage {
                [CCode (cname = "msmcomm_resp_charger_status_get_voltage")]
                get;
            }

            public ChargingMode mode {
                [CCode (cname = "msmcomm_resp_charger_status_get_mode")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Call : Message
        {
            public uint16 cmd_type {
                [CCode (cname = "msmcomm_resp_cm_call_get_cmd_type")]
                get;
            }
        }

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class Phonebook : Message
		{
			public PhonebookType book_type {
				[CCode (cname = "msmcomm_resp_phonebook_get_book_type")]
				get;
			}

			public uint8 position {
				[CCode (cname = "msmcomm_resp_phonebook_get_position")]
				get;
			}

			public string number {
				[CCode (cname = "msmcomm_resp_phonebook_get_number")]
				get;
			}

			public string title {
				[CCode (cname = "msmcomm_resp_phonebook_get_title")]
				get;
			}

			public EncodingType encoding_type {
				[CCode (cname = "msmcomm_resp_phonebook_get_encoding_type")]
				get;
			}

            public uint8 modify_id {
                [CCode (cname = "msmcomm_resp_phonebook_get_modify_id")]
                get;
            }
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class CmPh : Message
		{
			public uint8 result {
				[CCode (cname = "msmcomm_resp_cm_ph_get_result")]
				get;
			}
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class GetPhonebookProperties : Message
		{
			public uint8 slot_count {
				[CCode (cname = "msmcomm_resp_get_phonebook_properties_get_slot_count")]
				get;
			}

			public uint8 slots_used {
				[CCode (cname = "msmcomm_resp_get_phonebook_properties_get_slots_used")]
				get;
			}

			public uint8 max_chars_per_title {
				[CCode (cname = "msmcomm_resp_get_phonebook_properties_get_max_chars_per_title")]
				get;
			}

			public uint8 max_chars_per_number {
				[CCode (cname = "msmcomm_resp_get_phonebook_properties_get_max_chars_per_number")]
				get;
			}
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class Sim : Message
		{
            public string field_data {
				[CCode (cname = "msmcomm_resp_sim_get_field_data")]
				get;
			}

            public SimInfoFieldType field_type {
                [CCode (cname = "msmcomm_resp_sim_info_get_field_type")]
                get;
            }
		}

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class AudioModemTuningParams : Message
		{
            public uint8[] params {
				[CCode (cname = "msmcomm_resp_audio_modem_tuning_params_get_params")]
				get;
			}
		}
    }

    namespace Unsolicited
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class PowerState : Message
        {
            public uint8 state
            {
                [CCode (cname = "msmcomm_event_power_state_get_state")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChargerStatus : Message
        {
            
            public uint voltage
            {
                [CCode (cname = "msmcomm_event_charger_status_get_voltage")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public abstract class CallStatus : Message
        {
            public string number
            {
				[CCode (cname = "msmcomm_event_call_status_get_caller_id")]
				get;
            }

            public CallType type {
                [CCode (cname = "msmcomm_event_call_status_get_call_type")]
				get;
            }

            public uint id {
				[CCode (cname = "msmcomm_event_call_status_get_call_id")]
				get;
			}

            public uint reject_type {
				[CCode (cname = "msmcomm_event_call_status_get_reject_type")]
				get;
			}

            public uint reject_value {
				[CCode (cname = "msmcomm_event_call_status_get_reject_value")]
				get;
			}

        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class CallIncoming : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class CallConnect : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class CallEnd : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class CallOrigination : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetNetworkList : Message
        {
			public uint network_count {
				[CCode (cname = "msmcomm_event_get_networklist_get_network_count")]
				get;
			}

			[CCode (cname = "msmcomm_event_get_networklist_get_plmn")]
			public uint getPlmn(int nnum);

			[CCode (cname = "msmcomm_event_get_networklist_get_network_name")]
			public string getNetworkName(int nnum);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class NetworkStateInfo : Message
        {
			public bool only_rssi_update {
				[CCode (cname = "msmcomm_event_network_state_info_is_only_rssi_update")]
				get;
			}
			public uint change_field {
				[CCode (cname = "msmcomm_event_network_state_info_get_change_field")]
				get;
			}

			public uint8 new_value {
				[CCode (cname = "msmcomm_event_network_state_info_get_new_value")]
				get;
			}

            [CCode (cname = "msmcomm_event_network_state_info_trace_changes")]
            public void traceChanges(ChangedFieldTypeCb type_handler);

			public string operator_name {
				[CCode (cname = "msmcomm_event_network_state_info_get_operator_name")]
				get;
			}

            public uint16 rssi {
				[CCode (cname = "msmcomm_event_network_state_info_get_rssi")]
				get;
			}

			public uint16 ecio {
				[CCode (cname = "msmcomm_event_network_state_info_get_ecio")]
				get;
			}

			public uint8 service_domain {
				[CCode (cname = "msmcomm_event_network_state_info_get_service_domain")]
				get;
			}

			public uint8 service_capability {
				[CCode (cname = "msmcomm_event_network_state_info_get_service_capability")]
				get;
			}

			public uint8 gprs_attached {
				[CCode (cname = "msmcomm_event_network_state_info_get_gprs_attached")]
				get;
			}

			public uint16 roam {
				[CCode (cname = "msmcomm_event_network_state_info_get_roam")]
				get;
			}
		}

		[Compact]
		[CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class PhonebookReady : Message
		{
			public PhonebookType book_type {
				[CCode (cname = "msmcomm_event_phonebook_ready_get_book_type")]
				get;
			}
		}

        [Compact]
		[CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class PhonebookModified : Message
		{
			public PhonebookType book_type {
				[CCode (cname = "msmcomm_event_phonebook_modified_get_book_type")]
				get;
			}

            public uint8 position {
				[CCode (cname = "msmcomm_event_phonebook_modified_get_position")]
				get;
			}
		}

        [Compact]
		[CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
		public class CmPh : Message
		{
			public uint8 plmn_count {
				[CCode (cname = "msmcomm_event_cm_ph_get_plmn_count")]
				get;
			}

            [CCode (cname = "msmcomm_event_cm_ph_get_plmn")]
            public uint plmn(uint n);
		}

		namespace SMS
		{
			[Compact]
			[CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
			public class WmsReadTemplate : Message
			{
				public uint8 digit_mode {
					[CCode (cname = "msmcomm_event_sms_wms_read_template_get_digit_mode")]
					get;
				}

				public uint8 number_mode {
					[CCode (cname = "msmcomm_event_sms_wms_read_template_get_number_mode")]
					get;
				}

				public uint8 number_type {
					[CCode (cname = "msmcomm_event_sms_wms_read_template_get_number_type")]
					get;
				}

				public uint8 number_plan {
					[CCode (cname = "msmcomm_event_sms_wms_read_template_get_number_plan")]
					get;
				}
			}
            
            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public class SmsRecieved : Message
            {
                public string sender_number 
                {
                    [CCode (cname = "msmcomm_event_sms_recieved_message_get_sender")]
                    get;
                }
                
                public uint8[] pdu 
                {
                    [CCode (cname = "msmcomm_event_sms_recieved_message_get_pdu")]
                    get;
                }
            }
            
		} /* namespace SMS */
    } /* namespace Unsolicited */
}

