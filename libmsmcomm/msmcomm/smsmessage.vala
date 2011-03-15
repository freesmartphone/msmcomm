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
using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public enum Wms.TemplateType
    {
        SMSC_NUMBER = 0x2,
        EMAIL_ADDRESS = 0x102;
    }

    public class Wms.Command.SendMessage : BaseMessage
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

    public class Wms.Command.AcknowledgeMessage : BaseMessage
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

    public class Wms.Command.ReadMessage : BaseMessage
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

    /*public class Wms.Command.WriteMessage : BaseMessage
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

    public class Wms.Command.DeleteMessage : BaseMessage
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

    public class Wms.Command.MessageReadTemplate : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x15;
        public static const uint16 MESSAGE_ID = 0x11;

        public Wms.TemplateType template;

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

    public class Wms.Response.Return : BaseMessage
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

    public class Wms.Response.Callback : BaseMessage
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
                    result = MessageResultType.ERROR_BAD_SIM_STATE;
                    break;
            }
        }
    }

    public class Wms.Urc.MsgGroup : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x17;
        public static const uint16 MESSAGE_ID = 0x2;

        private WmsMsgGroupEvent _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.UNSOLICITED_RESPONSE_WMS_MSG_GROUP, MessageClass.UNSOLICITED_RESPONSE);

            _message = WmsMsgGroupEvent();
            set_payload(_message.data);
        }
    }
}
