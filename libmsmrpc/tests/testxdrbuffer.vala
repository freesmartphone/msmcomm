/**
 * This file is part of msmcommd.
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

public void test_xdrbuffer_test_write_and_read()
{
    var xdrbuf_out = new Msmrpc.OutputXdrBuffer();

    uint32 ui32 = 0x12345678; int32 i32 = -0x12345678;
    uint16 ui16 = 0x1234; int16 i16 = 0x1234;
    uint8 ui8 = 0x12; int8 i8 = 0x12;

    assert(xdrbuf_out.write_uint32(ui32));
    assert(xdrbuf_out.write_int32(i32));
    assert(xdrbuf_out.write_uint16(ui16));
    assert(xdrbuf_out.write_int16(i16));
    assert(xdrbuf_out.write_uint8(ui8));
    assert(xdrbuf_out.write_int8(i8));

    uint8[] data  = xdrbuf_out.data;

    assert(data != null);
    assert(data.length == xdrbuf_out.length);
    assert(xdrbuf_out.length == 24);

    var xdrbuf_in = new Msmrpc.InputXdrBuffer();
    xdrbuf_in.fill(data);

    uint32 ui32o;
    assert(xdrbuf_in.read_uint32(out ui32o));
    assert(ui32o == ui32);

    int32 i32o;
    assert(xdrbuf_in.read_int32(out i32o));
    assert(i32o == i32);

    uint16 ui16o;
    assert(xdrbuf_in.read_uint16(out ui16o));
    assert(ui16o == ui16);

    int16 i16o;
    assert(xdrbuf_in.read_int16(out i16o));
    assert(i16o == i16);

    uint8 ui8o;
    assert(xdrbuf_in.read_uint8(out ui8o));
    assert(ui8o == ui8);

    int8 i8o;
    assert(xdrbuf_in.read_int8(out i8o));
    assert(i8o == i8);
}

public static void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/xdrbuffer/readwrite", test_xdrbuffer_test_write_and_read);
    Test.run();
}
