/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Phonebookon Busch <morphis@gravedo.de>
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
    public class PhonebookResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x19;

        public PhonebookResponseMessageGroup()
        {
            base(PhonebookResponseMessageGroup.GROUP_ID);

            message_types[PhonebookReturnResponseMessage.MESSAGE_ID] = typeof(PhonebookReturnResponseMessage);
        }
    }

    public class PhonebookUnsolicitedResponseMessageGroup : UniformMessageGroup<PhonebookUnsolicitedResponseMessage>
    {
        public static const uint8 GROUP_ID = 0x1a;

        public PhonebookUnsolicitedResponseMessageGroup()
        {
            base(PhonebookUnsolicitedResponseMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_ADDED;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_UPDATED;
                    break;
                case 0x2:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_DELETED;
                    break;
                case 0x3:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_FAILED;
                    break;
                case 0x4:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_START;
                    break;
                case 0x5:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_DONE;
                    break;
                case 0x6:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PHONEBOOK_READY;
                    break;
                case 0x7:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_LOCKED;
                    break;
                case 0x8:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_UNLOCKED;
                    break;
                case 0x9:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PH_UNIQUE_IDS_VALIDATED;
                    break;
                case 0xa:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_WRITE;
                    break;
                case 0xb:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_GET_ALL_RECORD_ID;
                    break;
                case 0xc:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_EXTENDED_FILE_INFO;
                    break;
            }
        }
    }
}
