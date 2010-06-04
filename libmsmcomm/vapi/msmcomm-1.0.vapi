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

// FIXME: copy does not seem to work
// FIXME: Change 'EVENT' to 'URC' to match telephony taxonomy
// FIXME: Map properties as such

[CCode (cheader_filename = "msmcomm.h")]
namespace Msmcomm
{
    [Compact]
    [CCode (cname = "struct msmcomm_frame", free_function = "msmcomm_frame_free", cheader_filename = "msmcomm.h")]
    public class LowLevel.Frame
    {
        [CCode (cname = "msmcomm_frame_new")]
        public Frame();

        [CCode (cname = "msmcomm_frame_new_from_buffer")]
        public Frame.new_from_buffer(uint8 *buffer, uint size);

        public uint8[] payload {
            [CCode (cname = "msmcomm_frame_set_payload")]
            set;
            [CCode (cname = "msmcomm_frame_get_payload")]
            get;
        }

        public uint payload_size {
            [CCode (cname = "msmcomm_frame_get_payload_length")]
            get;
        }

        public uint8 addr {
            [CCode (cname = "msmcomm_frame_get_address")]
            get;
            [CCode (cname = "msmcomm_frame_set_address")]
            set;
        }

        public uint8 type {
            [CCode (cname = "msmcomm_frame_get_type")]
            get;
            [CCode (cname = "msmcomm_frame_set_type")]
            set;
        }

        public uint8 seq {
            [CCode (cname = "msmcomm_frame_get_sequence_nr")]
            get;
            [CCode (cname = "msmcomm_frame_set_sequence_nr")]
            set;
        }

        public uint8 ack {
            [CCode (cname = "msmcomm_frame_get_acknowledge_nr")]
            get;
            [CCode (cname = "msmcomm_frame_set_acknowledge_nr")]
            set;
        }

