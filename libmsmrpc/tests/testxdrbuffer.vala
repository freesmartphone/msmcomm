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

public struct TestStruct1
{
    public uint32 d;
    public uint16 e;
    public uint8 f;
}

public struct TestStruct0
{
    public TestStruct1 test1;
    public uint32 a;
    public uint16 b;
    public uint8 c;
}

public bool write_test_struct1(Msmrpc.OutputXdrBuffer buffer, void *obj)
{
    assert(buffer != null);
    assert(buffer.get_type() == typeof(Msmrpc.OutputXdrBuffer));
    assert(obj != null);

    TestStruct1 *t1 = (TestStruct1*) obj;
    assert(t1 != null);
    assert(buffer.write_uint32(t1->d));
    assert(buffer.write_uint16(t1->e));
    assert(buffer.write_uint8(t1->f));

    return true;
}

public bool write_test_struct0(Msmrpc.OutputXdrBuffer buffer, void *obj)
{
    assert(buffer != null);
    assert(buffer.get_type() == typeof(Msmrpc.OutputXdrBuffer));
    assert(obj != null);

    TestStruct0 *t0 = (TestStruct0*) obj;
    assert(t0 != null);
    assert(buffer.write_uint32(t0->a));
    assert(buffer.write_uint16(t0->b));
    assert(buffer.write_uint8(t0->c));

    assert(buffer.write_pointer(&t0->test1, (uint32) sizeof(TestStruct0), write_test_struct1));

    return true;
}

public bool write_test_array(Msmrpc.OutputXdrBuffer buffer, void *obj)
{
    assert(buffer != null);
    assert(buffer.get_type() == typeof(Msmrpc.OutputXdrBuffer));
    assert(obj != null);

    uint32* t0 = (uint32*) obj;
    assert(buffer.write_uint32(*t0));

    return true;
}

public bool read_test_struct1(Msmrpc.InputXdrBuffer buffer, void *obj)
{
    assert(buffer != null);
    assert(buffer.get_type() == typeof(Msmrpc.InputXdrBuffer));
    assert(obj != null);

    TestStruct1 *t1 = (TestStruct1*) obj;
    assert(t1 != null);
    assert(buffer.read_uint32(out t1->d));
    assert(buffer.read_uint16(out t1->e));
    assert(buffer.read_uint8(out t1->f));

    return true;
}

public bool read_test_struct0(Msmrpc.InputXdrBuffer buffer, void *obj)
{
    assert(buffer != null);
    assert(buffer.get_type() == typeof(Msmrpc.InputXdrBuffer));
    assert(obj != null);

    TestStruct0 *t0 = (TestStruct0*) obj;
    assert(t0 != null);
    assert(buffer.read_uint32(out t0->a));
    assert(buffer.read_uint16(out t0->b));
    assert(buffer.read_uint8(out t0->c));

    assert(buffer.read_pointer(&t0->test1, (uint32) sizeof(TestStruct1), read_test_struct1));

    return true;
}

public void test_xdrbuffer_test_write_and_read()
{
    var xdrbuf_out = new Msmrpc.OutputXdrBuffer();

    uint32 ui32 = 0x12345678; int32 i32 = -0x12345678;
    uint16 ui16 = 0x1234; int16 i16 = 0x1234;
    uint8 ui8 = 0x12; int8 i8 = 0x12;
    uint8[] bytes = new uint8[] { 0xa, 0xb, 0xc, 0xd, 0xf };
    TestStruct0 test0 = TestStruct0();
    test0.a = 0x12345678; test0.b = 0x1234; test0.c = 0x12;
    test0.test1 = TestStruct1();
    test0.test1.d = 0x11223344; test0.test1.e = 0xaaee;
    test0.test1.f = 0xae;

    uint32[] testarray = new uint32[] { 0x1234, 0x1234, 0x1234, 0x1234 };

    assert(xdrbuf_out.write_uint32(ui32));
    assert(xdrbuf_out.write_int32(i32));
    assert(xdrbuf_out.write_uint16(ui16));
    assert(xdrbuf_out.write_int16(i16));
    assert(xdrbuf_out.write_uint8(ui8));
    assert(xdrbuf_out.write_int8(i8));
    assert(xdrbuf_out.write_bytes(bytes));
    assert(xdrbuf_out.write_pointer(&test0, (uint32) sizeof(TestStruct0), write_test_struct0));
    assert(xdrbuf_out.write_array_raw(&testarray, testarray.length, (uint32) sizeof(uint32), write_test_array));
    assert(xdrbuf_out.write_array<uint32>(testarray, write_test_array));

    uint8[] data  = xdrbuf_out.data;

    assert(data != null);
    assert(data.length == xdrbuf_out.length);
    assert(xdrbuf_out.length == 108);

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

    uint8[] byteso; uint32 len;
    assert(xdrbuf_in.read_bytes(out byteso, out len));
    assert(len == bytes.length);
    assert(byteso.length == bytes.length);
    for (int n = 0; n < 5; n++)
    {
        assert(byteso[n] == bytes[n]);
    }

    TestStruct0 t0o = TestStruct0();
    Posix.memset(&t0o, 0, sizeof(TestStruct0));

    assert(xdrbuf_in.read_pointer(&t0o, (uint32) sizeof(TestStruct0), read_test_struct0));
    assert(t0o.a == test0.a);
    assert(t0o.b == test0.b);
    assert(t0o.c == test0.c);
    assert(t0o.test1.d == test0.test1.d);
    assert(t0o.test1.e == test0.test1.e);
    assert(t0o.test1.f == test0.test1.f);
}

public static void main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/xdrbuffer/readwrite", test_xdrbuffer_test_write_and_read);
    Test.run();
}
