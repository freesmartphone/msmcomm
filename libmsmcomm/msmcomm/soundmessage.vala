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
    public enum SoundDeviceClass
    {
        HANDSET = 0,
        HEADSET = 1,
        BTHEADSET = 2,
        SPEAKER = 3,
        HEADSETWITHOUTMIC = 4,
        WIREDSPEAKER = 5,
        BTCARKIT = 6,
        BTSPEAKER = 7,
        WIREDSTEREO = 8,
        TTYFULL = 10,
        TTYVC0 = 11,
        TTYHC0 = 12,
    }

    public enum SoundDeviceSubClass
    {
        DEFAULT = 0,
        HANDSET_SLIDER_CLOSED = 0,
        HANDSET_SLIDER_OPEN = 1,
        HEADSET_MUSE = 7,
        BTHEADSET_ECHOCANCEL_INHANDSET = 0,
        BTHEADSET_ECHOCANCEL_INHEADSET = 1,
        SPEAKER_SLIDER_CLOSED = 0,
        SPEKAER_SLIDER_OPEN = 1,
        SPEAKER_VOL_MIN = 6,
        SPEAKER_VOL_1 = 4,
        SPEAKER_VOL_2 = 2,
        SPEAKER_VOL_MAX = 0,
    }

    public class SoundSetDeviceCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1e;
        public static const uint16 MESSAGE_ID = 0x0;

        private SoundSetDeviceMessage _message;

        public SoundDeviceClass device_class;
        public SoundDeviceSubClass device_sub_class;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SOUND_SET_DEVICE, MessageClass.COMMAND);

            _message = SoundSetDeviceMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.device_class = (uint8) device_class;
            _message.device_sub_class = (uint8) device_sub_class;
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