        public uint8 is_valid {
            [CCode (cname = "msmcomm_frame_is_valid")]
            get;
        }
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_COMMAND_", cheader_filename = "msmcomm.h")]
    public enum CommandType
    {
        CHANGE_OPERATION_MODE,
        GET_IMEI,
        GET_FIRMWARE_INFO,
        TEST_ALIVE,
        GET_PHONE_STATE_INFO,
        VERIFY_PIN,
        GET_VOICEMAIL_NR,
        GET_LOCATION_PRIV_PREF,
        ANSWER_CALL,
        SET_AUDIO_PROFILE,
        END_CALL,
        GET_CHARGER_STATUS,
        CHARGING,
        DIAL_CALL,
        SET_SYSTEM_TIME,
        RSSI_STATUS,
        READ_PHONEBOOK,
        GET_NETWORKLIST,
        SET_MODE_PREFERENCE,
        GET_PHONEBOOK_PROPERTIES,
        WRITE_PHONEBOOK,
        DELETE_PHONEBOOK,
        CHANGE_PIN,
        ENABLE_PIN,
        DISABLE_PIN,
        SIM_INFO,
        GET_AUDIO_MODEM_TUNING_PARAMS,
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_RESPONSE_", cheader_filename = "msmcomm.h")]
    public enum ResponseType
    {
        TEST_ALIVE,
        GET_FIRMWARE_INFO,
        GET_IMEI,
        PDSM_PD_GET_POS,
        PDSM_PD_END_SESSION,
        PA_SET_PARAM,
        LCS_AGENT_CLIENT_RSP,
        XTRA_SET_DATA,
        SIM,
        GET_VOICEMAIL_NR,
        SOUND,
        CM_CALL,
        CHARGER_STATUS,
        CHARGING,
        CM_PH,
        SET_SYSTEM_TIME,
        RSSI_STATUS,
        PHONEBOOK,
        GET_PHONEBOOK_PROPERTIES,
        AUDIO_MODEM_TUNING_PARAMS,
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_EVENT_", cheader_filename = "msmcomm.h")]
    public enum EventType
    {
        RESET_RADIO_IND,
        CHARGER_STATUS,
        OPERATION_MODE,
        CM_PH_INFO_AVAILABLE,
        NETWORK_STATE_INFO,
        PDSM_PD_DONE,
        PD_POSITION_DATA,
        PD_PARAMETER_CHANGE,
        PDSM_LCS,
        PDSM_XTRA,
        CALL_STATUS,
        CALL_INCOMMING,
        CALL_ORIGINATION,
        CALL_CONNECT,
        CALL_END,
        SIM_INSERTED,
        SIM_PIN1_VERIFIED,
        SIM_PIN1_BLOCKED,
        SIM_PIN1_UNBLOCKED,
        SIM_PIN1_ENABLED,
        SIM_PIN1_DISABLED,
        SIM_PIN1_CHANGED,
        SIM_PIN1_PERM_BLOCKED,
        SIM_PIN2_VERIFIED,
        SIM_PIN2_BLOCKED,
        SIM_PIN2_UNBLOCKED,
        SIM_PIN2_ENABLED,
        SIM_PIN2_DISABLED,
        SIM_PIN2_CHANGED,
        SIM_PIN2_PERM_BLOCKED,
        SIM_REFRESH_RESET,
        SIM_REFRESH_INIT,
        SIM_REFRESH_INIT_FCN,
        SIM_REFRESH_FAILED,
        SIM_FDN_ENABLE,
        SIM_FDN_DISABLE,
        SIM_ILLEGAL,
        SIM_REMOVED,
        SIM_NO_SIM_EVENT,
        SIM_NO_SIM,
        SIM_DRIVER_ERROR,
        SIM_INTERNAL_RESET,
        SIM_OK_FOR_TERMINAL_PROFILE_DL,
        SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL,
        SIM_INIT_COMPLETED_NO_PROV,
        SIM_MEMORY_WARNING,
        SIM_SIM2_EVENT,
        SIM_REAL_RESET_FAILURE,
        SIM_CARD_ERROR,
        SIM_NO_EVENT,
        SIM_GET_PERSO_NW_FAILURE,
        SIM_GET_PERSO_NW_BLOCKED,
        SIM_REFRESH_APP_RESET,
        SIM_REFRESH_3G_SESSION_RESET,
        SIM_APP_SELECTED,
        SIM_DEFAULT,
        SUPS_PROCESS_USS,
        SUPS_PROCESS_USS_CONF,
        SUPS_USS_RES,
        SUPS_RELEASE_USS_IND,
        SUPS_USS_NOTIFY_IND,
        SUPS_USS_NOTIFY_RES,
        SUPS_RELEASE,
        SUPS_ABORT,
        SUPS_ERASE,
        SUPS_REGISTER,
        SUPS_REGISTER_CONF,
        SUPS_GET_PASSWORD_IN,
        SUPS_GET_PASSWORD_RES,
        SUPS_INTERROGATE,
        SUPS_INTERROGATE_CONF,
        SUPS_ACTIVATE,
        SUPS_ACTIVATE_CONF,
        SUPS_DEACTIVATE,
        SUPS_DEACTIVATE_CONF,
        SMS_WMS_CFG_MESSAGE_LIST,
        SMS_WMS_CFG_GW_DOMAIN_PREF,
        SMS_WMS_CFG_EVENT_ROUTES,
        SMS_WMS_CFG_MEMORY_STATUS,
        SMS_WMS_CFG_MEMORY_STATUS_SET,
        SMS_WMS_CFG_GW_READY,
        SMS_WMS_READ_TEMPLATE,
        GET_NETWORKLIST,
        PHONEBOOK_READY,
        PHONEBOOK_MODIFIED,
        CM_PH,
    }

