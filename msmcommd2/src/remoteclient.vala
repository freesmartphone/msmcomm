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
 
using GLib;
 
namespace Msmcomm
{
    public class RemoteClient
    {
        private SocketConnection connection;
        private FsoFramework.Logger logger;
        
        //
        // public API
        //
        
        public RemoteClient(SocketConnection conn)
        {
            connection = conn;
            logger = FsoFramework.theLogger;
        }
        
        public async void start()
        {
            try 
            {
                uint8[] buffer = new uint8[4096];
                ssize_t bread = yield connection.input_stream.read_async(buffer, buffer.length, GLib.Priority.DEFAULT, null);
                
                logger.debug(@"Got data from client: length = $(bread)");
            }
            catch (GLib.Error e)
            {
                logger.error(@"Failed to read from input stream: $(e.message)");
            }
        }
        
        //
        // private API
        //
        
        //
        // Signals
        //
        
        public signal void requestRemoveClient(RemoteClient client);
        public signal void requestHandleIncommingData(uint8[] data);
    }
} // namespace Msmcomm
