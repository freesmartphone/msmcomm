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
    public class RemoteClientHandler
    {
        private FsoFramework.Logger logger;
        private FsoFramework.SmartKeyFile config;
        private SocketService socksrv;
        
        //
        // public API
        //
        
        public RemoteClientHandler()
        {
            logger = FsoFramework.theLogger;
            config = FsoFramework.theConfig;
        }
        
        public bool start()
        {
            var name = "127.0.0.1";
            var port = "3030";
            
            logger.info("setup remote client handler ...");
            
            // resolve network address
            var resolver = Resolver.get_default();
            List<InetAddress> addresses;
            try
            {
                addresses = resolver.lookup_by_name( name, null );
            }
            catch ( GLib.Error e )
            {
                logger.error( @"Could not resolve $name: $(Posix.strerror(Posix.errno))" );
                return false;
            }
            var address = addresses.nth_data(0);
            logger.info( @"Resolved $name to $address" );
            
            // setup socketservice and connect signal with handler for 
            // incomming connections
            logger.debug("Starting socket service ...");
            try 
            {
                socksrv = new SocketService();
                var socketAddress = new InetSocketAddress (address, (uint16) port.to_int());
                socksrv.add_address(socketAddress, SocketType.STREAM, SocketProtocol.TCP, null, null);
                socksrv.incoming.connect(handleIncommingConnection);
                socksrv.start();
            }
            catch (GLib.Error e)
            {
                logger.error(@"Could net start socket service: $(e.message)");
                return false;
            }
            
            return true;
        }
        
        public bool stop()
        {
            logger.debug("Attempt to stop socket service ...");
            socksrv.stop();
            return true;
        }
        
        public void handleFrameContentRequest(uint8[] data)
        {
            // FIXME
        }
        
        //
        // private API
        //
        
        private bool handleIncommingConnection(SocketConnection conn, Object? source)
        {
            logger.debug("Got new remote client connection !");
            try 
            {
                var conn2 = socksrv.accept(null, null);
            }
            catch (GLib.Error e)
            {
                logger.error(@"Could not accept new client connection: $(e.message)");
            }
            return true;
        }
        
        //
        // Signals
        //
        
        public signal void requestHandleSendDataFromClient(uint8[] data);
        
    }
} // namespace Msmcomm
