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

using Msmcomm.LowLevel.Structures.Palmpre;

namespace Msmcomm.LowLevel
{
    private static const int PHONEBOOK_NUMBER_LENGTH = 42;
    private static const int PHONEBOOK_TITLE_LENGTH = 90;

    public enum PhonebookBookType
    {
        ADN, // Abbreviated Dialing Number list
        FDN, // Fixed Dialing Number list
        SDN, // Service Dialing Number list
        ECC, // Emergency Call Code list
        UNKNOWN,
    }

    public enum PhonebookEncodingType
    {
        NO_ENCODING = 0,
        ASCII = 4,
        BUCS2 = 9,
    }

    private uint8 bookTypeToId(PhonebookBookType book_type, bool ext_info = false)
    {
        uint8 result = 0x0;

        switch (book_type)
        {
            case PhonebookBookType.ADN:
                result = ext_info ? 0x1 : 0x10;
                break;
            case PhonebookBookType.FDN:
                result = ext_info ? 0x3 : 0x20;
                break;
            case PhonebookBookType.SDN:
                result = ext_info ? 0xe : 0x8;
                break;
            case PhonebookBookType.ECC:
                result = ext_info ? 0x5 : 0x30; /* FIXME Needs testing for ext_info = true */
                break;
            default:
                assert_not_reached();
        }

        return result;
    }

    private PhonebookBookType bookTypeFromId(uint8 id, MessageClass message_class = MessageClass.SOLICITED_RESPONSE)
    {
        PhonebookBookType book_type = PhonebookBookType.UNKNOWN;

        if (message_class == MessageClass.SOLICITED_RESPONSE)
        {
            switch (id)
            {
                case 0x10:
                    book_type = PhonebookBookType.ADN;
                    break;
                case 0x20:
                    book_type = PhonebookBookType.FDN;
                    break;
                case 0x8:
                    book_type = PhonebookBookType.SDN;
                    break;
                case 0x30:
                    book_type = PhonebookBookType.ECC;
                    break;
            }
        }
        else if (message_class == MessageClass.UNSOLICITED_RESPONSE)
        {
            switch (id)
            {
                case 0x0:
                    book_type = PhonebookBookType.ECC;
                    break;
                case 0x1:
                    book_type = PhonebookBookType.ADN;
                    break;
                case 0x3:
                    book_type = PhonebookBookType.FDN;
                    break;
                case 0xe:
                    book_type = PhonebookBookType.SDN;
                    break;
            }
        }

        return book_type;

    }

    public class PhonebookReadRecordCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x0;

        private PhonebookReadRecordMessage _message;

        public PhonebookBookType book_type;
        public uint8 position;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_READ_RECORD, MessageClass.COMMAND);

            _message = PhonebookReadRecordMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.position = position;
            _message.book_type = bookTypeToId(book_type);
        }
    }

    public class PhonebookReadRecordBulkCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x1;

        private PhonebookReadRecordBulkMessage _message;

        public PhonebookBookType first_book_type;
        public uint8 first_position;
        public PhonebookBookType last_book_type;
        public uint8 last_position;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_READ_RECORD_BULK, MessageClass.COMMAND);

            _message = PhonebookReadRecordBulkMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.first_position = first_position;
            _message.first_book_type = bookTypeToId(first_book_type);
            _message.last_position = last_position;
            _message.last_book_type = bookTypeToId(last_book_type);
        }
    }

    public class PhonebookWriteRecordCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x2;

        private PhonebookWriteRecordMessage _message;

        public PhonebookBookType book_type;
        public uint8 position;
        public string number;
        public string title;

        construct 
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_WRITE_RECORD, MessageClass.COMMAND);

            _message = PhonebookWriteRecordMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.book_type = bookTypeToId(book_type);
            _message.position = position;

            int len = number.data.length > PHONEBOOK_NUMBER_LENGTH ? PHONEBOOK_TITLE_LENGTH : number.data.length;
            Memory.copy(_message.number, number.data, len);

            len = title.data.length > PHONEBOOK_TITLE_LENGTH ? PHONEBOOK_TITLE_LENGTH : title.data.length;
            Memory.copy(_message.title, title.data, len);

            /* Some constant values */
            _message.value0 = 0x4;
        }
    }

    public class PhonebookExtendedFileInfoCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x18;
        public static const uint16 MESSAGE_ID = 0x4;

        private PhonebookExtendedFileInfoMessage _message;

        public PhonebookBookType book_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PHONEBOOK_EXTENDED_FILE_INFO, MessageClass.COMMAND);

            _message = PhonebookExtendedFileInfoMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.book_type = bookTypeToId(book_type, true);
        }
    }

    public class PhonebookReturnResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x19;
        public static const uint16 MESSAGE_ID = 0x0;

        private PhonebookReturnResponse _message;

        public PhonebookBookType book_type;
        public uint8 position;
        public string number;
        public string title;
        public PhonebookEncodingType encoding_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_PHONEBOOK_RETURN, MessageClass.SOLICITED_RESPONSE);

            _message = PhonebookReturnResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            command_id = _message.command_id;
            position = _message.position;
            book_type = bookTypeFromId(_message.book_type);
            number = FsoFramework.Utility.dataToString(_message.number, PHONEBOOK_NUMBER_LENGTH);
            title = FsoFramework.Utility.dataToString(_message.title, PHONEBOOK_TITLE_LENGTH);

            switch (_message.result)
            {
                case 0x4:
                case 0x12:
                    result = MessageResult.ERROR_PHONEBOOK_NOT_ACTIVE;
                    break;
                case 0xb:
                    result = MessageResult.ERROR_PHONEBOOK_RECORD_EMPTY;
                    break;
                case 0x16:
                    result = MessageResult.ERROR_PHONEBOOK_FAILED_TO_WRITE_RECORD;
                    break;
            }
        }
    }

    public class PhonebookExtendedFileInfoUrcMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1a;
        public static const uint16 MESSAGE_ID = 0xc;

        private PhonebookExtendedFileInfoEvent _message;

        public PhonebookBookType book_type;
        public uint32 slots_used;
        public uint32 slot_count;
        public uint32 max_chars_per_title;
        public uint32 max_chars_per_number;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_EXTENDED_FILE_INFO, MessageClass.UNSOLICITED_RESPONSE);

            _message = PhonebookExtendedFileInfoEvent();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            book_type = bookTypeFromId(_message.book_type, MessageClass.UNSOLICITED_RESPONSE);
            slots_used = _message.slots_used;
            slot_count = _message.slot_count;
            max_chars_per_title = _message.max_chars_per_title;
            max_chars_per_number = _message.max_chars_per_number;

            switch (_message.result)
            {
                case 0x4:
                    result = MessageResult.ERROR_PHONEBOOK_NOT_ACTIVE;
                    break;
                case 0x12:
                    result = MessageResult.ERROR_UNKNOWN;
                    break;
            }
        }
    }

    public abstract class PhonebookUrcBaseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1a;

        private PhonebookEvent _message;

        public PhonebookBookType book_type;
        public uint position;

        construct
        {
            group_id = GROUP_ID;
            _message = PhonebookEvent();
            message_class = MessageClass.UNSOLICITED_RESPONSE;
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            book_type = bookTypeFromId(_message.book_type, MessageClass.UNSOLICITED_RESPONSE);
            position = _message.position;
        }
    }

    public class PhonebookReadyUrcMessage : PhonebookUrcBaseMessage
    {
        public static const uint16 MESSAGE_ID = 0x6;

        construct
        {
            message_id = MESSAGE_ID;
            message_type = MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PHONEBOOK_READY;
        }
    }
}
