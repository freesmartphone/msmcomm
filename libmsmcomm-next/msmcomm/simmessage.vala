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
    public abstract class SimInfoBaseMessage : BaseMessage
    {
        public enum SimField
        {
            IMSI = 0x401,
            MSISDN = 0x419,
        }

        public SimField field_type;
        public string field_data;
    }

    public abstract class SimPinStatusBaseMessage : BaseMessage
    {
        public enum PinType
        {
            PIN1 = 0,
            PIN2 = 1,
        }

        public PinType pin_type;
        public string pin;
    }

    public class SimVerfiyPinCommandMessage : SimPinStatusBaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0xe;

        private SimPinStatusMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_VERIFY_PIN, MessageClass.COMMAND);

            _message = SimPinStatusMessage();
            set_payload((void*)(&_message), sizeof(SimPinStatusMessage));

        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.pin_type = (uint8) pin_type;

            /* FIXME we currently support only pin's of length 4 */
            Memory.copy(_message.pin, pin.data, 4);
        }
    }

    public class SimCallbackResponseMessage : SimInfoBaseMessage
    {
        public static const uint8 GROUP_ID = 0x10;
        public static const uint16 MESSAGE_ID = 0x1;

        private SimCallbackResponse _message;

        public uint8 response_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SIM_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = SimCallbackResponse();
            set_payload((void*)(&_message), sizeof(SimCallbackResponse));
        }

        protected override void evaluate_data()
        {
            if (_message.result0 == 0x2 && _message.result1 == 0x9)
            {
                result = MessageResultType.ERROR_BAD_SIM_STATE;
            }

            ref_id = _message.ref_id;
            field_type = (SimInfoBaseMessage.SimField) _message.field_type;
            response_type = _message.resp_type;

            /* Build field_data string out of byte array from response message */
            var sb = new StringBuilder();
            for (uint n = 0; n < _message.field_length; n++)
            {
                sb.append_c(_message.field_data[n] + 0x30);
            }
            field_data = sb.str;
        }
    }

    public class SimUnsolicitedResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x11;

        construct
        {
            message_class = MessageClass.UNSOLICITED_RESPONSE;
            set_payload(null, 0);
        }
    }

}

