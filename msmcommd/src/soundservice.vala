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
    public class SoundService : BaseService, Msmcomm.Sound
    {
        public SoundService(ModemControl modem)
        {
            base(modem);
        }

        public override string repr()
        {
            return "<>";
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            // NOTE: we currently don't have any sound unsolicited response messages to
            // support
            return false;
        }

        public async void set_device(SoundDeviceClass device_class, SoundDeviceSubClass device_sub_class) throws Msmcomm.Error, GLib.Error
        {
            var message = new SoundSetDeviceCommandMessage();
            message.device_class =
                StringHandling.convertEnum<SoundDeviceClass,Msmcomm.LowLevel.SoundDeviceClass>(device_class);
            message.device_sub_class =
                StringHandling.convertEnum<SoundDeviceSubClass,Msmcomm.LowLevel.SoundDeviceSubClass>(device_sub_class);

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}