    public string eventTypeToString( int t )
    {
        switch ( t )
        {
            case 0:
            return "INVALID";
            // CommandType
            case CommandType.CHANGE_OPERATION_MODE:
            return "COMMAND_CHANGE_OPERATION_MODE";
            case CommandType.GET_IMEI:
            return "COMMAND_GET_IMEI";
            case CommandType.GET_FIRMWARE_INFO:
            return "COMMAND_GET_FIRMWARE_INFO";
            case CommandType.TEST_ALIVE:
            return "COMMAND_TEST_ALIVE";
            case CommandType.GET_PHONE_STATE_INFO:
            return "COMMAND_GET_PHONE_STATE_INFO";
            case CommandType.VERIFY_PIN:
            return "COMMAND_VERIFY_PIN";
            case CommandType.GET_VOICEMAIL_NR:
            return "COMMAND_GET_VOICEMAIL_NR";
            case CommandType.GET_LOCATION_PRIV_PREF:
            return "COMMAND_GET_LOCATION_PRIV_PREF";
            case CommandType.ANSWER_CALL:
            return "COMMAND_ANSWER_CALL";
            case CommandType.SET_AUDIO_PROFILE:
            return "COMMAND_SET_AUDIO_PROFILE";
            case CommandType.END_CALL:
            return "COMMAND_END_CALL";
            case CommandType.GET_CHARGER_STATUS:
            return "COMMAND_GET_CHARGER_STATUS";
            case CommandType.CHARGING:
            return "COMMAND_CHARGING";
            case CommandType.DIAL_CALL:
            return "COMMAND_DIAL_CALL";
            case CommandType.SET_SYSTEM_TIME:
            return "COMMAND_SET_SYSTEM_TIME";
            case CommandType.RSSI_STATUS:
            return "COMMAND_RSSI_STATUS";
            case CommandType.READ_PHONEBOOK:
            return "COMMAND_READ_PHONEBOOK";
            case CommandType.GET_NETWORKLIST:
            return "COMMAND_GET_NETWORKLIST";
            case CommandType.SET_MODE_PREFERENCE:
            return "COMMAND_SET_MODE_PREFERENCE";
            case CommandType.ENABLE_PIN:
            return "COMMAND_ENABLE_PIN";
            case CommandType.DISABLE_PIN:
            return "COMMAND_DISABLE_PIN";
            case CommandType.SIM_INFO:
            return "COMMAND_SIM_INFO";
            case CommandType.GET_AUDIO_MODEM_TUNING_PARAMS:
            return "COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS";

            // ResponseType
            case ResponseType.TEST_ALIVE:
            return "RESPONSE_TEST_ALIVE";
            case ResponseType.GET_FIRMWARE_INFO:
			return "RESPONSE_GET_FIRMWARE_INFO";
            case ResponseType.GET_IMEI:
			return "RESPONSE_GET_IMEI";
            case ResponseType.PDSM_PD_GET_POS:
			return "RESPONSE_PDSM_PD_GET_POS";
            case ResponseType.PDSM_PD_END_SESSION:
			return "RESPONSE_PDSM_PD_END_SESSION";
            case ResponseType.PA_SET_PARAM:
			return "RESPONSE_PA_SET_PARAM";
            case ResponseType.LCS_AGENT_CLIENT_RSP:
			return "RESPONSE_LCS_AGENT_CLIENT_RSP";
            case ResponseType.XTRA_SET_DATA:
			return "RESPONSE_XTRA_SET_DATA";
            case ResponseType.SIM:
			return "RESPONSE_SIM";
            case ResponseType.GET_VOICEMAIL_NR:
			return "RESPONSE_GET_VOICEMAIL_NR";
            case ResponseType.SOUND:
			return "RESPONSE_SOUND";
            case ResponseType.CM_CALL:
			return "RESPONSE_CM_CALL";
            case ResponseType.CHARGER_STATUS:
			return "RESPONSE_CHARGER_STATUS";
            case ResponseType.CHARGING:
            return "RESPONSE_CHARGING";
            case ResponseType.CM_PH:
            return "RESPONSE_CM_PH";
			case ResponseType.SET_SYSTEM_TIME:
			return "RESPONSE_SET_SYSTEM_TIME";
			case ResponseType.RSSI_STATUS:
			return "RESPONSE_RSSI_STATUS";
			case ResponseType.PHONEBOOK:
			return "RESPONSE_PHONEBOOK";
			case ResponseType.GET_PHONEBOOK_PROPERTIES:
			return "RESPONSE_GET_PHONEBOOK_PROPERTIES";
            case ResponseType.AUDIO_MODEM_TUNING_PARAMS:
            return "RESPONSE_AUDIO_MODEM_TUNING_PARAMS";

            // EventType
        	case EventType.RESET_RADIO_IND:
			return "URC_RESET_RADIO_IND";
        	case EventType.CHARGER_STATUS:
			return "URC_CHARGER_STATUS";
        	case EventType.OPERATION_MODE:
			return "URC_OPERATION_MODE";
        	case EventType.CM_PH_INFO_AVAILABLE:
			return "URC_CM_PH_INFO_AVAILABLE";
        	case EventType.NETWORK_STATE_INFO:
			return "URC_NETWORK_STATE_INFO";
        	case EventType.PDSM_PD_DONE:
			return "URC_PDSM_PD_DONE";
        	case EventType.PD_POSITION_DATA:
			return "URC_PD_POSITION_DATA";
        	case EventType.PD_PARAMETER_CHANGE:
			return "URC_PD_PARAMETER_CHANGE";
        	case EventType.PDSM_LCS:
			return "URC_PDSM_LCS";
        	case EventType.PDSM_XTRA:
			return "URC_PDSM_XTRA";
        	case EventType.CALL_STATUS:
			return "URC_CALL_STATUS";
        	case EventType.CALL_INCOMMING:
			return "URC_CALL_INCOMMING";
        	case EventType.CALL_ORIGINATION:
			return "URC_CALL_ORIGINATION";
        	case EventType.CALL_CONNECT:
			return "URC_CALL_CONNECT";
        	case EventType.CALL_END:
			return "URC_CALL_END";
        	case EventType.SIM_INSERTED:
			return "URC_SIM_INSERTED";
        	case EventType.SIM_PIN1_VERIFIED:
			return "URC_SIM_PIN1_VERIFIED";
        	case EventType.SIM_PIN1_BLOCKED:
			return "URC_SIM_PIN1_BLOCKED";
        	case EventType.SIM_PIN1_UNBLOCKED:
			return "URC_SIM_PIN1_UNBLOCKED";
        	case EventType.SIM_PIN1_ENABLED:
			return "URC_SIM_PIN1_ENABLED";
        	case EventType.SIM_PIN1_DISABLED:
			return "URC_SIM_PIN1_DISABLED";
        	case EventType.SIM_PIN1_CHANGED:
			return "URC_SIM_PIN1_CHANGED";
        	case EventType.SIM_PIN1_PERM_BLOCKED:
			return "URC_SIM_PIN1_PERM_BLOCKED";
        	case EventType.SIM_PIN2_VERIFIED:
			return "URC_SIM_PIN2_VERIFIED";
        	case EventType.SIM_PIN2_BLOCKED:
			return "URC_SIM_PIN2_BLOCKED";
        	case EventType.SIM_PIN2_UNBLOCKED:
			return "URC_SIM_PIN2_UNBLOCKED";
        	case EventType.SIM_PIN2_ENABLED:
			return "URC_SIM_PIN2_ENABLED";
        	case EventType.SIM_PIN2_DISABLED:
			return "URC_SIM_PIN2_DISABLED";
        	case EventType.SIM_PIN2_CHANGED:
			return "URC_SIM_PIN2_CHANGED";
        	case EventType.SIM_PIN2_PERM_BLOCKED:
			return "URC_SIM_PIN2_PERM_BLOCKED";
        	case EventType.SIM_REFRESH_RESET:
			return "URC_SIM_REFRESH_RESET";
        	case EventType.SIM_REFRESH_INIT:
			return "URC_SIM_REFRESH_INIT";
        	case EventType.SIM_REFRESH_INIT_FCN:
			return "URC_SIM_REFRESH_INIT_FCN";
        	case EventType.SIM_REFRESH_FAILED:
			return "URC_SIM_REFRESH_FAILED";
        	case EventType.SIM_FDN_ENABLE:
			return "URC_SIM_FDN_ENABLE";
        	case EventType.SIM_FDN_DISABLE:
			return "URC_SIM_FDN_DISABLE";
        	case EventType.SIM_ILLEGAL:
			return "URC_SIM_ILLEGAL";
        	case EventType.SIM_REMOVED:
			return "URC_SIM_REMOVED";
        	case EventType.SIM_NO_SIM_EVENT:
			return "URC_SIM_NO_SIM_EVENT";
        	case EventType.SIM_NO_SIM:
			return "URC_SIM_NO_SIM";
        	case EventType.SIM_DRIVER_ERROR:
			return "URC_SIM_DRIVER_ERROR";
        	case EventType.SIM_INTERNAL_RESET:
			return "URC_SIM_INTERNAL_RESET";
        	case EventType.SIM_OK_FOR_TERMINAL_PROFILE_DL:
			return "URC_SIM_OK_FOR_TERMINAL_PROFILE_DL";
        	case EventType.SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL:
			return "URC_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL";
        	case EventType.SIM_INIT_COMPLETED_NO_PROV:
			return "URC_SIM_INIT_COMPLETED_NO_PROV";
        	case EventType.SIM_MEMORY_WARNING:
			return "URC_SIM_MEMORY_WARNING";
        	case EventType.SIM_SIM2_EVENT:
			return "URC_SIM_SIM2_EVENT";
        	case EventType.SIM_REAL_RESET_FAILURE:
			return "URC_SIM_REAL_RESET_FAILURE";
        	case EventType.SIM_CARD_ERROR:
			return "URC_SIM_CARD_ERROR";
        	case EventType.SIM_NO_EVENT:
			return "URC_SIM_NO_EVENT";
        	case EventType.SIM_GET_PERSO_NW_FAILURE:
			return "URC_SIM_GET_PERSO_NW_FAILURE";
        	case EventType.SIM_GET_PERSO_NW_BLOCKED:
			return "URC_SIM_GET_PERSO_NW_BLOCKED";
        	case EventType.SIM_REFRESH_APP_RESET:
			return "URC_SIM_REFRESH_APP_RESET";
        	case EventType.SIM_REFRESH_3G_SESSION_RESET:
			return "URC_SIM_REFRESH_3G_SESSION_RESET";
        	case EventType.SIM_APP_SELECTED:
			return "URC_SIM_APP_SELECTED";
        	case EventType.SIM_DEFAULT:
			return "URC_SIM_DEFAULT";
            case EventType.SUPS_PROCESS_USS:
            return "SUPS_PROCESS_USS";
            case EventType.SUPS_PROCESS_USS_CONF:
            return "SUPS_PROCESS_USS_CONF";
            case EventType.SUPS_USS_RES:
            return "SUPS_USS_RES";
            case EventType.SUPS_RELEASE_USS_IND:
            return "SUPS_RELEASE_USS_IND";
            case EventType.SUPS_USS_NOTIFY_IND:
            return "SUPS_USS_NOTIFY_IND";
            case EventType.SUPS_USS_NOTIFY_RES:
            return "SUPS_USS_NOTIFY_RES";
            case EventType.SUPS_RELEASE:
            return "SUPS_RELEASE";
            case EventType.SUPS_ABORT:
            return "SUPS_ABORT";
            case EventType.SUPS_ERASE:
            return "SUPS_ERASE";
            case EventType.SUPS_REGISTER:
            return "SUPS_REGISTER";
            case EventType.SUPS_REGISTER_CONF:
            return "SUPS_REGISTER_CONF";
            case EventType.SUPS_GET_PASSWORD_IN:
            return "SUPS_GET_PASSWORD_IN";
            case EventType.SUPS_GET_PASSWORD_RES:
            return "SUPS_GET_PASSWORD_RES";
            case EventType.SUPS_INTERROGATE:
            return "SUPS_INTERROGATE";
            case EventType.SUPS_INTERROGATE_CONF:
            return "SUPS_INTERROGATE_CONF";
            case EventType.SUPS_ACTIVATE:
            return "SUPS_ACTIVATE";
            case EventType.SUPS_ACTIVATE_CONF:
            return "SUPS_ACTIVATE_CONF";
            case EventType.SUPS_DEACTIVATE:
            return "SUPS_DEACTIVATE";
            case EventType.SUPS_DEACTIVATE_CONF:
            return "SUPS_DEACTIVATE_CONF";
			case EventType.SMS_WMS_CFG_MESSAGE_LIST:
			return "SMS_WMS_CFG_MESSAGE_LIST";
			case EventType.SMS_WMS_CFG_GW_DOMAIN_PREF:
			return "SMS_WMS_CFG_GW_DOMAIN_PREF";
			case EventType.SMS_WMS_CFG_EVENT_ROUTES:
			return "SMS_WMS_CFG_EVENT_ROUTES";
			case EventType.SMS_WMS_CFG_MEMORY_STATUS:
			return "SMS_WMS_CFG_MEMORY_STATUS";
			case EventType.SMS_WMS_CFG_MEMORY_STATUS_SET:
			return "SMS_WMS_CFG_MEMORY_STATUS_SET";
			case EventType.SMS_WMS_CFG_GW_READY:
			return "SMS_WMS_CFG_GW_READY";
			case EventType.SMS_WMS_READ_TEMPLATE:
			return "SMS_WMS_READ_TEMPLATE";
			case EventType.GET_NETWORKLIST:
			return "URC_GET_NETWORKLIST";
			case EventType.PHONEBOOK_READY:
			return "URC_PHONEBOOK_READY";
            case EventType.PHONEBOOK_MODIFIED:
            return "URC_PHONEBOOK_MODIFIED";
            case EventType.CM_PH:
            return "URC_CM_PH";
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

    public string ecodingTypeToString(EncodingType type)
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

    [CCode (cname = "msmcomm_event_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void EventHandlerCb(int event, Message message);
    [CCode (cname = "msmcomm_write_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void WriteHandlerCb(void *data, int len);
    [CCode (cname = "msmcomm_read_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ReadHandlerCb(void *data, int len);
    [CCode (cname = "msmcomm_network_state_info_changed_field_type_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ChangedFieldTypeCb(void *data, int type);
    [CCode (cname = "msmcomm_error_handler_cb", instance_pos = 0, cheader_filename = "msmcomm.h")]
    public delegate void ErrorHandlerCb(int error, void *data);

    [CCode (cname = "msmcomm_check_hci_version", cheader_filename = "msmcomm.h")]
    public bool checkHciVersion(uint version);

    [CCode (cname = "msmcomm_launch_daemon", cheader_filename = "msmcomm.h")]
    public bool launchDaemon(string workdir);

    [CCode (cname = "msmcomm_is_daemon_running", cheader_filename = "msmcomm.h")]
    public bool isDaemonRunning();

    [CCode (cname = "msmcomm_shutdown_daemon", cheader_filename = "msmcomm.h")]
    public bool shutdownDaemon();

    [Compact]
    [CCode (cname = "struct msmcomm_context", free_function = "msmcomm_shutdown", cheader_filename = "msmcomm.h")]
    public class Context
    {
        [CCode (cname = "msmcomm_new")]
        public Context();

        [CCode (cname = "msmcomm_read_from_modem")]
        public bool readFromModem();

        [CCode (cname = "msmcomm_send_message")]
        public void sendMessage(Message message);

        [CCode (cname = "msmcomm_register_event_handler")]
        public void registerEventHandler(EventHandlerCb eventHandlerCb);

        [CCode (cname = "msmcomm_register_write_handler")]
        public void registerWriteHandler(WriteHandlerCb writeHandlerCb);

        [CCode (cname = "msmcomm_register_read_handler")]
        public void registerReadHandler(ReadHandlerCb readHandlerCb);

        [CCode (cname = "msmcomm_register_error_handler")]
        public void registerErrorHandler(ErrorHandlerCb errorHandlerCb);
    }

    [Compact]
    [CCode (cname = "struct msmcomm_message", free_function = "", copy_function = "msmcomm_message_make_copy", cheader_filename = "msmcomm.h")]
    public abstract class Message
    {
        [CCode (cname = "msmcomm_create_message")]
        public Message(int type);

        public int size {
            [CCode (cname = "msmcomm_message_get_size")]
            get;
        }

        public int type {
            [CCode (cname = "msmcomm_message_get_type")]
            get;
        }

        public uint8 index {
            [CCode (cname = "msmcomm_message_get_ref_id")]
            get;
            [CCode (cname = "msmcomm_message_set_ref_id")]
            set;
        }

        public ResultType result {
			[CCode (cname = "msmcomm_message_get_result")]
			get;
		}

        [CCode (cname = "msmcomm_message_make_copy")]
        public Message copy();

        public string to_string()
        {
            var str = "[MSM] rc %s ref %02x len %d : %s".printf( resultTypeToString(result), index, size, Msmcomm.eventTypeToString( type ) );
            var details = "";

            switch ( type )
            {
                case Msmcomm.ResponseType.GET_IMEI:
                    var msg = (Msmcomm.Reply.GetImei) this.copy();
                    details = @"IMEI = $(msg.imei)";
                    break;
                case Msmcomm.ResponseType.GET_FIRMWARE_INFO:
                    var msg = (Msmcomm.Reply.GetFirmwareInfo) this.copy();
                    details = @"FIRMWARE = $(msg.info) | HCI = $(msg.hci)";
                    break;
                case Msmcomm.ResponseType.CM_CALL:
                    var msg = (Msmcomm.Reply.Call) this.copy();
                    details = @"cmd = $(msg.cmd_type)";
                    break;
                case Msmcomm.ResponseType.CHARGER_STATUS:
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
                case Msmcomm.EventType.NETWORK_STATE_INFO:
					var msg = (Msmcomm.Unsolicited.NetworkStateInfo) this.copy();
					if (msg.onlyRssiUpdate) {
						details += @"rssi = $(msg.rssi) ";
					}
					else {
						details = @"new_value = $(msg.new_value) ";
						details += @"change_field = $(msg.change_field) ";
						details += @"operator_name = $(msg.operator_name) ";
						details += @"rssi = $(msg.rssi) ";
						details += @"ecio = $(msg.ecio) ";
						details += @"service_domain = $(msg.service_domain) ";
						details += @"service_capabilitiy = $(msg.service_capabilitiy) ";
						details += @"gprs_attached = $(msg.gprs_attached) ";
						details += @"roam = $(msg.roam)";
					}
					break;
				case Msmcomm.EventType.SMS_WMS_READ_TEMPLATE:
					var msg = (Msmcomm.Unsolicited.SMS.WmsReadTemplate) this.copy();
					details = @"digit_mode = $(msg.digit_mode) ";
					details += @"number_mode = $(msg.number_mode) ";
					details += @"number_type = $(msg.number_type) ";
					details += @"number_plan = $(msg.number_plan) ";
					break;
				case Msmcomm.ResponseType.PHONEBOOK:
					var msg = (Msmcomm.Reply.Phonebook) this.copy();
					details = @"book_type = $(phonebookTypeToString(msg.book_type)) ";
					details += @"position = $(msg.position) ";
					details += @"number = '$(msg.number)' ";
					details += @"title = '$(msg.title)' ";
					details += @"encoding_type = $(ecodingTypeToString(msg.encoding_type))";
					break;
				case Msmcomm.EventType.GET_NETWORKLIST:
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
				case Msmcomm.ResponseType.CM_PH:
					var msg = (Msmcomm.Reply.CmPh) this.copy();
					details = @"result = $(msg.result)";
					break;
				case Msmcomm.EventType.PHONEBOOK_READY:
					var msg = (Msmcomm.Unsolicited.PhonebookReady) this.copy();
					details = @"book_type = $(phonebookTypeToString(msg.book_type))";
					break;
				case Msmcomm.ResponseType.GET_PHONEBOOK_PROPERTIES:
					var msg= (Msmcomm.Reply.GetPhonebookProperties) this.copy();
					details = @"slot_count = $(msg.slot_count) slots_used = $(msg.slots_used) ";
					details += @"max_chars_per_title = $(msg.max_chars_per_title) max_chars_per_number = $(msg.max_chars_per_number)";
					break;
				case Msmcomm.EventType.CALL_INCOMMING:
				case Msmcomm.EventType.CALL_ORIGINATION:
				case Msmcomm.EventType.CALL_CONNECT:
				case Msmcomm.EventType.CALL_END:
				case Msmcomm.EventType.CALL_STATUS:
					var msg = (Msmcomm.Unsolicited.CallStatus) this.copy();
					details = @"caller_id = '$(msg.caller_id)' ";
					details += @"call_id = $(msg.call_id) ";
                    details += @"call_type = $(callTypeToString(msg.call_type)) ";
					details += @"reject_type = $(msg.reject_type) ";
					details += @"reject_value = $(msg.reject_value) ";
                    break;
                case Msmcomm.EventType.PHONEBOOK_MODIFIED:
                    var msg = (Msmcomm.Unsolicited.PhonebookModified) this.copy();
                    details = @"book_type = $(phonebookTypeToString(msg.book_type)) ";
                    details += @"position = $(msg.position)";
                    break;
                case Msmcomm.ResponseType.SIM:
                    var msg = (Msmcomm.Reply.Sim) this.copy();
                    details = @"field_type = $(simInfoTypeToString(msg.field_type)) ";
                    if (msg.field_data != null)
                        details += @"field_data = '$(msg.field_data)'";
                    break;
                case Msmcomm.ResponseType.AUDIO_MODEM_TUNING_PARAMS:
                    var msg = (Msmcomm.Reply.AudioModemTuningParams) this.copy();
                    details = "params [ ";
                    var params = msg.params;
                    for (var n = 0; n < params.length; n++)
                        details += "%02x ".printf(params[n]);
                    details += "]";
                    break;
                case Msmcomm.EventType.CM_PH:
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
            public ChangeOperationMode(CommandType t = CommandType.CHANGE_OPERATION_MODE);

            [CCode (cname = "msmcomm_message_change_operation_mode_set_operation_mode")]
            public void setOperationMode(OperationMode oprtMode);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Charging : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public Charging(CommandType t = CommandType.CHARGING);

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
            public GetImei(CommandType t = CommandType.GET_IMEI);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetChargerStatus : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetChargerStatus(CommandType t = CommandType.GET_CHARGER_STATUS);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetFirmwareInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetFirmwareInfo(CommandType t = CommandType.GET_FIRMWARE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetPhoneStateInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetPhoneStateInfo(CommandType t = CommandType.GET_PHONE_STATE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class TestAlive : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public TestAlive(CommandType t = CommandType.TEST_ALIVE);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class VerifyPin : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public VerifyPin(CommandType t = CommandType.VERIFY_PIN);

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
            public EndCall(CommandType t = CommandType.END_CALL);

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
            public AnswerCall(CommandType t = CommandType.ANSWER_CALL);

            public uint8 call_id {
                [CCode (cname = "msmcomm_message_answer_call_set_call_id")]
                set;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class DialCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public DialCall(CommandType t = CommandType.DIAL_CALL);

            [CCode (cname = "msmcomm_message_dial_call_set_caller_id")]
            private void _setCallerId(string callerId, uint length);

            public void setCallerId(string caller_id)
            {
                _setCallerId(caller_id, (uint)caller_id.length);
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
            public SetSystemTime(CommandType t = CommandType.SET_SYSTEM_TIME);

			[CCode (cname = "msmcomm_message_set_system_time_set")]
			public void setData(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset);
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class RssiStatus : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public RssiStatus(CommandType t = CommandType.RSSI_STATUS);

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
            public ReadPhonebook(CommandType t = CommandType.READ_PHONEBOOK);


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
            public WritePhonebook(CommandType t = CommandType.WRITE_PHONEBOOK);

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
            public DeletePhonebook(CommandType t = CommandType.DELETE_PHONEBOOK);

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
            public GetNetworkList(CommandType t = CommandType.GET_NETWORKLIST);
		}

		[Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SetModePreference : Message
		{
			[CCode (cname = "msmcomm_create_message")]
            public SetModePreference(CommandType t = CommandType.SET_MODE_PREFERENCE);

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
            public GetPhonebookProperties(CommandType t = CommandType.GET_PHONEBOOK_PROPERTIES);

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
            public ChangePin(CommandType t = CommandType.CHANGE_PIN);

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
            public EnablePin(CommandType t = CommandType.ENABLE_PIN);

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
            public DisablePin(CommandType t = CommandType.DISABLE_PIN);

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
            public SimInfo(CommandType t = CommandType.SIM_INFO);

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
            public GetAudioModemTuningParams(CommandType t = CommandType.GET_AUDIO_MODEM_TUNING_PARAMS);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class SetAudioProfile : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public SetAudioProfile(CommandType t = CommandType.SET_AUDIO_PROFILE);

            public uint8 class {
                [CCode (cname = "msmcomm_message_set_audio_profile_set_class")]
                set;
            }

            public uint8 sub_class {
                [CCode (cname = "msmcomm_message_set_audio_profile_set_sub_class")]
                set;
            }
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
            [CCode (cname = "msmcomm_event_power_state_get_state")]
            public uint8 getState();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChargerStatus : Message
        {
            [CCode (cname = "msmcomm_event_charger_status_get_voltage")]
            public uint getVoltage();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public abstract class CallStatus : Message
        {
            public string caller_id
            {
				[CCode (cname = "msmcomm_event_call_status_get_caller_id")]
				get;
            }

            public CallType call_type {
                [CCode (cname = "msmcomm_event_call_status_get_call_type")]
				get;
            }

            public uint call_id {
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
			public bool onlyRssiUpdate {
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

			public uint8 service_capabilitiy {
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
		} /* namespace SMS */
    } /* namespace Unsolicited */
}

