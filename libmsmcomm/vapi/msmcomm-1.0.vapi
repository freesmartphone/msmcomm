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

    [CCode (cname = "msmcomm_message_class_to_string")]
    public string messageClassToString(MessageClass class);


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
        COMMAND_CM_CALL_ANSWER,
        COMMAND_SET_AUDIO_PROFILE,
        COMMAND_CM_CALL_END,
        COMMAND_GET_CHARGER_STATUS,
        COMMAND_CHARGING,
        COMMAND_CM_CALL_ORIGINATION,
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
        COMMAND_CM_CALL_SUPS,
        COMMAND_GET_HOME_NETWORK_NAME,
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
        RESPONSE_CM_CALL_RETURN,
        RESPONSE_CM_CALL_CALLBACK,
        RESPONSE_CHARGER_STATUS,
        RESPONSE_CHARGING,
        RESPONSE_CM_PH,
        RESPONSE_SET_SYSTEM_TIME,
        RESPONSE_RSSI_STATUS,
        RESPONSE_PHONEBOOK,
        RESPONSE_GET_PHONEBOOK_PROPERTIES,
        RESPONSE_AUDIO_MODEM_TUNING_PARAMS,
        RESPONSE_SMS_WMS,
        RESPONSE_GET_HOME_NETWORK_NAME,
        EVENT_RESET_RADIO_IND,
        EVENT_CHARGER_STATUS,
        EVENT_OPERATION_MODE,
        EVENT_CM_PH_INFO_AVAILABLE,
        EVENT_NETWORK_STATE_INFO,
        EVENT_PD_POSITION_DATA,
        EVENT_PD_PARAMETER_CHANGE,
        EVENT_PDSM_LCS,
        EVENT_CM_CALL_ORIGINATION,
        EVENT_CM_CALL_ANSWER,
        EVENT_CM_CALL_END_REQ,
        EVENT_CM_CALL_END,
        EVENT_CM_CALL_SUPS,
        EVENT_CM_CALL_INCOMMING,
        EVENT_CM_CALL_CONNECT,
        EVENT_CM_CALL_SRV_OPT,
        EVENT_CM_CALL_PRIVACY,
        EVENT_CM_CALL_PRIVACY_PREF,
        EVENT_CM_CALL_CALLER_ID,
        EVENT_CM_CALL_ABRV_ALTER,
        EVENT_CM_CALL_ABRV_REORDER,
        EVENT_CM_CALL_ABRV_INTERCEPT,
        EVENT_CM_CALL_SIGNAL,
        EVENT_CM_CALL_DISPLAY,
        EVENT_CM_CALL_CALLED_PARTY,
        EVENT_CM_CALL_CONNECTED_NUM,
        EVENT_CM_CALL_INFO,
        EVENT_CM_CALL_EXT_DISP,
        EVENT_CM_CALL_NDSS_START,
        EVENT_CM_CALL_NDSS_CONNECT,
        EVENT_CM_CALL_EXT_BRST_INTL,
        EVENT_CM_CALL_NSS_CLIR_REC,
        EVENT_CM_CALL_NSS_REL_REC,
        EVENT_CM_CALL_NSS_AUD_CTRL,
        EVENT_CM_CALL_L2ACK_CALL_HOLD,
        EVENT_CM_CALL_SETUP_IND,
        EVENT_CM_CALL_SETUP_RES,
        EVENT_CM_CALL_CALL_CONF,
        EVENT_CM_CALL_PDP_ACTIVATE_IND,
        EVENT_CM_CALL_PDP_ACTIVATE_RES,
        EVENT_CM_CALL_PDP_MODIFY_REQ,
        EVENT_CM_CALL_PDP_MODIFY_IND,
        EVENT_CM_CALL_PDP_MODIFY_REJ,
        EVENT_CM_CALL_PDP_MODIFY_CONF,
        EVENT_CM_CALL_RAB_REL_IND,
        EVENT_CM_CALL_RAB_REESTAB_IND,
        EVENT_CM_CALL_RAB_REESTAB_REQ,
        EVENT_CM_CALL_RAB_REESTAB_CONF,
        EVENT_CM_CALL_RAB_REESTAB_REJ,
        EVENT_CM_CALL_RAB_REESTAB_FAIL,
        EVENT_CM_CALL_PS_DATA_AVAILABLE,
        EVENT_CM_CALL_MNG_CALLS_CONF,
        EVENT_CM_CALL_CALL_BARRED,
        EVENT_CM_CALL_CALL_IS_WAITING,
        EVENT_CM_CALL_CALL_ON_HOLD,
        EVENT_CM_CALL_CALL_RETRIEVED,
        EVENT_CM_CALL_ORIG_FWD_STATUS,
        EVENT_CM_CALL_CALL_FORWARDED,
        EVENT_CM_CALL_CALL_BEING_FORWARDED,
        EVENT_CM_CALL_INCOM_FWD_CALL,
        EVENT_CM_CALL_CALL_RESTRICTED,
        EVENT_CM_CALL_CUG_INFO_RECEIVED,
        EVENT_CM_CALL_CNAP_INFO_RECEIVED,
        EVENT_CM_CALL_EMERGENCY_FLASHED,
        EVENT_CM_CALL_PROGRESS_INFO_IND,
        EVENT_CM_CALL_CALL_DEFLECTION,
        EVENT_CM_CALL_TRANSFERRED_CALL,
        EVENT_CM_CALL_EXIT_TC,
        EVENT_CM_CALL_REDIRECTING_NUMBER,
        EVENT_CM_CALL_PDP_PROMOTE_IND,
        EVENT_CM_CALL_UMTS_CDMA_HANDOVER_START,
        EVENT_CM_CALL_UMTS_CDMA_HANDOVER_END,
        EVENT_CM_CALL_SECONDARY_MSM,
        EVENT_CM_CALL_ORIG_MOD_TO_SS,
        EVENT_CM_CALL_USER_DATA_IND,
        EVENT_CM_CALL_USER_DATA_CONG_IND,
        EVENT_CM_CALL_MODIFY_IND,
        EVENT_CM_CALL_MODIFY_REQ,
        EVENT_CM_CALL_LINE_CTRL,
        EVENT_CM_CALL_CCBS_ALLOWED,
        EVENT_CM_CALL_ACT_CCBS_CNF,
        EVENT_CM_CALL_CCBS_RECALL_IND,
        EVENT_CM_CALL_CCBS_RECALL_RSP,
        EVENT_CM_CALL_CALL_ORIG_THR,
        EVENT_CM_CALL_VS_AVAIL,
        EVENT_CM_CALL_VS_NOT_AVAIL,
        EVENT_CM_CALL_MODIFY_COMPLETE_CONF,
        EVENT_CM_CALL_MODIFY_RES,
        EVENT_CM_CALL_CONNECT_ORDER_ACK,
        EVENT_CM_CALL_TUNNEL_MSG,
        EVENT_CM_CALL_END_VOIP_CALL,
        EVENT_CM_CALL_VOIP_CALL_END_CNF,
        EVENT_CM_CALL_PS_SIG_REL_REQ,
        EVENT_CM_CALL_PS_SIG_REL_CNF,
        EVENT_CM_CALL_PS_SIG_REL_IND,
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
        EVENT_SIM_ILLEGAL_2,
        EVENT_SIM_UHZI_V2_COMPLETE,
        EVENT_SIM_UHZI_V1_COMPLETE,
        EVENT_SIM_PERSO_EVENT_GEN_PROP2,
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
        EVENT_SIM_CARD_ERR_NOT_ATR_RECEIVED_WITH_MAX_VOLTAGE,
        EVENT_SIM_APP_RESET,
        EVENT_SIM_3G_SESSION_RESET_2,
        EVENT_SIM_PERSO_SANITY_ERROR,
        EVENT_SIM_PERSO_GEN_PROP1,
        EVENT_SIM_PERSO_GEN_PROP2,
        EVENT_SIM_PERSO_EVT_INIT_COMPLETED,
        EVENT_SIM_PLMN_SEL_MENU_ENABLE,
        EVENT_SIM_PLMN_SEL_MENU_DISABLE,
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
        EVENT_PHONEBOOK_RECORD_ADDED,
        EVENT_PHONEBOOK_RECORD_DELETED,
        EVENT_PHONEBOOK_RECORD_UPDATED,
        EVENT_PHONEBOOK_RECORD_FAILED,
        EVENT_CM_PH,
        EVENT_GET_NETWORKLIST,
        EVENT_PDSM_PD_DONE,
        EVENT_PDSM_XTRA,
    }

    [CCode (cname = "msmcomm_message_type_to_string")]
    public string messageTypeToString(MessageType type);

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

        public int size 
        {
            [CCode (cname = "msmcomm_message_get_size")]
            get;
        }

        public MessageType type 
        {
            [CCode (cname = "msmcomm_message_get_type")]
            get;
        }

        public uint32  index 
        {
            [CCode (cname = "msmcomm_message_get_ref_id")]
            get;
            [CCode (cname = "msmcomm_message_set_ref_id")]
            set;
        }

        public ResultType result 
        {
            [CCode (cname = "msmcomm_message_get_result")]
            get;
        }

        public MessageClass class 
        {
            [CCode (cname = "msmcomm_message_get_class")]
            get;
        }

        [CCode (cname = "msmcomm_message_make_copy")]
        public Message copy();
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

        namespace Call
        {
            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public class MessageCmCallEnd : Message
            {
                [CCode (cname = "msmcomm_create_message")]
                public MessageCmCallEnd(MessageType t = MessageType.COMMAND_CM_CALL_END);

                public uint8 call_id 
                {
                    [CCode (cname = "msmcomm_message_cm_call_end_set_call_id")]
                    set;
                }
            }

            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public class MessageCmCallAnswer : Message
            {
                [CCode (cname = "msmcomm_create_message")]
                public MessageCmCallAnswer(MessageType t = MessageType.COMMAND_CM_CALL_ANSWER);

                public uint8 call_id 
                {
                    [CCode (cname = "msmcomm_message_cm_call_answer_set_call_id")]
                    set;
                }
            }

            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public class MessageCmCallSups : Message
            {
                [CCode (cname = "msmcomm_create_message")]
                public MessageCmCallSups(MessageType t = MessageType.COMMAND_CM_CALL_SUPS);

                [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_CM_CALL_SUPS_COMMAND_TYPE_", cheader_filename = "msmcomm.h")]
                public enum CommandType
                {
                    INVALID,
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
                    [CCode (cname = "msmcomm_message_cm_call_sups_set_command_type")]
                    set;
                }

                public uint8 call_id 
                {
                    [CCode (cname = "msmcomm_message_cm_call_sups_set_call_id")]
                    set;
                }
            }


            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public class MessageCmCallSups : Message
            {
                [CCode (cname = "msmcomm_create_message")]
                public MessageCmCallSups(MessageType t = MessageType.COMMAND_CM_CALL_ORIGINATION);

                [CCode (cname = "msmcomm_message_cm_call_origination_set_caller_id")]
                private void _setCallerId(string callerId, uint length);

                public string number 
                {
                    set
                    {
                        _setCallerId(value, (uint)value.length);
                    }
                }

                public bool block 
                {
                    [CCode (cname = "msmcomm_message_cm_call_origination_set_block")]
                    set;
                }
            }
        } // namespace Call

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

            public bool status 
            {
                public set 
                {
                    if (value) 
                    {
                        _setStatus(1);
                    }
                    else 
                    {
                        _setStatus(0);
                    }
                }
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ReadPhonebook : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public ReadPhonebook(MessageType t = MessageType.COMMAND_READ_PHONEBOOK);


            public PhonebookType book_type 
            {
                [CCode (cname = "msmcomm_message_read_phonebook_set_book_type")]
                set;
            }

            public uint8 position 
            {
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

            public string number 
            {
                set 
                {
                    var number = value;
                    _setNumber(number, (uint)number.length);
                }
            }

            public string title 
            {
                set 
                {
                    var title = value;
                    _setTitle(title, (uint)title.length);
                }
            }

            public PhonebookType book_type 
            {
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

            public uint8 position 
            {
                [CCode (cname = "msmcomm_message_delete_phonebook_set_position")]
                set;
            }

            public PhonebookType book_type 
            {
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

            public NetworkMode mode 
            {
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

            public PhonebookType book_type 
            {
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

            public string new_pin 
            {
                set 
                {
                    var pin = value;
                    _setNewPin(pin, (uint)pin.length);
                }
            }

            public string old_pin 
            {
                set 
                {
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

            public string pin 
            {
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

            public string pin 
            {
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

            public SimInfoFieldType field_type 
            {
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

            public uint8 class 
            {
                [CCode (cname = "msmcomm_message_set_audio_profile_set_class")]
                set;
            }

            public uint8 sub_class 
            {
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
    } // namespace Command

    namespace Reply
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class GetFirmwareInfo : Message
        {
            public string info 
            {
                [CCode (cname = "msmcomm_resp_get_firmware_info_get_info")]
                get;
            }

            public uint8 hci 
            {
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
            public string imei 
            {
                [CCode (cname = "msmcomm_resp_get_imei_get_imei")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Charging : Message
        {
            public UsbVoltageMode voltage 
            {
                [CCode (cname = "msmcomm_resp_charging_get_voltage")]
                get;
            }

            public ChargingMode mode 
            {
                [CCode (cname = "msmcomm_resp_charging_get_mode")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ChargerStatus : Message
        {
            public UsbVoltageMode voltage 
            {
                [CCode (cname = "msmcomm_resp_charger_status_get_voltage")]
                get;
            }

            public ChargingMode mode 
            {
                [CCode (cname = "msmcomm_resp_charger_status_get_mode")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class ResponseCmCallCallback : Message
        {
            public uint16 cmd_type 
            {
                [CCode (cname = "msmcomm_resp_cm_call_callback_get_cmd_type")]
                get;
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
        public class Phonebook : Message
        {
            public PhonebookType book_type 
            {
                [CCode (cname = "msmcomm_resp_phonebook_get_book_type")]
                get;
            }

            public uint8 position 
            {
                [CCode (cname = "msmcomm_resp_phonebook_get_position")]
                get;
            }

            public string number 
            {
                [CCode (cname = "msmcomm_resp_phonebook_get_number")]
                get;
            }

            public string title 
            {
                [CCode (cname = "msmcomm_resp_phonebook_get_title")]
                get;
            }

            public EncodingType encoding_type 
            {
                [CCode (cname = "msmcomm_resp_phonebook_get_encoding_type")]
                get;
            }

            public uint8 modify_id 
            {
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
				[CCode (cname = "msmcomm_event_cm_call_get_caller_id")]
				get;
            }

            public CallType type {
                [CCode (cname = "msmcomm_event_cm_call_get_call_type")]
				get;
            }

            public uint id {
				[CCode (cname = "msmcomm_event_cm_call_get_call_id")]
				get;
			}

            public uint reject_type {
				[CCode (cname = "msmcomm_event_cm_call_get_reject_type")]
				get;
			}

            public uint reject_value {
				[CCode (cname = "msmcomm_event_cm_call_get_reject_value")]
				get;
			}

        }

        namespace Call
        {
            [Compact]
            [CCode (cname = "struct msmcomm_message", free_function = "", cheader_filename = "msmcomm.h")]
            public abstract class CallStatus : Message
            {
                public string number
                {
                    [CCode (cname = "msmcomm_event_cm_call_get_caller_id")]
                    get;
                }

                public CallType type 
                {
                    [CCode (cname = "msmcomm_event_cm_call_get_call_type")]
                    get;
                }

                public uint id 
                {
                    [CCode (cname = "msmcomm_event_cm_call_get_call_id")]
                    get;
                }

                public uint reject_type 
                {
                    [CCode (cname = "msmcomm_event_cm_call_get_reject_type")]
                    get;
                }

                public uint reject_value 
                {
                    [CCode (cname = "msmcomm_event_cm_call_get_reject_value")]
                    get;
                }
            }
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

