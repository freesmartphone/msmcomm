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

using Msmcomm;

void test_palmpre_accessor_initialize()
{
    var mainloop = new GLib.MainLoop(null, false);
    var transport = new FsoFramework.SocketTransport("tcp", "192.168.0.202", 3001);

    var accessor = new PalmPre.ModemAccessor(transport);

    Idle.add(() => {
        return false;
    });

    mainloop.run();
}

public static int main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/palmpre/accessor/initialize", test_palmpre_accessor_initialize);
    Test.run();
    return 0;
}
