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
            cb_id = 0;
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

        public void dump(FsoFramework.Logger logger)
        {
            assert( logger.debug(@"OemRapiCallMessage: event = 0x%04x, cb_id = 0x%04x".printf(event, cb_id)) );
            assert( logger.debug(@"OemRapiCallMessage: handle = 0x%04x, input_length = $(input_length)".printf(handle)) );
            if (input_data != null)
            {
                assert( logger.debug(@"OemRapiCallMessage: input_data =") );
                assert( logger.debug(FsoFramework.StringHandling.hexdump(input_data, input_data.length)) );
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

        public void dump(FsoFramework.Logger logger)
        {
            assert( logger.debug(@"OemRapiResultMessage: output_valid = $(output_valid), output_length = $(output_length)") );
            if (output_data != null)
            {
                assert( logger.debug(@"OemRapiResultMessage: output_data =") );
                assert( logger.debug(FsoFramework.StringHandling.hexdump(output_data, output_data.length)) );
            }
        }
    }

    public class OemRapiClient : Client
    {
        //
        // private
        //

        /**
         *
         **/
        private bool handle_remote_call(InputXdrBuffer buffer)
        {
            OemRapiCallMessage callmessage = OemRapiCallMessage();

            callmessage.from_buffer(buffer);

            assert( logger.debug(@"Retrieved call message from remote side:") );
            callmessage.dump(logger);

            return true;
        }

        //
        // public API
        //

        public OemRapiClient(FsoFramework.BaseTransport transport)
        {
            base(transport, ProgramType.OEM_RAPI, OEM_RAPI_VERSION_1_1, handle_remote_call);
        }

        /**
         * Send a set of bytes to remote side and receive a set of bytes at the same time.
         * Additionally a callback handler can registered to handle callback responses
         * too.
         **/
        public async bool streaming_function(uint8[] input_data, CallbackHandlerFunc? callback, uint32 event = 0, uint32 handle = 0)
        {
            OemRapiCallMessage callmessage = OemRapiCallMessage();
            OemRapiResultMessage resultmessage = OemRapiResultMessage();
            OutputXdrBuffer out_buffer = new OutputXdrBuffer();
            InputXdrBuffer in_buffer = new InputXdrBuffer();
            uint8[] result_data = null;
            bool result = false;

            logger.debug(@"event = 0x%04x, handle = 0x%04x".printf(event, handle));

            // FIXME we need to find out whats the purpose of the handle and events flags is
            callmessage.handle = handle;
            callmessage.event = event;

            callmessage.cb_id = 0;
            callmessage.input_data = input_data;
            callmessage.input_length = input_data.length;
            callmessage.output_length_valid = 0;
            callmessage.output_valid = 0;

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
            else if (result_data == null)
            {
                logger.error(@"We didn't receive a response message to our call of the OEM Rapi streaming function");
                return false;
            }

            in_buffer.fill(result_data);
            resultmessage.from_buffer(in_buffer);

            return true;
        }

        public override string repr()
        {
            return @"<>";
        }
    }
}
