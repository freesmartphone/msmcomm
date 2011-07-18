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
    [CCode (cprefix = "MSMCOMM_SOUND_DEVICE_CLASS_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SoundDeviceClass
    {
        HANDSET,
        HEADSET,
        BTHEADSET,
        SPEAKER,
        HEADSETWITHOUTMIC,
        WIREDSPEAKER,
        BTCARKIT,
        BTSPEAKER,
        WIREDSTEREO,
        TTYFULL,
        TTYVC0,
        TTYHC0,
    }

    [CCode (cprefix = "MSMCOMM_SOUND_DEVICE_SUB_CLASS_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SoundDeviceSubClass
    {
        DEFAULT,
        HANDSET_SLIDER_CLOSED,
        HANDSET_SLIDER_OPEN,
        HEADSET_MUSE,
        BTHEADSET_ECHOCANCEL_INHANDSET,
        BTHEADSET_ECHOCANCEL_INHEADSET,
        SPEAKER_SLIDER_CLOSED,
        SPEKAER_SLIDER_OPEN,
        SPEAKER_VOL_MIN,
        SPEAKER_VOL_1,
        SPEAKER_VOL_2,
        SPEAKER_VOL_MAX,
    }

    [DBus (timeout = 120000, name = "org.msmcomm.Sound")]
    public interface Sound : GLib.Object
    {
        public abstract async void set_device(SoundDeviceClass class, SoundDeviceSubClass sub_class) throws GLib.Error, Msmcomm.Error;
    }
}
