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
    [CCode (cprefix = "MSMCOMM_OPERATION_MODE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum OperationMode
    {
        RESET,
        OFFLINE,
        ONLINE,
    }

    [CCode (type_id = "MSMCOMM_STATE_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct StateInfo
    {
        public OperationMode mode;
        public uint line;
        public uint als_allowed;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.State")]
    public interface State : GLib.Object
    {
        public abstract async void change_operation_mode(OperationMode mode) throws GLib.Error, Msmcomm.Error;

        public signal void operation_mode(StateInfo info);
        public signal void info_avail(StateInfo info);
    }
}
