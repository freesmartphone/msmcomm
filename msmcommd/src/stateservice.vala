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
using FsoFramework.StringHandling;

namespace Msmcomm.Daemon
{
    public class StateService : BaseService, Msmcomm.State
    {
        public StateService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            switch (message.message_type)
            {
                case MessageType.UNSOLICITED_RESPONSE_STATE_OPRT_MODE:
                    var info = parseUrcMessage(message as StateUnsolicitedResponseMessage);
                    operation_mode(info);
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_STATE_INFO_AVAIL:
                    var info = parseUrcMessage(message as StateUnsolicitedResponseMessage);
                    info_avail(info);
                    return true;
            }

            return false;
        }

        private StateInfo parseUrcMessage(StateUnsolicitedResponseMessage message)
        {
            var info = StateInfo();

            info.mode = convertEnum<Msmcomm.LowLevel.State.OperationMode,OperationMode>(message.mode);
            info.line = message.line;
            info.als_allowed = message.als_allowed;

            return info;
        }

        protected override string repr()
        {
            return "";
        }

        public async void change_operation_mode(OperationMode mode) throws GLib.Error, Msmcomm.Error
        {
            var message = new StateChangeOperationModeRequestCommandMessage();
            message.mode = convertEnum<OperationMode,Msmcomm.LowLevel.State.OperationMode>(mode);

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void sys_sel_pref(NetworkModePreference mode_preference) throws GLib.Error, Msmcomm.Error
        {
            var message = new StateSysSelPrefCommandMessage();
            message.mode_preference = convertEnum<NetworkModePreference,Msmcomm.LowLevel.State.NetworkModePreference>(mode_preference);

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}
