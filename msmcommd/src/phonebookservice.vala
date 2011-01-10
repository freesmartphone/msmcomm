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

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public class PhonebookService : BaseService, Msmcomm.Phonebook
    {
        public PhonebookService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            bool handled = false;

            switch (message.message_type)
            {
                case MessageType.UNSOLICITED_RESPONSE_PHONEBOOK_PHONEBOOK_READY:
                    var pb_message = message as PhonebookPhonebookReadyUnsolicitedResponseMessage;
                    phonebook_ready(pb_message.book_type);
                    handled = true;
                    break;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async PhonebookRecord read_record(uint book_type, uint position)
        {
            var message = new PhonebookReadRecordCommandMessage();
            message.book_type = (uint8) book_type;
            message.position = (uint8) position;

            var response = yield channel.enqueueAsync(message) as PhonebookReturnResponseMessage;

            var record = PhonebookRecord();
            record.book_type = response.book_type;
            record.position = response.position;
            record.number = response.number;
            record.title = response.title;
            // record.encoding_type = convertPhonebookEncodingTypeForService(response.encoding_type);

            return record;
        }
    }
}
