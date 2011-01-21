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
    public enum NetworkRegistrationStatus
    {
        NO_SERVICE = 0,
        HOME = 1,
        SEARCHING = 2,
        DENIED = 3,
        ROAMING = 4,
    }

    public class NetworkReportRssiCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x6;
        public static const uint16 MESSAGE_ID = 0x1;

        private NetworkReportRssiMessage _message;

        public bool enable;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_NETWORK_REPORT_RSSI, MessageClass.COMMAND);

            _message = NetworkReportRssiMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode = enable ? 1 : 0;
        }
    }

    public class NetworkReportHealthCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x6;
        public static const uint16 MESSAGE_ID = 0x2;

        private NetworkReportHealthMessage _message;

        public bool enable;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_NETWORK_REPORT_RSSI, MessageClass.COMMAND);

            _message = NetworkReportHealthMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode = enable ? 1 : 0;
        }
    }

    public class NetworkCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x7;
        public static const uint16 MESSAGE_ID = 0x0;

        private NetworkCallbackResponse _message;

        public uint16 command;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_NETWORK_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = NetworkCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command = _message.command;
        }
    }
}
