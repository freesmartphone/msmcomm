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
    public class VoicemailGetInfoCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x27;
        public static const uint16 MESSAGE_ID = 0x0;

        private VoicemailGetInfoMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_VOICEMAIL_GET_INFO, MessageClass.COMMAND);

            _message = VoicemailGetInfoMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class VoicemailReturnResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x28;
        public static const uint16 MESSAGE_ID = 0x0;

        private VoicemailReturnResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_VOICEMAIL_RETURN, MessageClass.SOLICITED_RESPONSE);

            _message = VoicemailReturnResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
        }
    }

    public class VoicemailUrcMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x29;
        public static const uint16 MESSAGE_ID = 0x0;

        private VoicemailEvent _message;

        public uint8 line0_count;
        public uint8 line1_count;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.UNSOLICITED_RESPONSE_VOICEMAIL, MessageClass.UNSOLICITED_RESPONSE);

            _message = VoicemailEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            line0_count = _message.line0_vm_count;
            line1_count = _message.line1_vm_count;
        }
    }
}
