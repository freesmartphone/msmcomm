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

        public async void message_read_template(SmsTemplateType template_type) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sms.Command.MessageReadTemplate();
            message.template = StringHandling.convertEnum<SmsTemplateType,LowLevel.Sms.TemplateType>( template_type );

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

#if DEBUG
                debug( @"Processing $(message.message_type) ..." );
#endif

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
                    default:
                        throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
                }

                return finished;
            });
        }
    }
}
