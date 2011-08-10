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

namespace Msmcomm
{
    public abstract class BaseModemAccessor : Common.AbstractObject
    {
        private BaseRadioAccess radio_access;

        //
        // private
        //

        //
        // public API
        //

        protected BaseModemAccessor(BaseRadioAccess radio_access)
        {
            this.radio_access = radio_access;
        }

        /**
         * Create a new client for a service provided by the modem.
         **/
        public T? create_client<T>()
        {
            BaseClient? client = null;
            Type client_type = typeof(T);

            // check if client type is derived from base client class
            foreach (var child_type in client_type.children())
            {
                if (child_type.is_a(typeof(BaseClient)))
                {
                    client = (BaseClient?) GLib.Object.new(client_type);
                    client.radio_access = radio_access;
                    break;
                }
            }

            return client;
        }

        public override string repr()
        {
            return @"<>";
        }
    }
}
