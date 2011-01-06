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
    public static const int MESSAGE_HEADER_SIZE = 3;

    public class MessageDisassembler : AbstractObject
    {
        private Gee.HashMap<uint8,BaseMessageGroup> groups;

        public MessageDisassembler()
        {
            groups = new Gee.HashMap<uint8,BaseMessageGroup>();

            groups[CallResponseMessageGroup.GROUP_ID] = new CallResponseMessageGroup();
            groups[CallUnsolicitedResponseMessageGroup.GROUP_ID] = new CallUnsolicitedResponseMessageGroup();
            groups[StateResponseMessageGroup.GROUP_ID] = new StateResponseMessageGroup();
            groups[StateUnsolicitedResponseMessageGroup.GROUP_ID] = new StateUnsolicitedResponseMessageGroup();
            groups[MiscResponseMessageGroup.GROUP_ID] = new MiscResponseMessageGroup();
            groups[MiscUnsolicitedResponseMessageGroup.GROUP_ID] = new MiscUnsolicitedResponseMessageGroup();
        }

        public BaseMessage? unpack_message(uint8[] data)
        {
            BaseMessage? message = null;

            /* Minimum required size to have a valid message are four bytes */
            if (data.length < MESSAGE_HEADER_SIZE + 1)
            {
                return null;
            }

            /* Extract group and message id from the first three bytes */
            uint8 groupId = data[0];
            uint16 messageId = data[1] | (data[2] << 8);

            /* Check for message group and unpack message for byte stream */
            if (groups.has_key(groupId))
            {
                var group = groups[groupId];
                message = group.unpack_message(messageId, data[3:data.length-1], data.length - 3);
            }

            return message;
        }

        public override string repr()
        {
            return "<>";
        }
    }
}
