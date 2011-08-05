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

namespace Msmrpc
{
    private const int BUFFER_MAX_SIZE = 4096;

    public delegate bool CallbackHandlerFunc(InputXdrBuffer buffer);

    private struct MessageReplyHandler
    {
        public SourceFunc callback;
    }

    protected class CallbackRegistry : FsoFramework.AbstractObject
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

    /**
     * Basic RPC client
     **/
    public class Client : FsoFramework.AbstractObject
    {
        private ProgramType program;
        private uint32 version;
        private FsoFramework.BaseTransport transport;
        private uint32 xid_counter;
        private GLib.Queue<MessageReplyHandler?> request_queue;
        private InputXdrBuffer current_in_buffer;
        private CallbackHandlerFunc remote_call_handler;

        protected CallbackRegistry cbregistry;

        //
        // private
        //

        private void handle_transport_ready_to_read(FsoFramework.Transport t)
        {
            int bread = 0;
            uint8[] data = new uint8[BUFFER_MAX_SIZE];
            uint32 xid, type;
            MessageReplyHandler handler;

            bread = transport.read(data, data.length);
            assert( logger.debug(@"Received $bread bytes from modem") );

            if (bread < 2)
            {
                logger.error(@"Receive not enough bytes from modem");
                return;
            }

            current_in_buffer = new InputXdrBuffer();
            current_in_buffer.fill(data);

            // we need to read the type of messages we received
            current_in_buffer.read_uint32(out xid);
            current_in_buffer.read_uint32(out type);
            current_in_buffer.rewind();

            // handle different types of messages and forward handling to other parts
            if (type == MessageType.REPLY)
            {
                if (request_queue.get_length() > 0)
                {
                    handler = request_queue.pop_head();
                    if (handler.callback != null)
                        handler.callback();
                }
                else
                {
                    logger.warning("We got some data from transport but have no request pending!");
                }
            }
            else if (type == MessageType.CALL)
            {
                handle_remote_call(current_in_buffer);
            }
            else
            {
                logger.error(@"Got unknown reply message type: $type");
            }
        }

        private async void handle_remote_call(InputXdrBuffer buffer)
        {
            RequestHeader reqhdr = RequestHeader();
            OutputXdrBuffer out_buffer = new OutputXdrBuffer();
            ReplyHeader replyhdr = new ReplyHeader(MessageType.REPLY);
            AcceptStatus access_status = AcceptStatus.SYSTEM_ERROR;
            bool result = false;

            assert( logger.debug(@"Incoming message (length = $(buffer.length))") );
            assert( logger.debug(FsoFramework.StringHandling.hexdump(buffer.data)) );

            reqhdr.from_buffer(buffer);

            // depending of the result of the remote_call_handler we have to set the accept
            // status accordingly
            if (remote_call_handler != null)
            {
                result = remote_call_handler(buffer);
                access_status = (result ? AcceptStatus.SUCCESS : AcceptStatus.SYSTEM_ERROR);
            }

            // create and send reply message to remote side
            replyhdr.xid = next_xid();
            replyhdr.reply_status = ReplyStatus.ACCEPTED;
            replyhdr.accepted_reply.status = access_status;
            replyhdr.to_buffer(out_buffer);
            transport.write(out_buffer.data, (int) out_buffer.length);
        }

        private void handle_transport_hangup(FsoFramework.Transport t)
        {
            assert( logger.debug(@"Transport was closed by remote side") );
        }

        private uint32 next_xid()
        {
            if (xid_counter == uint32.MAX - 1)
                xid_counter = 0;
            return xid_counter++;
        }

        /**
         * Wait for a reply to receive and pack it into a xdr buffer for processing.
         **/
        private async InputXdrBuffer receiveReplyData(int timeout)
        {
            MessageReplyHandler handler = MessageReplyHandler();

            handler.callback = receiveReplyData.callback;
            request_queue.push_head(handler);
            yield;

            return current_in_buffer;
        }

        //
        // public API
        //

        public Client(FsoFramework.BaseTransport transport, ProgramType program, uint32 version, CallbackHandlerFunc remote_call_handler)
        {
            this.transport = transport;
            this.program = program;
            this.version = version;
            this.xid_counter = 0;
            this.request_queue = new GLib.Queue<MessageReplyHandler?>();
            this.remote_call_handler = remote_call_handler;
            this.cbregistry = new CallbackRegistry();
        }

        public void initialize()
        {
            transport.open();
            transport.setDelegates(handle_transport_ready_to_read, handle_transport_hangup);
        }

        public void shutdown()
        {
            transport.close();
        }

        public async bool request(uint32 procedure, uint8[] argument_data, out uint8[] result_data, int timeout = 0)
        {
            RequestHeader reqhdr = RequestHeader();
            ReplyHeader replyhdr = new ReplyHeader(MessageType.REPLY);
            OutputXdrBuffer buffer = new OutputXdrBuffer();

            assert( logger.debug(@"Starting new rpc request: procedure = $(procedure), timeout = $(timeout)") );

            // create and append rpc request header to the output buffer
            reqhdr.setup(next_xid(), program, version, procedure);
            reqhdr.to_buffer(buffer);
            reqhdr.dump(logger);
            assert( logger.debug(@"RequestHdr: size = $(buffer.length)") );

            // also append client argument data which is already in xdr format
            if (argument_data != null)
            {
                assert( logger.debug(@"ArgumentData: size = $(argument_data.length)") );
                assert( logger.debug(FsoFramework.StringHandling.hexdump(argument_data, argument_data.length)) );
                buffer.append(argument_data);
            }

            // receive and process incoming reply
            assert( logger.debug("Writing data to transport:") );
            assert( logger.debug(FsoFramework.StringHandling.hexdump(buffer.data, (int) buffer.length)) );
            transport.write(buffer.data, (int) buffer.length);
            var in_buffer = yield receiveReplyData(timeout);
            replyhdr.from_buffer(in_buffer);

            // check reply status and if reply was successfull or not
            if ((ReplyStatus) replyhdr.reply_status != ReplyStatus.ACCEPTED)
            {
                logger.error(@"rpc call was denied: reply_status = $(replyhdr.reply_status)");
                return false;
            }
            else if ((AcceptStatus) replyhdr.accepted_reply.status != AcceptStatus.SUCCESS)
            {
                logger.error(@"rpc call was not successfull: status = $(replyhdr.accepted_reply.status)");
                return false;
            }

            if (result_data != null && !in_buffer.retrive_remaining_data(out result_data))
                result_data = null;

            return true;
        }

        public override string repr()
        {
            return @"<$(program),%08x>".printf(version);
        }
    }
}
