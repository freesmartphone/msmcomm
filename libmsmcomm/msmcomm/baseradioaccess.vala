/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

using Msmcomm.Common;

namespace Msmcomm
{
    public abstract class BaseRadioAccess : Common.AbstractObject
    {
        protected FsoFramework.BaseTransport transport;
        private uint lock_count;

        //
        // private
        //

        //
        // signals
        //

        public signal void incoming_data(uint8[] data);

        //
        // public API
        //

        protected BaseRadioAccess(FsoFramework.BaseTransport transport)
        {
            this.transport = transport;
            this.lock_count = 0;
        }

        public virtual async bool open()
        {
            return true;
        }

        public virtual void close()
        {
        }

        public virtual async void send(BaseMessage message)
        {
        }

        public virtual async bool suspend()
        {
            return true;
        }

        public virtual async void resume()
        {
        }

        public virtual bool is_active()
        {
            return false;
        }

        public override string repr()
        {
            return @"<>";
        }

        /**
         * Lock the modem. The lock will only avoid suspending the modem when we're told
         * to do so but there are still operations pending.
         **/
        public void lock()
        {
            lock_count++;
        }

        /**
         * Unlock the modem as a operation has finished.
         **/
        public void unlock()
        {
            if (lock_count == 0)
            {
                logger.error("Lock count is already zero! Can't unlock ...");
                return;
            }

            lock_count--;
        }

        /**
         * Wait until the modem gets unlocked.
         **/
        public async void wait_until_unlocked()
        {
            if (is_locked())
            {
                Timeout.add(200, () => {
                    // When we're unlocked now we can return to the caller
                    if (!is_locked())
                        return false;

                    // We're still locked so try again
                    return true;
                });
                yield;
            }
        }

        /**
         * Check if modem is locked or not.
         **/
        public bool is_locked()
        {
            return lock_count > 0;
        }

    }
}
