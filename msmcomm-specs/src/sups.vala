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
    [CCode (cprefix = "MSMCOMM_SUPS_FEATURE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SupsFeature
    {
        CALL_FORWARD_UNCONDITIONAL,
        CALL_FORWARD_MOBILE_BUSY,
        CALL_FORWARD_NO_REPLY,
        CALL_FORWARD_NOT_REACHABLE,
        CALL_FORWARD_ALL,
        CALL_FORWARD_ALL_CONDITIONAL,
        CALL_WAITING,
        CALLING_LINE_IDENTIFICATION_RESTRICTION
    }

    [CCode (cprefix = "MSMCOMM_SUPS_BEARER_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SupsBearer
    {
        VOICE,
        DATA,
        FAX,
        DEFAULT,
        SMS
    }

    [CCode (type_id = "MSMCOMM_SUPS_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct SupsInfo
    {
        public SupsFeature feature;
        public SupsBearer bearer;
        public string number;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.Sups")]
    public interface Sups : GLib.Object
    {
        public abstract async void register_(SupsFeature feature, SupsBearer bearer, string number) throws GLib.Error, Msmcomm.Error;
        public abstract async void erase(SupsFeature feature) throws GLib.Error, Msmcomm.Error;
        public abstract async void activate(SupsFeature feature) throws GLib.Error, Msmcomm.Error;
        public abstract async void deactivate(SupsFeature feature) throws GLib.Error, Msmcomm.Error;
        public abstract async SupsInfo interrogate(SupsFeature feature) throws GLib.Error, Msmcomm.Error;
    }
}
