/**
 * This file is part of msmlogd.
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

namespace Msmcomm
{
    public class Worker
    {
        private FsoFramework.Transport transport;
        private FsoFramework.Logger logger;
        private FsoFramework.SmartKeyFile config;
        private string ip;
        private uint port;
        
        //
        // public API
        //
        
        public Worker()
        {
            logger = FsoFramework.theLogger;
            config = FsoFramework.theConfig;
        }
        
        public bool setup()
        {
            ip = config.stringValue("connection", "ip", "127.0.0.1");
            port = (uint) config.intValue("connection", "port", 3030);
            
            logger.info(@" Connecting to msmcomm daemon on $ip:$port...");
            
            transport = new FsoFramework.SocketTransport("tcp", ip, port);
            transport.setDelegates(onTransportReadyToRead, onTransportHangup);
            
            if ( !transport.open() )
            {
                logger.error(@"Can't connect to msmcomm daemon");
                loop.quit();
                return false;
            }
            
            logger.info("Connected successfull to msmcomm daemon");
            
            return false;
        }
        
        //
        // private API
        //
        
        private void onTransportReadyToRead(FsoFramework.Transport t)
        {
           
        }

        private void onTransportHangup(FsoFramework.Transport t)
        {
            logger.error("Server has hangup.");
            loop.quit();
        }
    }
    
} // namespace Msmcomm
