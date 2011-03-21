/* 
 * This file is part of libmsmcomm.
 *
 * (c) 2011 Frederik 'playya' Sdun <Frederik.Sdun@googlemail.com>
 *          Simon Busch <morphis@gravedo.de>
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
 */

using GLib;
using FsoFramework;
using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public enum Sms.TemplateType
    {
        SMSC_NUMBER = 0x2,
        EMAIL_ADDRESS = 0x102;
    }

    /* As per 23.040 Section 9.1.2.5 */
    public enum Sms.NumberType
    {
        UNKNOWN = 0,
        INTERNATIONAL = 1,
        NATIONAL = 2,
        NETWORK_SPECIFIC = 3,
        SUBSCRIBER = 4,
        ALPHANUMERIC = 5,
        ABBREVIATED = 6,
        RESERVED = 7
    }

    /* As per 23.040 Section 9.1.2.5 */
    public enum Sms.NumberingPlan
    {
        UNKNOWN = 0,
        ISDN = 1,
        DATA = 3,
        TELEX = 4,
        SC1 = 5,
        SC2 = 6,
        NATIONAL = 8,
        PRIVATE = 9,
        ERMES = 10,
        RESERVED = 15
    }

    public enum Sms.GatewayDomainType
    {
        GSM,
    }

    public class Sms.Command.SendMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0a;
        public string smsc;
        public uint8[] pdu;
        private WmsSendMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
            _message = WmsSendMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            FsoFramework.Utility.copyData(ref _message.pdu, pdu, 255);
            FsoFramework.Utility.copyData(ref _message.service_center, smsc.data, 36);
        }
    }

    public class Sms.Command.AcknowledgeMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0b;

        public uint8 value0;
        public uint8 value1;

        private WmsAcknowledgeMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
            _message = WmsAcknowledgeMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.value0 = 1;
            _message.value1 = 1;
        }
    }

    public class Sms.Command.ReadMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0c;

        private WmsReadMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
            _message = WmsReadMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    /*public class Sms.Command.WriteMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0d;
        private Wms _message;
        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
            _message = WmsReadMessage();
            set_payload(_message.data);
        }
    }*/

    public class Sms.Command.DeleteMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0e;
        private WmsDeleteMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
            _message = WmsDeleteMessage();
            set_payload(_message.data);
        }
    }

    public class Sms.Command.MessageReadTemplate : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x11;

        public Sms.TemplateType template;

        private WmsReadTemplateMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_MESSAGE_READ_TEMPLATE, MessageClass.COMMAND);
            _message = WmsReadTemplateMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.template = (uint16) template;
        }
    }

    public class Sms.Command.ConfigSetGwDomainPref : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x4;

        private WmsCfgSetGwDomainPrefMessage _message;

        public Sms.GatewayDomainType gateway_domain;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_CONFIG_SET_GW_DOMAIN_PREF, MessageClass.COMMAND);

            _message = WmsCfgSetGwDomainPrefMessage();
            set_payload(_message.data);

            gateway_domain = Sms.GatewayDomainType.GSM;
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class Sms.Command.ConfigSetRoutes : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x0;

        private WmsCfgSetRoutesMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_CONFIG_SET_ROUTES, MessageClass.COMMAND);

            _message = WmsCfgSetRoutesMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;

            // the following byte sequence is always the same for this command. The
            // meaning of the bytes is still unknown ...
            var unknown_bytes = new uint8[] {
                0x02, 0x00, 0x02, 0x00, 0x01, 0x02, 0x02, 0x00, 0x02,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            };

            Memory.copy(_message.unknown_bytes, unknown_bytes, 25);
        }
    }

    public class Sms.Command.ConfigGetMessageList : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x3;

        private WmsCfgGetMessageListMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_CONFIG_GET_MESSAGE_LIST, MessageClass.COMMAND);

            _message = WmsCfgGetMessageListMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.value0 = 0x2;
        }
    }

    public class Sms.Response.Return : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x16;
        public static const uint16 MESSAGE_ID = 0x00;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SMS_RETURN, MessageClass.SOLICITED_RESPONSE);
        }

        protected override void evaluate_data()
        {
        }
    }

    public class Sms.Response.Callback : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x16;
        public static const uint16 MESSAGE_ID = 0x01;

        private WmsCallbackResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SMS_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = WmsCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            command_id = _message.command;
            ref_id = _message.ref_id;

            switch ( _message.rc )
            {
                case 0x4:
                    result = MessageResult.ERROR_BAD_SIM_STATE;
                    break;
            }
        }
    }

    public class Sms.Urc.MsgGroup : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x17;
        public static const uint16 MESSAGE_ID = 0x2;

        private WmsMsgGroupEvent _message;

        public enum ResponseType
        {
            MESSAGE_SEND = 0x0,
            MESSAGE_READ = 0x2,
            MESSAGE_DELETE = 0x4,
            MESSAGE_READ_TEMPLATE = 0x7,
            SMS_POINT_TO_POINT = 0xf,
            MESSAGE_SUBMIT_REPORT = 0x10,
            UNKNOWN,
        }

        public ResponseType response_type;

        /* response_type == ResponseType.MESSAGE_READ_TEMPLATE */
        public uint8 digit_mode;
        public uint32 number_mode;
        public NumberType number_type;
        public NumberingPlan numbering_plan;
        public string smsc_number;
        public uint8 protocol_id; /* See 23.040 Section 9.2.3.9 for valid values */

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.UNSOLICITED_RESPONSE_SMS_MSG_GROUP, MessageClass.UNSOLICITED_RESPONSE);

            _message = WmsMsgGroupEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            response_type = (ResponseType) _message.response_type;

            switch ( _message.response_type )
            {
                case ResponseType.MESSAGE_SEND:
                    break;
                case ResponseType.MESSAGE_READ:
                    break;
                case ResponseType.MESSAGE_DELETE:
                    break;
                case ResponseType.MESSAGE_READ_TEMPLATE:
                    /* FIXME we need to check received_mask for different values */
                    number_mode = _message.wms_read_template.number_mode;
                    number_type = (NumberType) _message.wms_read_template.number_type;
                    numbering_plan = (NumberingPlan) _message.wms_read_template.numbering_plan;

                    smsc_number = Utility.dataToString(_message.wms_read_template.smsc_number,
                                                       _message.wms_read_template.smsc_number_len);

                    protocol_id = _message.wms_read_template.protocol_id;
                    break;
                case ResponseType.SMS_POINT_TO_POINT:
                    break;
                case ResponseType.MESSAGE_SUBMIT_REPORT:
                    break;
                default:
                    response_type = ResponseType.UNKNOWN;
                    theLogger.error( "Found unknown $(message_type) response type: 0x%02x".printf(_message.response_type ) );
                    break;
            }
        }
    }
}
