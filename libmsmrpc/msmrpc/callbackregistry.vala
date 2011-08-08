/**
 * This file is part of libmsmrpc.
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

namespace Msmrpc
{
    public class CallbackRegistry : FsoFramework.AbstractObject
    {
        private uint32 id_counter;
        private GLib.HashTable<uint32,CallbackHandlerFuncStorage?> cbtable;

        private struct CallbackHandlerFuncStorage
        {
            public CallbackHandlerFunc callback;
        }

        //
        // private
        //

        private uint32 next_id()
        {
            if (id_counter == uint32.MAX - 1)
                id_counter = 0;
            return id_counter++;
        }

        //
        // public API
        //

        public CallbackRegistry()
        {
            id_counter = 0;
            cbtable = new GLib.HashTable<uint32,CallbackHandlerFuncStorage?>(null, null);
        }

        /**
         * Retrieve a callback function from the registry by its id.
         **/
        public CallbackHandlerFunc? retrieve_callback(uint32 id)
        {
            CallbackHandlerFuncStorage? storage = cbtable.lookup(id);
            if (storage == null)
                return null;
            return storage.callback;
        }

        /**
         * Register a callback function in registry. The callback function can later be
         * access by its id.
         **/
        public uint32 register(CallbackHandlerFunc callback)
        {
            uint32 id = next_id();
            cbtable.insert(id, CallbackHandlerFuncStorage() { callback = callback });
            return id;
        }

        /**
         * Unregister a callback function by its id. It will be not available anymore
         * after unregistration.
         **/
        public bool unregister(uint32 id)
        {
            if (cbtable.lookup(id) == null)
                return false;

            cbtable.remove(id);
            return true;
        }

        public override string repr()
        {
            return @"<>";
        }
    }

}
