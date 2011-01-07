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
    [CCode (type_id = "MSMCOMM_RADIO_FIRMWARE_VERSION_INFO", cheader_filename="msmcomm-specs.h")]
    public struct RadioFirmwareVersionInfo
    {
        public string firmware_version;
        public uint carrier_id;
    }

    [CCode (cprefix = "MSMCOMM_CHARGER_MODE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum ChargerMode
    {
        USB,
        INDUCTIVE,
    }

    [CCode (cprefix = "MSMCOMM_CHARGER_VOLTAGE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum ChargerVoltage
    {
        VOLTAGE_250mA,
        VOLTAGE_500mA,
        VOLTAGE_1000mA,
    }

    [CCode (type_id = "MSMCOMM_CHARGER_STATUS_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct ChargerStatusInfo
    {
        public ChargerMode mode;
        public ChargerVoltage voltage;
    }

    [CCode (cprefix = "MSMCOMM_TIME_SOURCE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum TimeSource
    {
        MANUAL,
        NETWORK,
    }

    [CCode (type_id = "MSMCOMM_DATE_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct DateInfo
    {
        public uint year;
        public uint month;
        public uint day;
        public uint hours;
        public uint minutes;
        public uint seconds;
        public int timezone_offset;
        public TimeSource time_source;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.Misc")]
    public interface Misc : GLib.Object
    {
        public abstract async void test_alive() throws GLib.Error, Msmcomm.Error;
        public abstract async RadioFirmwareVersionInfo get_radio_firmware_version() throws GLib.Error, Msmcomm.Error;
        public abstract async ChargerStatusInfo get_charger_status() throws GLib.Error, Msmcomm.Error;
        public abstract async void set_charge(ChargerStatusInfo info) throws GLib.Error, Msmcomm.Error;
        public abstract async void set_date(DateInfo info) throws GLib.Error, Msmcomm.Error;
        public abstract async DateInfo get_date() throws GLib.Error, Msmcomm.Error;
        public abstract async string get_imei() throws GLib.Error, Msmcomm.Error;

        public signal void radio_reset_ind();
        public signal void charger_status(ChargerStatusInfo info);
    }
}
