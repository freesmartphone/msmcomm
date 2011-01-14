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
    public class StateChangeOperationModeRequestCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x3;
        public static const uint16 MESSAGE_ID = 0x0;

        private static const uint8 MODE_ONLINE_VALUE = 0x5;
        private static const uint8 MODE_OFFLINE_VALUE = 0x6;
        private static const uint8 MODE_RESET_VALUE = 0x7;

        private StateChangeOperationModeMessage _message;

        public enum Mode
        {
            ONLINE,
            OFFLINE,
            RESET,
        }

        public Mode mode;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST, MessageClass.COMMAND);

            _message = StateChangeOperationModeMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;

            switch (mode)
            {
                case Mode.ONLINE:
                    _message.operation_mode = MODE_ONLINE_VALUE;
                    break;
                case Mode.OFFLINE:
                    _message.operation_mode = MODE_OFFLINE_VALUE;
                    break;
                case Mode.RESET:
                    _message.operation_mode = MODE_RESET_VALUE;
                    break;
            }
        }
    }

    public class StateCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x4;
        public static const uint8 MESSAGE_ID = 0x1;

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
                    result = MessageResultType.RESULT_OK;
                    break;
                case RESULT_ERROR:
                    result = MessageResultType.ERROR_UNKNOWN;
                    break;
            }
        }
    }
}
