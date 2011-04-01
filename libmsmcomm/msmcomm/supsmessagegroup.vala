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
    public class SupsResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0xa;

        public SupsResponseMessageGroup()
        {
            base(SupsResponseMessageGroup.GROUP_ID);

            message_types[Sups.Response.Callback.MESSAGE_ID] = typeof(Sups.Response.Callback);;
        }
    }

    public class SupsUnsolicitedResponseMessageGroup : UniformMessageGroup<Sups.Urc>
    {
        public static const uint8 GROUP_ID = 0xb;

        public SupsUnsolicitedResponseMessageGroup()
        {
            base(SupsUnsolicitedResponseMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_REGISTER;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_REGISTER_CONF;
                    break;
                case 0x2:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_ERASE;
                    break;
                case 0x3:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_ERASE_CONF;
                    break;
                case 0x4:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_ACTIVATE;
                    break;
                case 0x5:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_ACTIVATE_CONF;
                    break;
                case 0x6:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_DEACTIVATE;
                    break;
                case 0x7:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_DEACTIVATE_CONF;
                    break;
                case 0x8:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_INTERROGATE;
                    break;
                case 0x9:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SUPS_INTERROGATE_CONF;
                    break;
                default:
                    break;
            }
        }
    }
}
