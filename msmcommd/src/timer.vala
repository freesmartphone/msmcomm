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
    public class Timer : GLib.Object
    {
        private uint id { get; set; default = 0; }
        
        public int interval { get; set; default = 0; }
        public int priority { get; set; default = GLib.Priority.DEFAULT; }
        public bool running { get { return id > 0; } }
        public uint occurence { get; set; default = 0; }

        //
        // private API
        //
        
        private bool onTimerEvent()
        {
            bool result = requestHandleEvent(this);
            
            // If user choose to stop the timer through the callback,
            // reset the saved timer id before
            if (!result)
            {
                id = 0;
            }

            occurence += 1;
            
            return result;
        }
        
        // 
        // public API
        //
        
        /**
        * Starts the timer if it is not already running
        **/
        public void start()
        {
            if (id == 0) 
            {
                occurence = 0;
                id = GLib.Timeout.add_full(priority, interval, onTimerEvent);
            }
        }
        
        /**
        * Stops the timer, if it is running
        **/
        public void stop()
        {
            if (id > 0)
            {
                GLib.Source.remove(id);
                id = 0;
            }
        }
        
        /**
        * Restart the timer. If it is already running, it is stopped before.
        **/
        public void restart()
        {
            stop();
            start();
        }
        
        //
        // Signals
        //
        
        /**
        * If the timer elapsed, this signal is called.
        *
        * @param timer the timer object the event comes from
        **/
        public signal bool requestHandleEvent(Timer timer);
    }
} // namespace Msmcomm
