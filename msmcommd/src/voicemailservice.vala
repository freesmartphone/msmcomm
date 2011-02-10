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
    public class VoicemailService : BaseService, Msmcomm.Voicemail
    {
        public VoicemailService(ModemControl modem)
        {
            base(modem);
        }

        public override string repr()
        {
            return "<>";
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            var handled = false;
            var vm_message = message as VoicemailUrcMessage;

            if (vm_message != null)
            {
                handled = true;
                info(vm_message.line0_count, vm_message.line1_count);
            }

            return handled;
        }

        public async void get_info() throws Msmcomm.Error, GLib.Error
        {
            var message = new VoicemailGetInfoCommandMessage();
            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}
