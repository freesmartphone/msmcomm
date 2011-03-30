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

void test_messageutils_encode_bcd_correct_run()
{
    string number = "01234567891";
    uint8[] result = encode_bcd(number);

    assert( result.length == 6 );
    assert( result[0] == 0x10 );
    assert( result[1] == 0x32 );
    assert( result[2] == 0x54 );
    assert( result[3] == 0x76 );
    assert( result[4] == 0x98 );
    assert( result[5] == 0xF1 );
}

void test_messageutils_decode_bcd_correct_run()
{
    uint8[] data = new uint8[] { 0x10, 0x32, 0x54, 0xF1 };
    string result = decode_bcd( data );

    assert( result.ascii_casecmp( "0123451" ) == 0 );
}

void main(string[] args)
{
    Test.init(ref args);
    Test.add_func( "/MessageUtils/EncodeBcd/CorrectRun", test_messageutils_encode_bcd_correct_run );
    Test.add_func( "/MessageUtils/DecodeBcd/CorrectRun", test_messageutils_decode_bcd_correct_run );
    Test.run();
}

