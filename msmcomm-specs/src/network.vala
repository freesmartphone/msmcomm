/**
 * This file is part of msmcomm-specs
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
 * GNU General Public License for more infos.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm
{
    [CCode (type_id = "MSMCOMM_NETWORK_STATUS_INFO", cheader_filename="msmcomm-specs.h")]
    public struct NetworkStateInfo
    {
        public uint mcc;
        public uint mnc;
        public NetworkRegistrationStatus reg_status;
        public string operator_name;
        public uint rssi;
        public uint ecio;
        public bool gprs_attached;
        public bool roam;
    }

    [CCode (cprefix = "MSMCOMM_NETWORK_REGISTRATION_STATUS_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum NetworkRegistrationStatus
    {
        NO_SERVICE,
        HOME,
        SEARCHING,
        DENIED,
        ROAMING,
    }

    [DBus (timeout = 12000, name = "org.msmcomm.Network")]
    public interface Network : GLib.Object
    {
        public abstract async void report_rssi(bool enable) throws Msmcomm.Error, GLib.Error;
        public abstract async void report_health(bool enable) throws Msmcomm.Error, GLib.Error;

        public signal void network_status(string name, NetworkStateInfo info);
    }
}

