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

namespace Msmcomm.LowLevel
{
    public class MessageAssembler
    {
        public MessageAssembler()
        {
        }

        public uint8[] pack_message(BaseMessage message)
        {
            uint8[] payload;
            uint8[] buffer;

            /* pack message payload and build buffer to contain header and payload */
            payload = message.pack();
            buffer = new uint8[MESSAGE_HEADER_SIZE + payload.length];

            /* set group and message id to buffer */
            buffer[0] = message.group_id;
            buffer[1] = (uint8) (message.message_id & 0x00ff);
            buffer[2] = (uint8) ((message.message_id & 0xff00) >> 8);

            /* copy message payload to buffer */
            Memory.copy(((uint8*) buffer) + 3, payload, payload.length);

            return buffer;
        }
    }
}
