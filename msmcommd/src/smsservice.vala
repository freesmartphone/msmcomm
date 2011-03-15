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

        public async void read_template(SmsTemplateType template_type) throws GLib.Error, Msmcomm.Error
        {
            var message = new Wms.Command.MessageReadTemplate();
            message.template = StringHandling.convertEnum<SmsTemplateType,LowLevel.Wms.TemplateType>( template_type );

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SMS_RETURN:
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SMS_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }
        }
    }
}
