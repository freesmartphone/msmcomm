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

using FsoFramework.StringHandling;

namespace Msmcomm.Daemon
{
    public class NetworkService : BaseService, Msmcomm.Network
    {
        public NetworkService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(LowLevel.BaseMessage message)
        {
            var handled = false;
            var urc_service_name = messageTypeNickName(message.message_type, "network-");
            var network_message = message as LowLevel.NetworkUrcMessage;
            var info = NetworkStateInfo();

            if (network_message != null)
            {
                info.operator_name = network_message.operator_name;
                info.rssi = (uint) network_message.rssi;
                info.ecio = (uint) network_message.ecio;
                info.roam = network_message.roam;
                info.gprs_attached = network_message.gprs_attached;
                info.reg_status = convertEnum<LowLevel.NetworkRegistrationStatus,NetworkRegistrationStatus>(network_message.reg_status);
                info.service_status = convertEnum<LowLevel.NetworkServiceStatus,NetworkServiceStatus>(network_message.service_status);
                info.mcc = (uint) network_message.mcc;
                info.mnc = (uint) network_message.mnc;
                info.data_service = convertEnum<LowLevel.NetworkDataService,NetworkDataService>(network_message.data_service);

                info.with_time_update = network_message.time_update;
                info.time = NetworkTimeUpdate();

                if (network_message.time_update)
                {
                    info.time.year = network_message.year;
                    info.time.month = network_message.month;
                    info.time.day = network_message.day;
                    info.time.hours = network_message.hours;
                    info.time.minutes = network_message.minutes;
                    info.time.seconds = network_message.seconds;
                    info.time.timezone_offset = network_message.timezone_offset;
                }

                network_status(urc_service_name, info);
                handled = true;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async void report_rssi(bool enable) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.NetworkReportRssiCommandMessage();
            message.enable = enable;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void report_health(bool enable) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.NetworkReportHealthCommandMessage();
            message.enable = enable;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}

