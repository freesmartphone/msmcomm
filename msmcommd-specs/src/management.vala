/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm
{
    [DBus (use_string_marshalling = true)]
    public enum ModemControlStatus
    {
        INACTIVE,
        ACTIVE,
        UNKNOWN,
    }

    [DBus (name = "org.msmcomm.Management")]
    public errordomain Error
    {
        INVALID_ARGUMENTS,
        FAILED,
        MODEM_INACTIVE,
    }


    public string modemControlStatusToString(ModemControlStatus status)
    {
        string result = "<UNKNOWN>";

        switch (status)
        {
            case ModemControlStatus.INACTIVE:
                result = "INACTIVE";
                break;
            case ModemControlStatus.ACTIVE:
                result = "ACTIVE";
                break;
            case ModemControlStatus.UNKNOWN:
                result = "UNKNOWN";
                break;
        }

        return result;
    }
    
    [DBus (timeout = 120000, name = "org.msmcomm.Management")]
    public interface Management : GLib.Object
    {
        public abstract async void reset() throws GLib.Error, Msmcomm.Error;
        public abstract async void initialize() throws GLib.Error, Msmcomm.Error;
        public abstract async void shutdown() throws GLib.Error, Msmcomm.Error;
        public abstract async bool get_active() throws GLib.Error, Msmcomm.Error;

        public signal void status_update(ModemControlStatus status);
    }
}
