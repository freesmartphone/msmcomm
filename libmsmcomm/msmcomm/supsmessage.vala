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

using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
#if 0
    public class SupsInterrogateCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x9;
        public static const uint16 MESSAGE_ID = 0x4;

        private SupsInterrogateMessage _message;
    }
#endif

    public class SupsCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xa;
        public static const uint16 MESSAGE_ID = 0x1;

        private SupsCallbackResponse _message;

        public uint8 command;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SUPS_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = SupsCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command = _message.command;
        }
    }
}
