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
    public class CallResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x1;

        public CallResponseMessageGroup()
        {
            base(CallResponseMessageGroup.GROUP_ID);

            message_types[CallCallbackResponseMessage.GROUP_ID] = typeof(CallCallbackResponseMessage);
            message_types[CallReturnResponseMessage.GROUP_ID] = typeof(CallReturnResponseMessage);
        }
    }

    public class CallUnsolicitedResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x2;

        public CallUnsolicitedResponseMessageGroup()
        {
            base(CallUnsolicitedResponseMessageGroup.GROUP_ID);
        }
    }
}
