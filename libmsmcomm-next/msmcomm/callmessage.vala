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

using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public class CallOriginationCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x0;

        private const uint8 BLOCK_MODE_ON = 0xc;
        private const uint8 BLOCK_MODE_OFF = 0xb;

        private CmCallOriginationMessage _message;

        public string number;
        public bool suppress_own_number;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_ORIGINATION);

            number = "";
            suppress_own_number = false;

            _message = CmCallOriginationMessage();
            set_payload((void*)(&_message), sizeof(CmCallOriginationMessage));

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

        private CmCallAnswerMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_ANSWER);

            _message = CmCallAnswerMessage();
            set_payload((void*)(&_message), sizeof(CmCallAnswerMessage));

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

        private CmCallEndMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_END);

            _message = CmCallEndMessage();
            set_payload((void*)(&_message), sizeof(CmCallEndMessage));

            /* Some unknown values which have to be set */
            _message.value0 = 0x1;
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.call_id = call_id;
        }
    }

    public class CallSupsCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x3;

        public enum Action
        {
            DROP_ALL_OR_SEND_BUSY = 0,
            DROP_ALL_AND_ACCEPT_WAITING_OR_HELD = 1,
            DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD = 1,
            HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD = 2,
            HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD = 2,
            ACTIVATE_HELD = 3,
            DROP_SELF_AND_CONNECT_ACTIVE = 4,
        }

        public uint8 call_id;
        public Action action;

        private CmCallSupsMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_CALL_SUPS);

            _message = CmCallSupsMessage();
            set_payload((void*)(&_message), sizeof(CmCallSupsMessage));
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

        private CmCallCallbackResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_CALL_CALLBACK);

            _message = CmCallCallbackResponse();
            set_payload((void*)(&_message), sizeof(CmCallCallbackResponse));
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command_type = _message.cmd_type;

            switch (_message.result)
            {
                case RESULT_BAD_CALL_ID_VALUE:
                    result = MessageResultType.ERROR_BAD_CALL_ID;
                    break;
                case RESULT_ERROR_VALUE:
                    result = MessageResultType.ERROR_UNKNOWN;
                    break;
            }
        }
    }

    public class CallReturnResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1;
        public static const uint16 MESSAGE_ID = 0x1;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_CALL_CALLBACK);
        }
    }
}
