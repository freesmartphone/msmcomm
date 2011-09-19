/**
 * This file is part of msmcommd.
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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
using FsoFramework.StringHandling;
using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public class SmsService : BaseService, Msmcomm.Sms
    {
        public SmsService(ModemControl modem)
        {
            base(modem);
        }

        protected override string repr()
        {
            return "";
        }

        public override bool handleUnsolicitedResponse( LowLevel.BaseMessage message )
        {
            bool handled = false;
            stdout.printf( "\nGroupID/MessageID/RefID:    : %x / %x / %x\n", message.group_id, message.message_id, message.ref_id );

            switch ( message.message_type )
            {
                case LowLevel.MessageType.UNSOLICITED_RESPONSE_SMS_MSG_GROUP:
                    var smsmsg = message as LowLevel.Sms.Urc.MsgGroup;

                    stdout.printf( "UNSOLICITED_RESPONSE_SMS_MSG_GROUP: 0x%x 0x%x\n", smsmsg.GROUP_ID, smsmsg.MESSAGE_ID );
                    stdout.printf( "    ResponseType: 0x%x\n", smsmsg.response_type );

                    /* Message received */
                    if ( smsmsg.response_type == LowLevel.Sms.Urc.MsgGroup.ResponseType.MESSAGE_RECEIVED )
                    {
                         stdout.printf( "Message received\n" );
                        var msg = SmsMessage();
                        msg.sender = smsmsg.sender;
                        msg.pdu = smsmsg.pdu;

                        incomming_message( msg ); // DBUS SIGNAL

                        handled = true;
                    }

                    /* Message send */
                    if ( smsmsg.response_type == LowLevel.Sms.Urc.MsgGroup.ResponseType.MESSAGE_SEND )
                    {
                        handled = true;
                    }

                    /* Message read template */
                    if ( smsmsg.response_type == LowLevel.Sms.Urc.MsgGroup.ResponseType.MESSAGE_READ_TEMPLATE )
                    {
                         stdout.printf( "MESSAGE_READ_TEMPLATE\n" );
                         stdout.printf( "smsc: %s\n", smsmsg.smsc_number );
                         handled = true;
                    }
                    break;

                case LowLevel.MessageType.UNSOLICITED_RESPONSE_SMS_CFG_GROUP:
                    var smsmsg = message as LowLevel.Sms.Urc.CfgGroup;
                    stdout.printf( "UNSOLICITED_RESPONSE_SMS_CFG_GROUP: 0x%x 0x%x\n", smsmsg.GROUP_ID, smsmsg.MESSAGE_ID );
                    //TODO
                    break;
                default:
                    break;
            }

            return handled;
        }

        public async SmsTemplateInfo message_read_template(SmsTemplateType template_type) throws GLib.Error, Msmcomm.Error
        {
            var info = SmsTemplateInfo();
            var message = new LowLevel.Sms.Command.MessageReadTemplate();

            message.template = StringHandling.convertEnum<SmsTemplateType,LowLevel.Sms.TemplateType>( template_type );
            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                // check for correct response type; if we have the correct response, we
                // report finished = true so the async call returns
                switch ( response.message_type )
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SMS_MSG_GROUP:
                        checkResponse(response);
                        var rm = response as LowLevel.Sms.Urc.MsgGroup;

                        if ( rm.response_type == LowLevel.Sms.Urc.MsgGroup.ResponseType.MESSAGE_READ_TEMPLATE )
                        {
                            info.digit_mode = rm.digit_mode;
                            info.number_mode = rm.number_mode;
                            info.number_type = convertEnum<LowLevel.Sms.NumberType,SmsNumberType>(rm.number_type);
                            info.numbering_plan = convertEnum<LowLevel.Sms.NumberingPlan,SmsNumberingPlan>(rm.numbering_plan);
                            info.smsc_number = rm.smsc_number;
                            info.protocol_id = rm.protocol_id;
                            finished = true;
                        }

                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_RETURN:
                        checkResponse(response);
                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_CALLBACK:
                        checkResponse(response);
                        break;
                }

                return finished;
            });

            return info;
        }

        public async void set_gateway_domain() throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sms.Command.ConfigSetGwDomainPref();

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch ( response.message_type )
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SMS_MSG_GROUP:
                        checkResponse(response);
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_RETURN:
                        checkResponse(response);
                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_CALLBACK:
                        checkResponse(response);
                        break;
                }

                return finished;
            });

        }

        public async void set_routes() throws GLib.Error, Msmcomm.Error
        {
        }

        public async void get_message_list() throws GLib.Error, Msmcomm.Error
        {
        }

        public async uint get_memory_status() throws GLib.Error, Msmcomm.Error
        {
            uint memory_message_count = 0;
            var message = new LowLevel.Sms.Command.GetMemoryStatus();

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch ( response.message_type )
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SMS_CFG_GROUP:
                        /* FIXME currently we don't know which bytes contains the number
                         * of stored messages on the sim */
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_RETURN:
                        /* FIXME if we get this type of message something went wrong.
                         * Verify this and try to find out what went wrong */
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SMS_CALLBACK:
                        break;
                }

                return finished;
            });

            return memory_message_count;
        }

        public async void send_message(string smsc, uint8[] pdu) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sms.Command.SendMessage();

            message.smsc = smsc;
            message.pdu = pdu;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

    }
}
