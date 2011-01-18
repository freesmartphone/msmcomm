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
    [CCode (cprefix = "MSMCOMM_SIM_PIN_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SimPinType
    {
        PIN1,
        PIN2,
    }

    [CCode (cprefix = "MSMCOMM_SIM_FIELD_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SimField
    {
        IMSI,
        MSISDN,
    }

    [CCode (type_id = "MSMCOMM_SIM_CAPABILITIES_INFO", cheader_filename="msmcomm-specs.h")]
    public struct SimCapabilitiesInfo
    {
        SimField field_type;
        string field_data;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.SIM")]
    public interface Sim : GLib.Object
    {
        public abstract async void verify_pin(SimPinType pin_type, string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void change_pin(string old_pin, string new_pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void enable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void disable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async SimCapabilitiesInfo get_sim_capabilities(SimField field_type) throws GLib.Error, Msmcomm.Error;
        public abstract async void get_all_pin_status_info() throws GLib.Error, Msmcomm.Error;

        public signal void sim_status(string name);
    }
}
