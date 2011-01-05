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

void test_messagedisassembler_too_small_message()
{
    uint8[] data = { 0x42 };

    MessageDisassembler mdis = new MessageDisassembler();
    BaseMessage? result = mdis.unpackMessage(data);

    assert( result == null);
}


void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/MessageDisassembler/TooSmallMessage", test_messagedisassembler_too_small_message);
    Test.run();
}

