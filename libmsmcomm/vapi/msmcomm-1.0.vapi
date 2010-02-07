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

 [CCode (cheader_filename = "msmcomm/msmcomm.h")]
 namespace Msmcomm
 {
    [CCode (cprefix = "MSMCOMM_MESSAGE_CMD", cheader_filename = "msmcomm/msmcomm.h")]
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
        CHARGE_USB
    }

    [CCode (cprefix = "MSMCOMM_RESPONSE_", cheader_filename = "msmcomm/msmcomm.h")]
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
        GET_CHARGER_STATUS,
        CHARGE_USB
    }

    [CCode (cprefix = "MSMCOMM_EVENT_", cheader_filename = "msmcomm/msmcomm.h")]
    public enum EventType
    {
        RESET_RADIO_IND,
        CHARGER_STATUS,
        OPERATION_MODE,
        CM_PH_INFO_AVAILABLE,
        POWER_STATE,
        CM_SS,
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
        SIM_DEFAULT
    }

    [CCode (cprefix = "MSMCOMM_OPERATION_MODE_", cheader_filename = "msmcomm/msmcomm.h")]
    public enum OperationMode
    {
        RESET,
        ONLINE,
        OFFLINE
    }

    [CCode (cprefix = "MSMCOMM_CHARGE_USB_", cheader_filename = "msmcomm/msmcomm.h")]
    public enum UsbChargeMode
    {
        MODE_250mA,
        MODE_500mA,
        MODE_1A
    }

    [CCode (cname = "msmcomm_event_handler_cb")]
    public delegate void EventHandlerCb(EventType event, Message? message);
    [CCode (cname = "msmcomm_write_handler_cb")]
    public delegate void WriteHandlerCb(void *data, int len);
    [CCode (cname = "msmcomm_read_handler_cb")]
    public delegate void ReadHandlerCb(void *data, int len);

    [CCode (cname = "msmcomm_check_hci_version")]
    public bool checkHciVersion(uint version);


    [CCode (cname = "struct msmcomm_context", free_function = "msmcomm_shutdown")]
    [Compact]
    public class Context
    {
        [CCode (cname = "msmcomm_init")]
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

    
    [CCode (cname = "struct msmcomm_message", free_function = "msmcomm_free_message")]
    [Compact]
    public class Message
    {
       [CCode (cname = "msmcomm_create_message")]
       public Message(Context? context, int type);

       [CCode (cname = "msmcomm_message_get_size")]
       public int getSize();

       //[CCode (cname = "msmcomm_message_get_type")]
       //public MessageType getType();

       [CCode (cname = "msmcomm_message_get_ref_id")]
       public uint8 getRefId();

       [CCode (cname = "msmcomm_message_set_ref_id")]
       public void setRefId(uint8 refId);
    }

    /*
     * Command Messages
     */

    public class ChangeOperationModeCmd : Message
    {
        public ChangeOperationModeCmd(Context? context)
        {
            base(context, CommandType.CHANGE_OPERATION_MODE);
        }

        [CCode (cname = "msmcomm_message_change_operation_mode_set_operation_mode")]
        public void setOperationMode(OperationMode oprtMode);
    }

    public class VerifyPinCmd : Message
    {
        public VerifyPinCmd(Context? context)
        {
            base(context, CommandType.VERIFY_PIN);
        }

        [CCode (cname = "msmcomm_message_verify_pin_set_pin")]
        public void setPin(string pin);
    }

    public class ChargeUsbCmd : Message
    {
        public ChargeUsbCmd(Context? context)
        {
            base(context, CommandType.CHARGE_USB);
        }

        [CCode (cname = "msmcomm_message_charge_usb_set_mode")]
        public void setMode(UsbChargeMode mode);
    }

    public class EndCallCmd : Message
    {
        public EndCallCmd(Context? context)
        {
            base(context, CommandType.END_CALL);
        }

        [CCode (cname = "msmcomm_message_end_call_set_call_number")]
        public void setCallNumber(uint8 call_nr);
    }

    public class AnswerCallCmd : Message
    {
        public AnswerCallCmd(Context? context)
        {
            base(context, CommandType.ANSWER_CALL);
        }

        /*
        [CCode (cname = "msmcomm_message_answer_call_set_call_number")]
        public void setCallNumber(uint8 call_nr);
        */
    }

    /* 
     * Response Messages
     */

    public class GetFirmwareInfoResp : Message
    {
        [CCode (cname = "msmcomm_resp_get_firmware_info_get_info")]
        public void getInfo(out string info);

        [CCode (cname = "msmcomm_resp_get_firmware_info_get_hci_version")]
        public uint8 getHciVersion();
    }

    public class GetImeiResp : Message
    {
        [CCode (cname = "msmcomm_resp_get_imei_get_imei")]
        private void _getImei(string imei);

        public string getImei()
        {
            string imei;
            _getImei(imei);
            return imei;
        }
    }

    public class ChargeUsbResp : Message
    {
        [CCode (cname = "msmcomm_resp_charge_usb_get_voltage")]
        public uint getVoltage();
    }

    /*
     * Event Messages
     */

    public class PowerStateEvent : Message
    {
        [CCode (cname = "msmcomm_event_power_state_get_state")]
        public uint8 getState();
    }

    public class ChargerStatusEvent : Message
    {
        [CCode (cname = "msmcomm_event_charger_status_get_voltage")]
        public uint getVoltage();
    }

    public abstract class CallStatusEvent : Message
    {
        [CCode (cname = "msmcomm_event_call_status_get_caller_id")]
        private void _getCallerId(string callerId);

        public string getCallerId()
        {
            string callerId;
            _getCallerId(callerId);
            return callerId;
        }
    }

    public class CallIncomingEvent : CallStatusEvent
    {
    }

    public class CallConnectEvent : CallStatusEvent
    {
    }

    public class CallEndEvent : CallStatusEvent
    {
    }

    public class CallOriginationEvent : CallStatusEvent
    {
    }
}

