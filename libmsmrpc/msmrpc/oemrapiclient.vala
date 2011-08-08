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
    public struct OemRapiCallMessage
    {
        public uint32 event;
        public uint32 cb_id;
        public uint32 handle;
        public uint32 input_length;
        public uint8[] input_data;
        public uint32 output_length_valid;
        public uint32 output_valid;
        public uint32 output_size;

        public OemRapiCallMessage()
        {
            event = 0;
            cb_id = OemRapiConstants.CLIENT_NULL_CB_ID;
            handle = 0;
            input_length = 0;
            input_data = null;
            output_length_valid = 0;
            output_valid = 0;
            output_size = 0;
        }

        public void to_buffer(OutputXdrBuffer buffer)
        {
            buffer.write_uint32(event);
            buffer.write_uint32(cb_id);
            buffer.write_uint32(handle);
            buffer.write_uint32(input_length);
            buffer.write_bytes(input_data);
            buffer.write_uint32(output_length_valid);
            buffer.write_uint32(output_valid);

            if (output_valid > 0)
                buffer.write_uint32(output_size);
        }

        public void from_buffer(InputXdrBuffer buffer)
        {
            uint32 tmp = 0;

            buffer.read_uint32(out event);
            buffer.read_uint32(out cb_id);
            buffer.read_uint32(out handle);
            buffer.read_uint32(out input_length);
            buffer.read_bytes(out input_data, out tmp);
            buffer.read_uint32(out output_length_valid);
            buffer.read_uint32(out output_valid);

            if (output_valid > 0)
                buffer.read_uint32(out output_size);
        }

        public void dump(FsoFramework.Logger logger, bool in = false)
        {
            assert( logger.debug(@"OemRapiCallMessage: event = 0x%08x, cb_id = 0x%08x".printf(event, cb_id)) );
            assert( logger.debug(@"OemRapiCallMessage: handle = 0x%08x, input_length = $(input_length)".printf(handle)) );
            if (input_data != null)
            {
                assert( logger.debug(@"OemRapiCallMessage: input_data =") );
                assert( logger.data(input_data, in) );
            }
        }
    }

    public struct OemRapiResultMessage
    {
        public uint32 output_valid;
        public uint32 output_length;
        public uint8[] output_data;

        public OemRapiResultMessage()
        {
            output_valid = 0;
            output_length = 0;
            output_data = null;
        }

        public void to_buffer(OutputXdrBuffer buffer)
        {
            buffer.write_uint32(output_valid);
            buffer.write_uint32(output_length);
            if (output_data.length > 0)
                buffer.write_bytes(output_data);
        }

        public void from_buffer(InputXdrBuffer buffer)
        {
            uint32 tmp = 0;
            buffer.read_uint32(out output_valid);
            buffer.read_uint32(out output_length);
            if (output_length > 0)
                buffer.read_bytes(out output_data, out tmp);
        }

        public void dump(FsoFramework.Logger logger, bool in = false)
        {
            assert( logger.debug(@"OemRapiResultMessage: output_valid = $(output_valid), output_length = $(output_length)") );
            if (output_data != null)
            {
                assert( logger.debug(@"OemRapiResultMessage: output_data =") );
                assert( logger.data(output_data, in) );
            }
        }
    }

    public class OemRapiClient : Client
    {
        //
        // private
        //

        /**
         * Handle a call from the remote side.
         **/
        protected override async void handle_remote_call(RequestHeader reqhdr, InputXdrBuffer buffer)
        {
            OutputXdrBuffer out_buffer = new OutputXdrBuffer();
            OemRapiResultMessage resultmessage = OemRapiResultMessage();
            OemRapiCallMessage callmessage = OemRapiCallMessage();
            uint8[] data;

            callmessage.from_buffer(buffer);
            assert( logger.debug(@"Retrieved remote call:") );
            callmessage.dump(logger);

            buffer.retrive_remaining_data(out data);
            handle_incoming_data(data);

            resultmessage.to_buffer(out_buffer);
            yield base.reply(reqhdr.xid, out_buffer.data);
        }

        //
        // public API
        //

        public OemRapiClient(FsoFramework.BaseTransport transport)
        {
            base(transport, ProgramType.OEM_RAPI, OEM_RAPI_VERSION_1_1);
        }

        public signal void handle_incoming_data(uint8[] data);

        /**
         * Send a set of bytes to remote side and receive a set of bytes at the same time.
         * Additionally a callback handler can registered to handle callback responses
         * too.
         **/
        public async bool send(uint8[] input_data, CallbackHandlerFunc? callback = null, uint32 event = 0, uint32 handle = 0)
        {
            OemRapiCallMessage callmessage = OemRapiCallMessage();
            OutputXdrBuffer out_buffer = new OutputXdrBuffer();
            uint8[] result_data = null;
            bool result = false;

            // FIXME we need to find out whats the purpose of the handle and events flags is
            callmessage.handle = handle;
            callmessage.event = event;
            callmessage.input_data = input_data;
            callmessage.input_length = input_data.length;

            // If we have a callback we need to register it to the registry and set its id
            if (callback != null) 
                callmessage.cb_id = cbregistry.register(callback);

            assert( logger.debug(@"Sending call message to remote side:") );
            callmessage.dump(logger);

            callmessage.to_buffer(out_buffer);

            result = yield request(OEM_RAPI_PROC_STREAMING_FUNCTION, out_buffer.data, out result_data);
            if (!result)
            {
                logger.error(@"Could not complete call to OEM rapi streaming function successfully!");
                return false;
            }

            if (result_data != null && result_data.length > 0)
            {
                logger.info(@"We got data out of the stream and don't know what to do with it:");
                logger.data(result_data, true, GLib.LogLevelFlags.LEVEL_INFO);
            }

            return true;
        }

        public override string repr()
        {
            return @"<>";
        }
    }
}
