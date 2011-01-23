/**
 * This file is part of msmcommd.
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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

using FsoFramework.StringHandling;

namespace Msmcomm.Daemon
{
    public class PhonebookService : BaseService, Msmcomm.Phonebook
    {
        public PhonebookService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(LowLevel.BaseMessage message)
        {
            bool handled = false;

            switch (message.message_type)
            {
                case LowLevel.MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PHONEBOOK_READY:
                    var pb_message = message as LowLevel.PhonebookReadyUrcMessage;

                    if (pb_message.book_type != LowLevel.PhonebookBookType.UNKNOWN)
                    {
                        var book_type = convertEnum<LowLevel.PhonebookBookType,PhonebookBookType>(pb_message.book_type);
                        ready(book_type);
                    }

                    handled = true;
                    break;
#if 0
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_ADDED:
                    var pb_message = message as PhonebookUnsolicitedResponseMessage;
                    record_added(pb_message.book_type, pb_message.position);
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_UPDATED:
                    var pb_message = message as PhonebookUnsolicitedResponseMessage;
                    record_updated(pb_message.book_type, pb_message.position);
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_DELETED:
                    var pb_message = message as PhonebookUnsolicitedResponseMessage;
                    record_deleted(pb_message.book_type, pb_message.position);
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_FAILED:
                    var pb_message = message as PhonebookUnsolicitedResponseMessage;
                    record_failed(pb_message.book_type, pb_message.position);
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_START:
                    refresh_start();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_REFRESH_DONE:
                    refresh_done();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_LOCKED:
                    locked();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_UNLOCKED:
                    unlocked();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PH_UNIQUE_IDS_VALIDATED:
                    ph_unique_ids_validated();
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_RECORD_WRITE:
                    var pb_message = message as PhonebookUnsolicitedResponseMessage;
                    record_write_event(pb_message.book_type, pb_message.position);
                    handled = true;
                    break;
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_GET_ALL_RECORD_ID:
                    get_all_record_id_event();
                    handled = true;
                    break;
#endif

                case LowLevel.MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_EXTENDED_FILE_INFO:
                    var pb_message = message as LowLevel.PhonebookExtendedFileInfoUrcMessage;
                    var book_type = convertEnum<LowLevel.PhonebookBookType,PhonebookBookType>(pb_message.book_type);

                    PhonebookInfo info = PhonebookInfo();
                    info.book_type = book_type;
                    info.slot_count = pb_message.slot_count;
                    info.slots_used = pb_message.slots_used;
                    info.max_chars_per_number = pb_message.max_chars_per_number;
                    info.max_chars_per_title = pb_message.max_chars_per_title;

                    extended_file_info_event(info);

                    handled = true;
                    break;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async PhonebookRecord read_record(PhonebookBookType book_type, uint position) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.PhonebookReadRecordCommandMessage();
            message.book_type = convertEnum<PhonebookBookType,LowLevel.PhonebookBookType>(book_type);
            message.position = (uint8) position;

            var response = (yield channel.enqueueAsync(message)) as LowLevel.PhonebookReturnResponseMessage;
            checkResponse(response);

            var record = PhonebookRecord();
            record.book_type = convertEnum<LowLevel.PhonebookBookType,PhonebookBookType>(response.book_type);
            record.position = response.position;
            record.number = response.number;
            record.title = response.title;
            record.encoding_type = convertEnum<LowLevel.PhonebookEncodingType,PhonebookEncodingType>(response.encoding_type);

            return record;
        }

        public async void write_record(PhonebookBookType book_type, uint position, string title, string number) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.PhonebookWriteRecordCommandMessage();
            message.book_type = convertEnum<PhonebookBookType,LowLevel.PhonebookBookType>(book_type);
            message.position = (uint8) position;
            message.title = title;
            message.number = number;

            var response = (yield channel.enqueueAsync(message)) as LowLevel.PhonebookReturnResponseMessage;
            checkResponse(response);
        }

        public async void read_record_bulk(PhonebookBookType book_type, uint first, uint last) throws Msmcomm.Error, GLib.Error
        {
            throw new Msmcomm.Error.NOT_IMPLEMENTED("ReadRecordBulk method currently not implemented");
#if 0
            var message = new LowLevel.PhonebookReadRecordBulkCommandMessage();
            message.first_book_type = convertEnum<PhonebookBookType,LowLevel.PhonebookBookType>(book_type);
            message.last_book_type = convertEnum<PhonebookBookType,LowLevel.PhonebookBookType>(book_type);
            message.first_position = (uint8) first;
            message.last_position = (uint8) last;

            var response = (yield channel.enqueueAsync(message)) as LowLevel.PhonebookReturnResponseMessage;
            checkResponse(response);
#endif
        }

        public async void get_all_record_id() throws Msmcomm.Error, GLib.Error
        {
        }

        public async void extended_file_info(PhonebookBookType book_type) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.PhonebookExtendedFileInfoCommandMessage();
            message.book_type = convertEnum<PhonebookBookType,LowLevel.PhonebookBookType>(book_type);

            var response = (yield channel.enqueueAsync(message, 0, 1)) as LowLevel.PhonebookReturnResponseMessage;
            checkResponse(response);
        }
    }
}
