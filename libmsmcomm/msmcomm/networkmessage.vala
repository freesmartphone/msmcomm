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

    public enum NetworkServiceStatus
    {
        NO_SERVICE = 0,
        LIMITED = 1,
        FULL = 2,
    }

    public enum NetworkDataService
    {
        NONE = 0,
        GPRS = 2,
        EDGE = 3,
        HSDPA = 5,
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
        public static const uint16 MESSAGE_ID = 0x1;

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

    public class NetworkUrcMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x8;

        private NetworkStateInfoEvent _message;

        public uint16 mcc;
        public uint8 mnc;
        public uint16 rssi;
        public uint16 ecio;
        public string operator_name;
        public NetworkRegistrationStatus reg_status;
        public NetworkServiceStatus service_status;
        public bool gprs_attached;
        public bool roam;
        public bool time_update;
        public uint8 year;
        public uint8 month;
        public uint8 day;
        public uint8 hours;
        public uint8 minutes;
        public uint8 seconds;
        public uint16 timezone_offset;
        public NetworkDataService data_service;

        construct
        {
            group_id = GROUP_ID;
            message_class = MessageClass.UNSOLICITED_RESPONSE;

            _message = NetworkStateInfoEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            mcc = parseMcc(_message.mcc);
            mnc = parseMnc(_message.mnc);
            rssi = _message.rssi;
            ecio = _message.ecio;
            operator_name = _message.operator_name_len > 0 ? convertBytesToString(_message.operator_name) : "";
            reg_status = (NetworkRegistrationStatus) _message.reg_status;
            service_status = (NetworkServiceStatus) _message.serv_status;
            gprs_attached = _message.gprs_attached == 1 ? true : false;
            roam = _message.roam == 1 ? true : false;
            time_update = _message.with_nitz_update == 1 ? true : false;
            year = _message.year;
            month = _message.month;
            day = _message.day;
            hours = _message.hours;
            minutes = _message.minutes;
            seconds = _message.seconds;
            timezone_offset = _message.timezone_offset * 0xf;
            data_service = (NetworkDataService) _message.gsm_icon_ind;
        }
    }
}
