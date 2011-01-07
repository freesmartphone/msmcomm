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
    public class MiscService : BaseService, Msmcomm.Misc
    {
        public MiscService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            bool handled = false;

            switch (message.message_type)
            {
                case MessageType.UNSOLICITED_RESPONSE_MISC_RADIO_RESET_IND:
                    radio_reset_ind();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_MISC_CHARGER_STATUS:
                    charger_status(ChargerStatusInfo());
                    handled = true;
                    break;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async void test_alive() throws GLib.Error, Msmcomm.Error
        {
            var response = yield channel.enqueueAsync(new MiscTestAliveCommandMessage());
            checkResponse(response);
        }

        public async RadioFirmwareVersionInfo get_radio_firmware_version() throws GLib.Error, Msmcomm.Error
        {
            var response = yield channel.enqueueAsync(new MiscGetRadioFirmwareVersionCommandMessage()) as MiscGetRadioFirmwareVersionResponseMessage;
            checkResponse(response);

            var info = RadioFirmwareVersionInfo();
            info.carrier_id = response.carrier_id;
            info.firmware_version = response.firmware_version;

            return info;
        }

        public async ChargerStatusInfo get_charger_status() throws GLib.Error, Msmcomm.Error
        {
            return ChargerStatusInfo();
        }

        public async void set_charge(ChargerStatusInfo info) throws GLib.Error, Msmcomm.Error
        {
        }

        public async void set_date(DateInfo info) throws GLib.Error, Msmcomm.Error
        {
        }

        public async DateInfo get_date() throws GLib.Error, Msmcomm.Error
        {
            throw new Msmcomm.Error.NOT_IMPLEMENTED("GetDate() is not implemented right now");
        }

        public async string get_imei() throws GLib.Error, Msmcomm.Error
        {
            return "";
        }
    }
}
