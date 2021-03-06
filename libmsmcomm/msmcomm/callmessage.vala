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
    public abstract class CallBaseMessage : BaseMessage
    {
        public enum Type
        {
            DATA = 0x1,
            AUDIO = 0x2,
        }
    }

    public class CallOriginationCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x0;

        private const uint8 BLOCK_MODE_ON = 0xb;
        private const uint8 BLOCK_MODE_OFF = 0xc;

        private CallOriginationMessage _message;

        public string number;
        public bool suppress_own_number;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_ORIGINATION, MessageClass.COMMAND);

            number = "";
            suppress_own_number = false;

            _message = CallOriginationMessage();
            set_payload(_message.data);

            /* Some unknown values which have to be set */
            _message.value0 = 0x4;
            _message.value1 = 0x1;
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            Memory.copy(_message.caller_id, number.data, number.length);
            _message.caller_id_len = (uint8) number.length;
            _message.block = suppress_own_number ? BLOCK_MODE_ON : BLOCK_MODE_OFF;
        }
    }

    public class CallAnswerCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint8 MESSAGE_ID = 0x1;

        public uint8 call_id;

        private CallAnswerMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_ANSWER, MessageClass.COMMAND);

            _message = CallAnswerMessage();
            set_payload(_message.data);

            /* Some unknown values which have to be set */
            _message.value0 = 0x2;
            _message.value1 = 0x1;
            _message.value2 = 0x0;
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.call_id = call_id;
        }
    }

    public class CallEndCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x2;

        public uint8 call_id;

        private CallEndMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_END, MessageClass.COMMAND);

            _message = CallEndMessage();
            set_payload(_message.data);

            /* Some unknown values which have to be set */
            _message.value0 = 0x1;
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.call_id = call_id;
        }
    }

    public enum CallSupsAction
    {
        REJECT_INCOMING_CALL = 0,
        HANGUP_ACTIVE_CALL = 1,
        RELEASE_SPECIFIC_CALL = 2,
        HOLD_ALL_ACTIVE_AND_ACCEPT_HELD_OR_WAITING = 3,
    }

    public class CallSupsCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x3;

        public uint8 call_id;
        public CallSupsAction action;

        private CallSupsMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_SUPS, MessageClass.COMMAND);

            _message = CallSupsMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.call_id = call_id;
            _message.command = (uint8) action;
        }
    }


    public class CallCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1;
        public static const uint16 MESSAGE_ID = 0x0;

        public uint32 command_type;

        private const uint8 RESULT_BAD_CALL_ID_VALUE = 0x31;
        private const uint8 RESULT_ERROR_VALUE = 0x2;

        private CallCallbackResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_CALL_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = CallCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command_type = _message.cmd_type;

            switch (_message.result)
            {
                case RESULT_BAD_CALL_ID_VALUE:
                    result = MessageResult.ERROR_BAD_CALL_ID;
                    break;
                case RESULT_ERROR_VALUE:
                    result = MessageResult.ERROR_UNKNOWN;
                    break;
            }
        }
    }

    public class CallReturnResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1;
        public static const uint16 MESSAGE_ID = 0x1;

        private CallCallbackResponse _message;

        public CallBaseMessage.Type command_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_CALL_CALLBACK, MessageClass.SOLICITED_RESPONSE);
            _message = CallCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command_type = (CallBaseMessage.Type)_message.cmd_type;
            result = (Msmcomm.LowLevel.MessageResult) _message.result;
        }
    }

    public class CallUnsolicitedResponseMessage : CallBaseMessage
    {
        public static const uint8 GROUP_ID = 0x2;

        private CallEvent _message;

        public uint8 call_id;
        public CallBaseMessage.Type call_type;
        public uint8 cause_value;
        public string number;
        public uint8 reject_type;
        public uint8 reject_value;

        construct 
        {
            set_description(GROUP_ID, 0x0, MessageType.INVALID, MessageClass.UNSOLICITED_RESPONSE);

            _message = CallEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            call_id = _message.call_id;
            call_type = (CallBaseMessage.Type) _message.call_type;
            reject_type = _message.reject_type;
            reject_value = _message.reject_value;

            number = "";
            if (_message.caller_id_len > 0)
            {
                var sb = new StringBuilder();
                for (int n = 0; n < _message.caller_id_len; n++)
                {
                    sb.append("%c".printf(_message.caller_id[n]));
                }
                number = sb.str;
            }
        }
    }
}
