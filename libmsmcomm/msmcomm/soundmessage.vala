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
    public class SoundSetDeviceCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1e;
        public static const uint16 MESSAGE_ID = 0x0;

        private SoundSetDeviceMessage _message;

        public uint8 class;
        public uint8 sub_class;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SOUND_SET_DEVICE, MessageClass.COMMAND);

            _message = SoundSetDeviceMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.class = class;
            _message.sub_class = sub_class;
        }
    }

    public class SoundCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1f;
        public static const uint16 MESSAGE_ID = 0x1;

        private SoundCallbackResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SOUND_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = SoundCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
        }
    }
}
