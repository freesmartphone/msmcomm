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
    public abstract class StateBaseOperationModeMessage : BaseMessage
    {
        public enum Mode
        {
            ONLINE = 0x5,
            OFFLINE = 0x6,
            RESET = 0x7,
        }

        public Mode mode;
    }

    public class StateChangeOperationModeRequestCommandMessage : StateBaseOperationModeMessage
    {
        public static const uint8 GROUP_ID = 0x3;
        public static const uint16 MESSAGE_ID = 0x0;

        private StateChangeOperationModeMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST, MessageClass.COMMAND);

            _message = StateChangeOperationModeMessage();
            set_payload((void*)(&_message), sizeof(StateChangeOperationModeMessage));
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode = (uint8) mode;
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
            set_payload((void*)(&_message), sizeof(StateCallbackResponse));
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;

            switch (_message.result)
            {
                case RESULT_OK:
                    result = MessageResultType.RESULT_OK;
                    break;
                case RESULT_ERROR:
                    result = MessageResultType.ERROR_UNKNOWN;
                    break;
            }
        }
    }

    public class StateUnsolicitedResponseMessage : StateBaseOperationModeMessage
    {
        public static const uint8 GROUP_ID = 0x5;

        public uint8 line;
        public uint8 als_allowed;

        private StateEvent _message;

        construct
        {
            _message = StateEvent();
            set_payload((void*)(&_message), sizeof(StateEvent));
        }

        protected override void check_size(int size, int payload_size)
        {
            /* Quirk for webOS modem firmware version CU 0.5.66(5027) */
            assert(size == payload_size || size == (payload_size + 1));
        }

        protected override void evaluate_data()
        {
            mode = (StateBaseOperationModeMessage.Mode) _message.mode;
            line = _message.line;
            als_allowed = _message.als_allowed;
        }
    }
}
