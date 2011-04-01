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
    /* See TS 02.30 Annex B */
    public enum Sups.Feature
    {
        INVALID = 0x0,
        CALL_FORWARD_UNCONDITIONAL = 0x21,
        CALL_FORWARD_MOBILE_BUSY = 0x67,
        CALL_FORWARD_NO_REPLY = 0x61,
        CALL_FORWARD_NOT_REACHABLE = 0x62,
        CALL_FORWARD_ALL = 0x2,
        CALL_FORWARD_ALL_CONDITIONAL = 0x4,
        CALL_WAITING = 0x43,
        CALLING_LINE_IDENTIFICATION_RESTRICTION = 0x31,
    }

    /* See TS 02.30 Annex C */
    public enum Sups.Bearer
    {
        INVALID = 0,
        VOICE = 1,
        DATA = 2,
        FAX = 4,
        DEFAULT = 7,
        SMS = 8,
    }

    public class Sups.Command.Register : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x0;

        private SupsRegisterMessage _message;

        public Sups.Bearer bearer;
        public Sups.Feature feature;
        public string number;

        construct
        {
            set_description( GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SUPS_REGISTER, MessageClass.COMMAND );

            _message = SupsRegisterMessage();
            set_payload( _message.data );
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.feature = feature;
            _message.bearer = bearer;

            // FIXME we need to ensure that the supplied number always fits into the
            // message data structure ... This should be check not with an assert!
            assert( number.length <= _message.number.length );

            uint8[] encoded_number = encode_bcd( number );
            Memory.copy( _message.number, encoded_number, encoded_number.length );
            // somehow the length supplied with the message is always real length - 1
            _message.number_len = (uint8) ( encoded_number.length - 1 );
        }
    }

    public class Sups.Command.Erase : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x1;

        private SupsEraseMessage _message;

        public Sups.Feature feature;

        construct
        {
            set_description( GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SUPS_ERASE, MessageClass.COMMAND );

            _message = SupsEraseMessage();
            set_payload( _message.data );
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.feature = feature;
        }
    }

    public class Sups.Command.Activate : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x2;

        private SupsStatusMessage _message;

        public Sups.Feature feature;

        construct
        {
            set_description( GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SUPS_ACTIVATE, MessageClass.COMMAND );

            _message = SupsStatusMessage();
            set_payload( _message.data );
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.feature = feature;
        }
    }

    public class Sups.Command.Deactivate : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x3;

        private SupsStatusMessage _message;

        public Sups.Feature feature;

        construct
        {
            set_description( GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SUPS_DEACTIVATE, MessageClass.COMMAND );

            _message = SupsStatusMessage();
            set_payload( _message.data );
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.feature = feature;
        }
    }

    public class Sups.Command.Interrogate : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x4;

        private SupsInterrogateMessage _message;

        public Sups.Feature feature;

        construct
        {
            set_description( GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SUPS_INTERROGATE, MessageClass.COMMAND );

            _message = SupsInterrogateMessage();
            set_payload( _message.data );
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.feature = feature;
        }
    }

    public class Sups.Response.Callback : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xa;
        public static const uint16 MESSAGE_ID = 0x1;

        private SupsCallbackResponse _message;

        public uint8 command;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SUPS_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = SupsCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command = _message.command;
        }
    }

    public class Sups.Urc : BaseMessage
    {
        private SupsEvent _message;

        public Sups.Feature feature;
        public Sups.Bearer bearer;
        public string number;

        construct
        {
            message_class = MessageClass.UNSOLICITED_RESPONSE;

            _message = SupsEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            feature = (Sups.Feature) _message.feature;
            bearer = (Sups.Bearer) _message.bearer;
            number = decode_bcd(_message.number, _message.number_len);
        }
    }
}
