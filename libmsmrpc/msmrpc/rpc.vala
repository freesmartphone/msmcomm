/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General public License for more details.
 *
 * You should have received a copy of the GNU General public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmrpc
{
    public struct RequestHeader
    {
        public uint32 xid;
        public uint32 type;
        public uint32 rpc_version;
        public uint32 prog;
        public uint32 vers;
        public uint32 procedure;
        public uint32 cred_flavor;
        public uint32 cred_length;
        public uint32 verf_flavor;
        public uint32 verf_length;

        public RequestHeader()
        {
            xid = 0;
            type = 0;
            rpc_version = 0;
            prog = 0;
            vers = 0;
            procedure = 0;
            cred_flavor = 0;
            cred_length = 0;
            verf_flavor = 0;
            verf_length = 0;
        }

        public RequestHeader.from_buffer(InputXdrBuffer buffer)
        {
            buffer.read_uint32(out xid);
            buffer.read_uint32(out type);
            buffer.read_uint32(out rpc_version);
            buffer.read_uint32(out prog);
            buffer.read_uint32(out vers);
            buffer.read_uint32(out procedure);
            buffer.read_uint32(out cred_flavor);
            buffer.read_uint32(out cred_length);
            buffer.read_uint32(out verf_flavor);
            buffer.read_uint32(out verf_length);
        }

        public void to_buffer(OutputXdrBuffer buffer)
        {
            buffer.write_uint32(xid);
            buffer.write_uint32(type);
            buffer.write_uint32(rpc_version);
            buffer.write_uint32(prog);
            buffer.write_uint32(vers);
            buffer.write_uint32(procedure);
            buffer.write_uint32(cred_flavor);
            buffer.write_uint32(cred_length);
            buffer.write_uint32(verf_flavor);
            buffer.write_uint32(verf_length);
        }
    }

    public struct ReplyProgMismatchData
    {
        public uint32 low;
        public uint32 high;
    }

    public enum AcceptStatus
    {
        SUCCESS = 0,
        PROG_UNAVAIL = 1,
        PROG_MISMATCH = 2,
        PROC_UNAVAIL = 3,
        GARBAGE_ARGS = 4,
        SYSTEM_ERROR = 5,
        PROG_LOCKED = 6
    }

    public struct AcceptedReplyHeader
    {
        public uint32 verf_flavor;
        public uint32 verf_length;
        public uint32 accept_status;

        public AcceptedReplyHeader()
        {
            verf_flavor = 0;
            verf_length = 0;
            accept_status = 0;
        }

        public AcceptedReplyHeader.from_buffer(InputXdrBuffer buffer)
        {
            buffer.read_uint32(out verf_flavor);
            buffer.read_uint32(out verf_length);
            buffer.read_uint32(out accept_status);
        }

        public void to_buffer(OutputXdrBuffer buffer)
        {
            buffer.write_uint32(verf_flavor);
            buffer.write_uint32(verf_length);
            buffer.write_uint32(accept_status);
        }
    }

    public enum ReplyStatus
    {
        ACCEPTED = 0,
        DENIED = 1
    }

    public class ReplyHeader
    {
        public uint32 xid;
        public uint32 type;
        public uint32 reply_status;
        public AcceptedReplyHeader accepted_reply;

        public ReplyHeader()
        {
            xid = 0;
            type = 0;
            reply_status = 0;
            accepted_reply = AcceptedReplyHeader();
        }

        public ReplyHeader.from_buffer(InputXdrBuffer buffer)
        {
            buffer.read_uint32(out xid);
            buffer.read_uint32(out type);
            buffer.read_uint32(out reply_status);
            accepted_reply = AcceptedReplyHeader.from_buffer(buffer);
        }

        public void to_buffer(OutputXdrBuffer buffer)
        {
            buffer.write_uint32(xid);
            buffer.write_uint32(type);
            buffer.write_uint32(reply_status);
            accepted_reply.to_buffer(buffer);
        }
    }
}
