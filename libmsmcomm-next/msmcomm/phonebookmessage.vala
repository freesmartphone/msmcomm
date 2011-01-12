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
    private static const uint PHONEBOOK_NUMBER_LENGTH = 42;
    private static const uint PHONEBOOK_TITLE_LENGTH = 90;

    public abstract class PhonebookBaseMessage : BaseMessage
    {
        public enum EncodingType
        {
            NO_ENCODING = 0,
            ASCII = 4,
            BUCS2 = 9,
        }

        public uint8 book_type;
    }

    public class PhonebookReadRecordCommandMessage : PhonebookBaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x0;

        private PhonebookReadRecordMessage _message;

        public uint8 position;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_READ_RECORD, MessageClass.COMMAND);

            _message = PhonebookReadRecordMessage();
            set_payload((void*)(&_message), sizeof(PhonebookReadRecordMessage));
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.position = position;
            _message.book_type = book_type;
        }
    }

    public class PhonebookWriteRecordCommandMessage : PhonebookBaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x2;

        private PhonebookWriteRecordMessage _message;

        public uint8 position;
        public string number;
        public string title;

        construct 
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_WRITE_RECORD, MessageClass.COMMAND);

            _message = PhonebookWriteRecordMessage();
            set_payload((void*)(&_message), sizeof(PhonebookWriteRecordMessage));
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.book_type = book_type;
            _message.position = position;
            Memory.copy(_message.number, number.data, PHONEBOOK_NUMBER_LENGTH);
            Memory.copy(_message.title, title.data, PHONEBOOK_TITLE_LENGTH);
        }
    }

    public class PhonebookReturnResponseMessage : PhonebookBaseMessage
    {
        public static const uint8 GROUP_ID = 0x19;
        public static const uint16 MESSAGE_ID = 0x0;

        private PhonebookReturnResponse _message;

        public enum EncodingType
        {
            NO_ENCODING = 0,
            ASCII = 4,
            BUCS2 = 9,
        }

        public uint8 modify_id;
        public uint8 position;
        public string number;
        public string title;
        public EncodingType encoding_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_PHONEBOOK_RETURN, MessageClass.SOLICITED_RESPONSE);

            _message = PhonebookReturnResponse();
            set_payload((void*)(&_message), sizeof(PhonebookReturnResponse));
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            modify_id = _message.modify_id;
            position = _message.position;
            book_type = _message.book_type;
            number = convertBytesToString((uint8*) _message.number, PHONEBOOK_NUMBER_LENGTH);
            title = convertBytesToString((uint8*) _message.title, PHONEBOOK_TITLE_LENGTH);
        }
    }

    public class PhonebookUnsolicitedResponseMessage : PhonebookBaseMessage
    {
        public static const uint8 GROUP_ID = 0x1a;

        private PhonebookEvent _message;

        construct
        {
            _message = PhonebookEvent();
            set_payload((void*)(&_message), sizeof(PhonebookEvent));
        }

        protected override void evaluate_data()
        {
            book_type = _message.book_type;
        }
    }
}
