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
    public class NetworkResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x7;

        public NetworkResponseMessageGroup()
        {
            base(NetworkResponseMessageGroup.GROUP_ID);

            message_types[NetworkCallbackResponseMessage.MESSAGE_ID] = typeof(NetworkCallbackResponseMessage);
        }
    }

    public class NetworkUrcMessageGroup : UniformMessageGroup<NetworkUrcMessage>
    {
        public static const uint8 GROUP_ID = 0x8;

        public NetworkUrcMessageGroup()
        {
            base(NetworkUrcMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x12:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_NETWORK_NETWORK_HEALTH;
                    break;
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_NETWORK_SRV_CHANGED;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_NETWORK_RSSI;
                    break;
                case 0x10:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_NETWORK_NO_TIME_RCVD_FROM_NETWORK;
                    break;
            }
        }
    }
}
