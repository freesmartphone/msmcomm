/**
 * (C) 2009-2010 by Simon Busch <morphis@gravedo.de>
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
 **/

// FIXME: Change 'EVENT' to 'URC' to match telephony taxonomy
// FIXME: Map properties as such

[CCode (cheader_filename = "msmcomm.h")]
namespace Msmcomm
{
    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_MESSAGE_CMD_", cheader_filename = "msmcomm.h")]
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
        DIAL_CALL
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
        GET_SIM_CAPABILITIES,
        GET_VOICEMAIL_NR,
        SOUND,
        CM_CALL,
        CHARGER_STATUS,
        CHARGING
    }

    [CCode (cname = "int", has_type_id = false, cprefix = "MSMCOMM_EVENT_", cheader_filename = "msmcomm.h")]
    public enum EventType
    {
        RESET_RADIO_IND,
        CHARGER_STATUS,
        OPERATION_MODE,
        CM_PH_INFO_AVAILABLE,
        POWER_STATE,
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
        SUPS_DEACTIVATE_CONF
    }

    public string eventTypeToString( int t )
    {
        switch ( t )
        {
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
            case ResponseType.GET_SIM_CAPABILITIES:
			return "RESPONSE_GET_SIM_CAPABILITIES";
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
            // EventType
        	case EventType.RESET_RADIO_IND:
			return "URC_RESET_RADIO_IND";
        	case EventType.CHARGER_STATUS:
			return "URC_CHARGER_STATUS";
        	case EventType.OPERATION_MODE:
			return "URC_OPERATION_MODE";
        	case EventType.CM_PH_INFO_AVAILABLE:
			return "URC_CM_PH_INFO_AVAILABLE";
        	case EventType.POWER_STATE:
			return "URC_POWER_STATE";
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

    [CCode (cname = "msmcomm_event_handler_cb", instance_pos = 0)]
    public delegate void EventHandlerCb(int event, Message message);
    [CCode (cname = "msmcomm_write_handler_cb", instance_pos = 0)]
    public delegate void WriteHandlerCb(void *data, int len);
    [CCode (cname = "msmcomm_read_handler_cb", instance_pos = 0)]
    public delegate void ReadHandlerCb(void *data, int len);
    [CCode (cname = "msmcomm_network_state_info_changed_field_type_cb", instance_pos = 0)]
    public delegate void ChangedFieldTypeCb(void *data, int type);

    [CCode (cname = "msmcomm_check_hci_version")]
    public bool checkHciVersion(uint version);

    [Compact]
    [CCode (cname = "struct msmcomm_context", free_function = "msmcomm_shutdown")]
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
    }

    [Compact]
    [CCode (cname = "struct msmcomm_message", free_function = "msmcomm_free_message", copy_function = "msmcomm_message_make_copy")]
    public abstract class Message
    {      
        [CCode (cname = "msmcomm_create_message")]
        public Message(int type);

        public int size {
            [CCode (cname = "msmcomm_message_get_size")]
            get;
        }

        [CCode (cname = "msmcomm_message_get_size")]
        public int getSize();

        [CCode (cname = "msmcomm_message_get_type")]
        public int getType();

        [CCode (cname = "msmcomm_message_get_ref_id")]
        public uint8 getRefId();

        [CCode (cname = "msmcomm_message_set_ref_id")]
        public void setRefId(uint8 refId);
    }

    namespace Command
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class ChangeOperationMode : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public ChangeOperationMode(CommandType t = CommandType.CHANGE_OPERATION_MODE);

            [CCode (cname = "msmcomm_message_change_operation_mode_set_operation_mode")]
            public void setOperationMode(OperationMode oprtMode);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class Charging : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public Charging(CommandType t = CommandType.CHARGING);

            [CCode (cname = "msmcomm_message_charging_set_voltage")]
            public void setVoltage(UsbVoltageMode voltage);

            [CCode (cname = "msmcomm_message_charging_set_mode")]
            public void setMode(ChargingMode mode);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class GetImei : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetImei(CommandType t = CommandType.GET_IMEI);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class GetChargerStatus : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetChargerStatus(CommandType t = CommandType.GET_CHARGER_STATUS);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class GetFirmwareInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetFirmwareInfo(CommandType t = CommandType.GET_FIRMWARE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class GetPhoneStateInfo : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public GetPhoneStateInfo(CommandType t = CommandType.GET_PHONE_STATE_INFO);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class TestAlive : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public TestAlive(CommandType t = CommandType.TEST_ALIVE);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class VerifyPin : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public VerifyPin(CommandType t = CommandType.VERIFY_PIN);

            [CCode (cname = "msmcomm_message_verify_pin_set_pin")]
            public void _setPin(string pin, uint length);

            public void setPin(string pin)
            {
                GLib.assert( pin.length <= 8 );
                _setPin( pin, (uint)pin.length );
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class EndCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public EndCall(CommandType t = CommandType.END_CALL);

            [CCode (cname = "msmcomm_message_end_call_set_call_number")]
            public void setCallNumber(uint8 call_nr);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class AnswerCall : Message
        {
            [CCode (cname = "msmcomm_create_message")]
            public AnswerCall(CommandType t = CommandType.ANSWER_CALL);

            [CCode (cname = "msmcomm_message_answer_call_set_call_number")]
            public void setCallNumber(uint8 call_nr);
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
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
        }
    }

    namespace Reply
    {
        [Compact]
        [CCode (type_id = "MESSAGE", cname = "struct msmcomm_message", free_function = "")]
        public class GetFirmwareInfo : Message
        {
            [CCode (cname = "msmcomm_resp_get_firmware_info_get_info")]
            public void _getInfo(char[] info);

            public string getInfo()
            {
                var info = new char[100];
                _getInfo( info );
                return ((string)info).dup();
            }

            [CCode (cname = "msmcomm_resp_get_firmware_info_get_hci_version")]
            public uint8 getHciVersion();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class GetImei : Message
        {
            [CCode (cname = "msmcomm_resp_get_imei_get_imei")]
            private void _getImei(char[] imei);

            public string getImei()
            {
                var imei = new char[17];
                _getImei(imei);
                // FIXME: Is this ok or do we have a leak now?
                return ((string)imei).dup();
            }
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class Charging : Message
        {
            [CCode (cname = "msmcomm_resp_charging_get_voltage")]
            public uint getVoltage();
            
            [CCode (cname = "msmcomm_resp_charging_get_mode")]
            public uint getMode();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class ChargerStatus : Message
        {
            [CCode (cname = "msmcomm_resp_charger_status_get_voltage")]
            public uint getVoltage();

            [CCode (cname = "msmcomm_resp_charger_status_get_mode")]
            public uint getMode();
        }
    
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
		public class Call : Message
		{
			[CCode (cname = "msmcomm_resp_cm_call_get_cmd")]
			public uint16 getCmd();

			[CCode (cname = "msmcomm_resp_cm_call_get_error_code")]
			public uint16 getErrorCode();
		}
    }

    namespace Unsolicited
    {
        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class PowerState : Message
        {
            [CCode (cname = "msmcomm_event_power_state_get_state")]
            public uint8 getState();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class ChargerStatus : Message
        {
            [CCode (cname = "msmcomm_event_charger_status_get_voltage")]
            public uint getVoltage();
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public abstract class CallStatus : Message
        {
            [CCode (cname = "msmcomm_event_call_status_get_caller_id")]
            private void _getCallerId(string callerId);

            public string getCallerId()
            {
                string callerId;
                _getCallerId(callerId);
                return callerId;
            }

            [CCode (cname = "msmcomm_event_call_status_get_call_id")]
            public uint getCallId();

            [CCode (cname = "msmcomm_event_call_status_get_reject_type")]
            public uint getRejectType();

            [CCode (cname = "msmcomm_event_call_status_get_reject_value")]
            public uint getRejectValue();

        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class CallIncoming : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class CallConnect : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class CallEnd : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class CallOrigination : CallStatus
        {
        }

        [Compact]
        [CCode (cname = "struct msmcomm_message", free_function = "")]
        public class NetworkStateInfo : Message
        {
            [CCode (cname = "msmcomm_event_network_state_info_get_change_field")]
            public uint getChangeField(); 

            [CCode (cname = "msmcomm_event_network_state_info_get_new_value")]
            public uint8 getNewValue();

            [CCode (cname = "msmcomm_event_network_state_info_trace_changes")]
            public void traceChanges(ChangedFieldTypeCb type_handler);

            [CCode (cname = "msmcomm_event_network_state_info_get_operator_name")]
            private string _getOperatorName(string operatorName);

            public string getOperatorName()
            {
                string operatorName;
                _getOperatorName(operatorName);
                return operatorName;
            }

            [CCode (cname = "msmcomm_event_network_state_info_get_rssi")]
            public uint16 getRssi();

            [CCode (cname = "msmcomm_event_network_state_info_get_ecio")]
            public uint16 getEcio();

            [CCode (cname = "msmcomm_event_network_state_info_get_service_domain")]
            public uint8 getServiceDomain();

            [CCode (cname = "msmcomm_event_network_state_info_get_service_capability")]
            public uint8 getServiceCapability();

            [CCode (cname = "msmcomm_event_network_state_info_get_gprs_attached")]
            public uint8 getGrpsAttached();

            [CCode (cname = "msmcomm_event_network_state_info_get_roam")]
            public uint16 getRoam();
        }
    } /* namespace Unsolicited */
}

