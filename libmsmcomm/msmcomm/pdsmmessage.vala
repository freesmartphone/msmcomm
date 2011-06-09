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

using FsoFramework;
using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public class Pdsm.Command.PaSetParam : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x21;
        public static const uint16 MESSAGE_ID = 0x2;

        private PdsmPaSetParmMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PDSM_PA_SET_PARAM, MessageClass.COMMAND);

            _message = PdsmPaSetParmMessage();
            set_payload(_message.data);

        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class Pdsm.Response.PaSetParam : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x22;
        public static const uint16 MESSAGE_ID = 0x2;

        private PdsmPaSetParmResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_PDSM_PA_SET_PARAM, MessageClass.SOLICITED_RESPONSE);

            _message = PdsmPaSetParmResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
        }
    }

    public class Pdsm.Urc.Pd : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x23;
        public static const uint16 MESSAGE_ID = 0x1;

        public static uint32 TIMESTAMP_OFFSET = 315964800;

        private PdsmPdEvent _message;

        public enum ResponseType
        {
           FIX_DATA = 7,
           SESSION_DONE = 8,
           UNKNOWN = -1,
        }

        public ResponseType response_type;

        /* response_type = ResponseType.FIX_DATA */
        public uint32 timestamp;
        public double longitude;
        public double latitude;
        public float velocity;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.UNSOLICITED_RESPONSE_PDSM_PD, MessageClass.UNSOLICITED_RESPONSE);

            _message = PdsmPdEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            response_type = (ResponseType) _message.response_type;

            switch (response_type)
            {
                case ResponseType.FIX_DATA:
                    timestamp = _message.timestamp + TIMESTAMP_OFFSET;
                    latitude = parseDouble(_message.latitude_low, _message.latitude_high);
                    longitude = parseDouble(_message.longitude_low, _message.longitude_high);
                    velocity = ((float)(_message.velocity / 10)) / 3.6f; // it's now in m/s
                    break;
                case ResponseType.SESSION_DONE:
                    break;
                default:
                    response_type = ResponseType.UNKNOWN;
                    theLogger.error(@"Found unknown $(message_type) response type: 0x%02x".printf(_message.response_type));
                    break;
            }
        }
    }
}
