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

namespace Msmcomm.Daemon
{
    public interface ITransmissionControl : GLib.Object
    {
        public signal void requestHandleSendData(uint8[] data);
    }

    public interface ILinkControl : GLib.Object
    {
        public abstract void sendFrame(Frame frame);
        public abstract void start();
        public abstract void stop();
        public abstract void reset();
        
        public signal void requestModemReset();
        public signal void requestHandleFrameContent(uint8[] data);
        public signal void requestHandleLinkSetupComplete();
    }

    public interface ILowLevelControl : GLib.Object
    {
        public abstract void powerOn();
        public abstract void powerOff();
        public abstract void reset();
    }
} // namespace Msmcomm
