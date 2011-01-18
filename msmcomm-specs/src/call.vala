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
    [CCode (cprefix = "MSMCOMM_SUPS_ACTION_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SupsAction
    {
        DROP_ALL_OR_SEND_BUSY,
        DROP_ALL_AND_ACCEPT_WAITING_OR_HELD,
        DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
        HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD,
        HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD,
        ACTIVATE_HELD,
        DROP_SELF_AND_CONNECT_ACTIVE,
    }

    [CCode (cprefix = "MSMCOMM_CALL_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum CallType
    {
        AUDIO,
        DATA,
    }

    [CCode (type_id = "MSMCOMM_CALL_STATUS_INFO", cheader_filename="msmcomm-specs.h")]
    public struct CallStatusInfo
    {
        public uint id;
        public CallType type;
        public string number;
    }

    [DBus (timeout = 12000, name = "org.msmcomm.Call")]
    public interface Call : GLib.Object
    {
        public abstract async void originate(string number, bool suppress_own_number) throws Msmcomm.Error, GLib.Error;
        public abstract async void answer(uint id) throws Msmcomm.Error, GLib.Error;
        public abstract async void end(uint id) throws Msmcomm.Error, GLib.Error;
        public abstract async void sups(uint id, SupsAction action) throws Msmcomm.Error, GLib.Error;

        public signal void call_status(string type, CallStatusInfo info);
    }
}
