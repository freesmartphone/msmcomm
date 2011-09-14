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

using Msmcomm.LowLevel.Structures.Palmpre;

namespace Msmcomm.LowLevel
{
    public enum State.OperationMode
    {
        POWER_OFF = 0x0,
        ONLINE = 0x5,
        OFFLINE = 0x6,
        RESET = 0x7,
    }

    public class StateChangeOperationModeRequestCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x3;
        public static const uint16 MESSAGE_ID = 0x0;

        private StateChangeOperationModeMessage _message;

        public State.OperationMode mode;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST, MessageClass.COMMAND);

            _message = StateChangeOperationModeMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode = (uint8) mode;
        }
    }

    public enum State.NetworkModePreference
    {
        AUTOMATIC = 2,
        GSM = 13,
        UMTS = 14,
    }

    public class StateSysSelPrefCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x3;
        public static const uint16 MESSAGE_ID = 0x1;

        private StateSysSelPrefMessage _message;

        public State.NetworkModePreference mode_preference;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_STATE_SYS_SEL_PREF, MessageClass.COMMAND);

            _message = StateSysSelPrefMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode_preference = mode_preference;
        }
    }

    public class StateCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x4;
        public static const uint16 MESSAGE_ID = 0x1;

        private StateCallbackResponse _message;

        private static const uint8 RESULT_OK = 0x0;
        private static const uint8 RESULT_ERROR = 0x1a;

        construct 
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_STATE_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = StateCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;

            switch (_message.result)
            {
                case RESULT_OK:
                    result = MessageResult.OK;
                    break;
                case RESULT_ERROR:
                    result = MessageResult.ERROR_UNKNOWN;
                    break;
            }
        }
    }

    public enum NetworkRadioType
    {
        GSM = 0,
        UMTS = 1,
    }

    public class NetworkProviderInfo
    {
        public uint16 mcc;
        public uint8 mnc;
        public NetworkRadioType radio_type;
        public string name;
    }

    public class StateUnsolicitedResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x5;

        private StateEvent _message;

        public uint8 line;
        public uint8 als_allowed;

        public NetworkProviderInfo[] networks;
        public State.OperationMode mode;

        construct
        {
            _message = StateEvent();
            message_class = MessageClass.UNSOLICITED_RESPONSE;
            set_payload(_message.data);
        }

        protected override void check_size(int size, int payload_size)
        {
            /* Quirk for webOS modem firmware version CU 0.5.66(5027) */
            assert(size == payload_size || size == (payload_size + 1));
        }

        protected override void evaluate_data()
        {
            mode = (State.OperationMode) _message.mode;
            line = _message.line;
            als_allowed = _message.als_allowed;

            NetworkProviderInfo[] tmp = { };

            for (var n = 0; n < _message.network_count; n++)
            {
                var npi = new NetworkProviderInfo();
                npi.mcc = parseMcc(_message.networks[n].plmn.mcc);
                npi.mnc = parseMnc(_message.networks[n].plmn.mnc);
                npi.radio_type = (NetworkRadioType) _message.networks[n].radio_type;
                npi.name = _message.networks[n].name_len > 0 ? convertBytesToString(_message.networks[n].name) : "";
                tmp += npi;
            }

            networks = tmp;
        }
    }
}
