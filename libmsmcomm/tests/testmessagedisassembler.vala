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
using Msmcomm.LowLevel.Structures.Palmpre;

void test_messagedisassembler_too_small_message()
{
    uint8[] data = { 0x42 };

    MessageDisassembler mdis = new MessageDisassembler();
    BaseMessage? result = mdis.unpack_message(data);

    assert(result == null);
}

void test_messagedisassembler_correct_unpacking_message()
{
    var message = CallCallbackResponse();
    message.ref_id = 3;
    message.cmd_type = 4;
    message.result = 1; /* RESULT_OK */

    uint8[] data = new uint8[3 + (int) sizeof(CallCallbackResponse)];

    /* set group and message id */
    data[0] = 0x1;
    data[1] = 0x0;
    data[2] = 0x0;

    /* append message structure to buffer */
    Memory.copy((uint8*)(data) + 3, (void*)(&message), sizeof(CallCallbackResponse));

    MessageDisassembler mdis = new MessageDisassembler();
    BaseMessage? result = mdis.unpack_message(data);

    assert(result != null);
    assert(result.group_id == 0x1);
    assert(result.message_id == 0x0);
    assert(result.ref_id == 3);
    assert(result.result == MessageResult.OK);

    var call_message = result as CallCallbackResponseMessage;
    assert(call_message != null);
    assert(call_message.command_type == 4);
}

void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/MessageDisassembler/TooSmallMessage", test_messagedisassembler_too_small_message);
    Test.add_func("/MessageDisassembler/CorrectUnpackingMessage", test_messagedisassembler_correct_unpacking_message);
    Test.run();
}

