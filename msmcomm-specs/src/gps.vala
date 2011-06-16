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
    [CCode (cprefix = "MSMCOMM_GPS_MODE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum GpsMode
    {
        UNKNOWN,
        STANDALONE,
        MSBASED,
        MSASSISTED,
        OPTIMALSPEED,
        OPTIMALACCURACY,
        OPTIMALDATA
    }

    [CCode (type_id = "MSMCOMM_GPS_FIX_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct GpsFixInfo
    {
        public uint32 timestamp;
        public double longitude;
        public double latitude;
        public double velocity;
    }  

    [DBus (timeout = 12000, name = "org.msmcomm.GPS")]
    public interface GPS : GLib.Object
    {
        public abstract async void pa_set_param() throws Msmcomm.Error, GLib.Error;
        public abstract async void pd_get_position(GpsMode mode, uint8 accuracy) throws Msmcomm.Error, GLib.Error;

        public signal void pd_fix_data(GpsFixInfo info);
        public signal void pd_session_done();

        public signal void xtra_info(string data);
        public signal void xtra_status();
        public signal void xtra_download_request();
    }
}

