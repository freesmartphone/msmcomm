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
    public class RemoteClient : Object
    {
        private SocketConnection connection;
        private FsoFramework.Logger logger;
        private IOChannel channel;
        private uint readwatch;
        private uint writewatch;
        protected ByteArray buffer;
        private RemoteClientHandler handler;
        
        //
        // public API
        //
        
        public RemoteClient(SocketConnection conn, RemoteClientHandler handler)
        {
            connection = conn;
            this.handler = handler;
            logger = FsoFramework.theLogger;
            buffer = new ByteArray();
            
            // create our channel to watch the client connection for incomming data
            var sock = connection.socket;
            channel = new IOChannel.unix_new(sock.fd);
            
            readwatch = channel.add_watch(IOCondition.IN | IOCondition.HUP, channelActionCallback);
            
            logger.debug("created io watching channel for new remote client");
        }

        public void close()
        {
            try 
            {
                logger.debug("RemoteClient: Closing channel and connection ...");
                
                connection.close(null);
            }
            catch (GLib.Error err)
            {
                logger.error(@"RemoteClient: Could not close channel/connection: $(err.message)");
            }
        }
        
        public void handleDataFromModem(uint8[] data)
        {
            logger.debug(@"Writing $(data.length) bytes to client");
            
            var restart = buffer.len == 0;
            var temp = new uint8[data.length];
            Memory.copy( temp, data, data.length );
            buffer.append( temp );
            
            if (restart)
                restartWriter();
        }
        
        //
        // private API
        //
        
        private void restartWriter()
        {
            writewatch = channel.add_watch(IOCondition.OUT, channelWriteCallback);
        }
        
        private bool channelWriteCallback(IOChannel? source, IOCondition condition)
        {
            if ((condition & IOCondition.OUT) == IOCondition.OUT)
            {
                return writeToChannel() != 0;
            }
            
            logger.critical(@"channelWriteCallback called with unknown condition %d".printf(condition));
            return false;
        }
        
        private bool channelActionCallback(IOChannel? source, IOCondition condition)
        {
            if ((condition & IOCondition.IN) == IOCondition.IN)
            {
                readFromChannel();
                return true;
            }
            else if ((condition & IOCondition.HUP) == IOCondition.HUP)
            {
                logger.error( "HUP => closing channel" );
                handler.removeClient(this);
                return false;
            }
            
            logger.critical(@"channelActionCallback called with unknown condition %d".printf(condition));
            return false;
        }
        
        private void readFromChannel()
        {
            try
            {
                if (connection == null || connection.is_closed())
                {
                    return;
                }
                
                InputStream input_stream = connection.input_stream;
                
                uint8[] buffer = new uint8[4096];
                ssize_t bread = input_stream.read(buffer, buffer.length, null);
                
                if (bread == 0)
                {
                    logger.error(@"Read 0 bytes => synthesizing channelActionCallback w/ HUP.");
                    channelActionCallback(channel, IOCondition.HUP);
                }
                else
                {
                    logger.debug(@"Read $(bread) bytes => commit to connected handlers");
                    uint8[] tmp = new uint8[bread];
                    Memory.copy(tmp, buffer, bread);
                    handler.requestHandleDataFromClient(tmp, (int) bread);
                }
            }
            catch (GLib.Error err)
            {
                logger.error(@"Could not read from client channel input stream: $(err.message)");
            }
        }
        
        private uint writeToChannel()
        {
            uint byteswritten = 0;
            
            try
            {
                if (buffer.len > 0)
                {
                    OutputStream output = connection.output_stream;
                    byteswritten = (uint)output.write(buffer.data, buffer.len, null);
                    buffer.remove_range(0, (uint) byteswritten);
                }
            }
            catch (GLib.Error err)
            {
                logger.error(@"Could not write to client channel output stream: $(err.message)");
            }
            
            return (uint) byteswritten;
        }
    }
} // namespace Msmcomm
