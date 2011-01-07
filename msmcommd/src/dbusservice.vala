/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.Daemon
{
    private const string DBUS_SERVICE_BUS               = "org.freedesktop.DBus";
    private const string DBUS_PATH_DBUS                 = "/org/freedesktop/DBus";
    private const string DBUS_INTERFACE_DBUS            = "org.freedesktop.DBus";

    public class DBusService :
        GLib.Object,
        FreeSmartphone.Resource,
        Msmcomm.Management
    {
        private FsoFramework.Logger logger;
        private FreeSmartphone.Usage usage;
        private ModemControl modem;
        private GLib.DBusConnection dbusconn;
        private string servicename;
        private string objectpath;

        //
        // private API
        //

        private void checkModemActivity() throws Msmcomm.Error
        {
            if (!modem.active)
            {
                var msg = "Modem is currently inactive; start it first!";
                throw new Msmcomm.Error.MODEM_INACTIVE(msg);
            }
        }

        private async void registerWithResource()
        {
            try
            {
                usage = yield dbusconn.get_proxy<FreeSmartphone.Usage>(FsoFramework.Usage.ServiceDBusName, FsoFramework.Usage.ServicePathPrefix, GLib.DBusProxyFlags.NONE);
                yield usage.register_resource("Modem", new GLib.ObjectPath("/org/msmcomm"));
                logger.info(@"Successfully registered resource with org.freesmartphone.ousaged");
            }
            catch (IOError e)
            {
                logger.error(@"Can't register resource with org.freesmartphone.ousaged ($(e.message)); enabling unconditionally" );
                enable();
            }
        }

        private void onRegisterResourceReply(GLib.Object? source_object, GLib.AsyncResult res)
        {
            if (res != null)
            {
                logger.error(@"Error: Can't register resource with org.freesmartphone.ousaged, enabling unconditionally...");
                enable();
            }
            else
            {
                logger.info("Ok. Registered with org.freesmartphone.ousaged");
            }
        }

        //
        // public API
        //

        public DBusService(ModemControl modem)
        {
            logger = FsoFramework.theLogger;

            this.modem = modem;
            // this.modem.requestHandleUnsolicitedResponse.connect(dispatchUnsolicitedResponse);

            /* Forward modem status to connect clients */
            this.modem.statusUpdate.connect((status) => modem_status(status));

            servicename = "org.msmcomm";
            objectpath = "/org/msmcomm";
        }

        public bool register()
        {
            try
            {
                dbusconn = GLib.Bus.get_sync(GLib.BusType.SYSTEM);


                GLib.Bus.own_name_on_connection( dbusconn, servicename, 0, 
                    ( conn, name ) => {
                        logger.debug( @"Successfully claimed busname $servicename" );
                    },
                    ( conn, name ) => {
                        logger.critical( @"Can't claim busname $servicename" );
                        Posix.exit( -1 );
                    } );

                dbusconn.register_object<FreeSmartphone.Resource>(objectpath, this);
                dbusconn.register_object<Msmcomm.Management>(objectpath, this);

                Idle.add( () => { registerWithResource(); return false; } );
            }
            catch (GLib.Error err)
            {
                logger.error(@"Could not handle DBus connection: $(err.message)");
                return false;
            }

            return true;
        }

        //
        // DBUS (org.freesmartphone.Resource)
        //

        public async void disable() throws FreeSmartphone.ResourceError
        {
            if (modem.active)
            {
                logger.debug("Resource 'Modem' should be disabled and modem is active so shutting down modem control");
                shutdown();
            }

            logger.debug("Resource 'Modem' is now disabled");
        }

        public async void enable() throws FreeSmartphone.ResourceError
        {
            logger.debug("Resource 'Modem' is now enabled");
        }

        public async void resume() throws FreeSmartphone.ResourceError
        {
            // FIXME
        }

        public async void suspend() throws FreeSmartphone.ResourceError
        {
            // FIXME
        }

        public async GLib.HashTable<string,GLib.Value?> get_dependencies () throws FreeSmartphone.ResourceError
        {
            GLib.HashTable<string,GLib.Value?> result = new GLib.HashTable<string,string>(str_hash, str_equal);
            return result;
        }

        //
        // DBUS (org.msmcomm.Management)
        //

        public async void initialize() throws GLib.Error, Msmcomm.Error
        {
            logger.info("Starting modem ...");
            if (!modem.start())
            {
                var msg = @"Could not startup connected modem";
                throw new Msmcomm.Error.FAILED(msg);
            }
        }

        public async void shutdown() throws GLib.Error, Msmcomm.Error
        {
            modem.stop();
        }

        public async void reset() throws GLib.Error, Msmcomm.Error
        {
            shutdown();
            initialize();
        }
    }
} // namespace Msmcomm

