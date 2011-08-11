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

Msmrpc.OemRapiClient client;

async void test_rpc_client_initialize_async()
{
    // NOTE this is needed to tell the remote side we want to retrieve hci events
    yield client.send(new uint8[] { }, Msmrpc.OEM_RAPI_EVENT_HCI_EVENT, (uint32) 0x2de98);

    uint8[] hci_misc_version_cmd = new uint8[] {
        0x00, 0x00, 0x00, 0x00, // sequence number
        0x00, 0x00, 0x00, 0x00, // reference id
        0x0c, 0x00, 0x00, 0x00, // hci subsys id
        0x00, 0x00, 0x00, 0x00, // hci command id
        0x00, 0x00, 0x00, 0x00, // client id or unknown
        0x00, 0x00, 0x00, 0x00  // client id or unknown
    };

    yield client.send(hci_misc_version_cmd, Msmrpc.OEM_RAPI_EVENT_HCI_CALLBACK);
}

void test_rpc_client_initialize()
{
    var mainloop = new GLib.MainLoop(null, false);
    var transport = new FsoFramework.SocketTransport("tcp", "192.168.0.202", 3001);
    client = new Msmrpc.OemRapiClient(transport);

    Idle.add(() => {
        test_rpc_client_initialize_async();
        return false;
    });

    client.initialize();
    mainloop.run();
    client.shutdown();
}

public static int main(string[] args)
{
    Test.init(ref args);
    Test.add_func("/rpcclient/initialize", test_rpc_client_initialize);
    Test.run();
    return 0;
}
