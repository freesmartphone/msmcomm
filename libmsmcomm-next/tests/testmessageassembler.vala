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

using Msmcomm.LowLevel;
using Msmcomm.LowLevel.Structures;

void test_messageassembler_correct_packing_message()
{
    var message = new CallOriginationCommandMessage();

    message.ref_id = 53;
    message.number = "0123456789";
    message.suppress_own_number = true;

    MessageAssembler masm = new MessageAssembler();
    uint8[] buffer = masm.pack_message(message);

    assert(buffer.length == (sizeof(CmCallOriginationMessage) + 3));
    assert(buffer[0] == CallOriginationCommandMessage.GROUP_ID);
    assert(buffer[1] == CallOriginationCommandMessage.MESSAGE_ID);

    assert(buffer[3 + 0] == message.ref_id);
    assert(buffer[3 + 204] == 0xc);
}

void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/MessageAssembler/CorrectPackingMessage", test_messageassembler_correct_packing_message);
    Test.run();
}

