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

PalmPre.RadioAccess radio_access;

async void test_palmpre_accessor_initialize_test_procedure()
{
    PalmPre.MiscClient misc_client = new PalmPre.MiscClient(radio_access);
    PalmPre.StateClient state_client = new PalmPre.StateClient(radio_access);

    yield misc_client.send_test_alive();
    // yield state_client.set_operation_mode(PalmPre.StateMode.RESET);
    // yield misc_client.send_test_alive();
}

async void test_palmpre_accessor_initialize_async()
{
    debug(@"Opening radio access ...");
    yield radio_access.open();

    radio_access.setup_complete.connect(() => {
        test_palmpre_accessor_initialize_test_procedure();
    });
}

void test_palmpre_accessor_initialize()
{
    var mainloop = new GLib.MainLoop(null, false);
    var transport = new FsoFramework.SocketTransport("tcp", "192.168.0.202", 3001);

    radio_access = new PalmPre.RadioAccess(transport);

    Idle.add(() => {
        test_palmpre_accessor_initialize_async();
        return false;
    });

    mainloop.run();

    radio_access.close();
}

public static int main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/palmpre/accessor/initialize", test_palmpre_accessor_initialize);
    Test.run();
    return 0;
}
