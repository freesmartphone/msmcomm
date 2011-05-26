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
    public class SupsService : BaseService, Msmcomm.Sups
    {
        public SupsService(ModemControl modem)
        {
            base(modem);
        }

        protected override string repr()
        {
            return "";
        }

        public async void register_(SupsFeature feature, SupsBearer bearer, string number) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sups.Command.Register();
            message.feature = StringHandling.convertEnum<SupsFeature, LowLevel.Sups.Feature>(feature);
            message.bearer = StringHandling.convertEnum<SupsBearer, LowLevel.Sups.Bearer>(bearer);
            message.number = number;

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_REGISTER:
                        break;
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_REGISTER_CONF:
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SUPS_CALLBACK:
                        break;
                }

                return finished;
            });
        }

        public async void erase(SupsFeature feature) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sups.Command.Erase();
            message.feature = StringHandling.convertEnum<SupsFeature, LowLevel.Sups.Feature>(feature);

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_ERASE:
                        break;
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_ERASE_CONF:
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SUPS_CALLBACK:
                        break;
                }

                return finished;
            });
        }

        public async void activate(SupsFeature feature) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sups.Command.Activate();
            message.feature = StringHandling.convertEnum<SupsFeature, LowLevel.Sups.Feature>(feature);

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_ACTIVATE:
                        break;
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_ACTIVATE_CONF:
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SUPS_CALLBACK:
                        break;
                }

                return finished;
            });
        }

        public async void deactivate(SupsFeature feature) throws GLib.Error, Msmcomm.Error
        {
            var message = new LowLevel.Sups.Command.Deactivate();
            message.feature = StringHandling.convertEnum<SupsFeature, LowLevel.Sups.Feature>(feature);

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_DEACTIVATE:
                        break;
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_DEACTIVATE_CONF:
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SUPS_CALLBACK:
                        break;
                }

                return finished;
            });
        }

        public async SupsInfo interrogate(SupsFeature feature) throws GLib.Error, Msmcomm.Error
        {
            var info = SupsInfo();
            info.feature = feature;
            info.number = "";
            info.bearer = SupsBearer.DEFAULT;

            var message = new LowLevel.Sups.Command.Interrogate();
            message.feature = StringHandling.convertEnum<SupsFeature, LowLevel.Sups.Feature>(feature);

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_INTERROGATE:
                        break;
                    case LowLevel.MessageType.UNSOLICITED_RESPONSE_SUPS_INTERROGATE_CONF:
                        var msg = response as LowLevel.Sups.Urc;
                        info.number = msg.number;
                        info.bearer = StringHandling.convertEnum<LowLevel.Sups.Bearer,SupsBearer>(msg.bearer);
                        debug( @"bearer = $(info.bearer) ; $(msg.bearer)" );
                        finished = true;
                        break;
                    case LowLevel.MessageType.RESPONSE_SUPS_CALLBACK:
                        break;
                }

                return finished;
            });

            return info;
        }

    }
}
