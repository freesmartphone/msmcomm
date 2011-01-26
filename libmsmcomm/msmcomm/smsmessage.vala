/* 
 * File Name: 
 * Creation Date: 
 * Last Modified: 
 *
 * Authored by Frederik 'playya' Sdun <Frederik.Sdun@googlemail.com>
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
        public class WmsSendMessageMessage : BaseMessage
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

        public class WmsAcknowledgeMessageMessage : BaseMessage
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

        public class WmsReadMessageMessage : BaseMessage
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

        /*public class WmsWriteMessageMessage : BaseMessage
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

        public class WmsDeleteMessageMessage : BaseMessage
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

        public class WmsReadTemplateMessageMessage : BaseMessage
        {
            public static const uint8 GROUP_ID = 0x15;
            public static const uint16 MESSAGE_ID = 0x11;

            public uint8 record;

            private WmsReadTemplateMessage _message;

            construct
            {
                set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SMS_READ_MESSAGE, MessageClass.COMMAND);
                _message = WmsReadTemplateMessage();
                set_payload(_message.data);
            }

            protected override void prepare_data()
            {
                _message.ref_id = ref_id;
                _message.record = record;
            }
        }

        public class WmsReturnResponseMessage : BaseMessage
        {
            public static const uint8 GROUP_ID = 0x16;
            public static const uint16 MESSAGE_ID = 0x00;

            construct
            {
                set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SMS_RETURN, MessageClass.SOLICITED_RESPONSE);
            }
        }

        public class WmsCallbackResponseMessage : BaseMessage
        {
            public static const uint8 GROUP_ID = 0x16;
            public static const uint16 MESSAGE_ID = 0x01;

            public uint8 command_id;

            private WmsCallbackResponse _message;

            construct
            {
                set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SMS_RETURN, MessageClass.SOLICITED_RESPONSE);
                _message = WmsCallbackResponse();
                set_payload(_message.data);
            }

            protected override void evaluate_data()
            {
                command_id = _message.command_id;
            }
        }
}
