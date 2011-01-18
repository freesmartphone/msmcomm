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

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public class CallService : BaseService, Msmcomm.Call
    {
        public CallService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            var handled = false;
            var urc_service_name = messageTypeNickName(message.message_type);
            var call_message = message as CallUnsolicitedResponseMessage;
            var info = CallStatusInfo();

            if (call_message != null)
            {
                info.id = call_message.call_id;
                info.type = convertCallTypeForService(call_message.call_type);
                info.number = call_message.number;

                call_status(urc_service_name, info);

                handled = true;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async void originate_call(string number, bool suppress_own_number) throws Msmcomm.Error, GLib.Error
        {
            var message = new CallOriginationCommandMessage();
            message.number = number;
            message.suppress_own_number = suppress_own_number;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void answer_call(uint id) throws Msmcomm.Error, GLib.Error
        {
            var message = new CallAnswerCommandMessage();
            message.call_id = (uint8) id;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void end_call(uint id) throws Msmcomm.Error, GLib.Error
        {
            var message = new CallEndCommandMessage();
            message.call_id = (uint8) id;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void sups_call(uint id, SupsAction action) throws Msmcomm.Error, GLib.Error
        {
            var message = new CallSupsCommandMessage();
            message.call_id = (uint8) id;
            message.action = convertSupsActionForModem(action);

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}

