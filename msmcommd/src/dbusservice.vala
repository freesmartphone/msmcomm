/**
 * This file is part of msmcommd.
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.Daemon
{
    private const string DBUS_SERVICE_BUS               = "org.freedesktop.DBus";
    private const string DBUS_PATH_DBUS                 = "/org/freedesktop/DBus";
    private const string DBUS_INTERFACE_DBUS            = "org.freedesktop.DBus";

    public class DBusService :
        BaseService,
        FreeSmartphone.Resource,
        Msmcomm.Management
    {
        private FreeSmartphone.Usage usage;
        private GLib.DBusConnection dbusconn;
        private string servicename;
        private string objectpath;
        private FsoFramework.DBusServiceNotifier dbusnotifier;
        private bool resourceRegistered = false;
        private bool resourceRegistrationPending = false;

        private Gee.HashMap<GLib.Type, BaseService> services;

        //
        // private API
        //

        private void onUsageServiceAppearing(string busname)
        {
            if (busname != FsoFramework.Usage.ServiceDBusName)
                return;

            if ( !resourceRegistered && !resourceRegistrationPending )
            {
                logger.debug(@"Busname $busname appeared. Registering with resource ...");

                resourceRegistrationPending = true;
                Idle.add( () => { registerWithResource(); return false; } );
            }
        }

        private void onUsageServiceDisappearing(string busname)
        {
            if (busname != FsoFramework.Usage.ServiceDBusName)
                return;

            logger.error( @"Lost resource registration as $busname disappeared!" );
            resourceRegistered = false;
        }

        private async void registerWithResource()
        {
            try
            {
                usage = yield dbusconn.get_proxy<FreeSmartphone.Usage>(FsoFramework.Usage.ServiceDBusName,
                                                                      FsoFramework.Usage.ServicePathPrefix,
                                                                      GLib.DBusProxyFlags.NONE);
            }
            catch (GLib.Error error0)
            {
                logger.error(@"Can not retrieve proxy for org.freesmartphone.ousage service: $(error0.message)!");
            }

            try
            {
                yield usage.register_resource("Modem", new GLib.ObjectPath("/org/msmcomm"));
                logger.info(@"Successfully registered resource with org.freesmartphone.ousaged");

                resourceRegistered = true;
                resourceRegistrationPending = false;
            }
            catch (GLib.Error error1)
            {
                logger.error(@"Can't register resource with org.freesmartphone.ousaged: $(error1.message)!");
            }

        }

        protected override string repr()
        {
            return "";
        }

        /**
         * Find the correct service for the unsolcited response message
         **/
        private void dispatchUnsolicitedResponse(BaseMessage message)
        {
            foreach(BaseService service in services.values)
            {
                if (service.handleUnsolicitedResponse(message))
                {
                    break;
                }
            }
        }

        /**
         * Register the service of type T to the bus (services are stored internally in
         * the services hash map and created on class construction)
         **/
        private void registerService<T>()
        {
            T service = services[typeof(T)];

            if (service == null)
            {
                logger.error(@"Could not register dbus service: $(typeof(T).name())");
                return;
            }

            try
            {
                dbusconn.register_object<T>(objectpath, service);
            }
            catch (GLib.Error err0)
            {
                logger.error(@"Could not register dbus service: $(typeof(T).name()): $(err0.message)");
            }
        }

        //
        // public API
        //

        public DBusService(ModemControl modem)
        {
            base(modem);

            dbusnotifier = new FsoFramework.DBusServiceNotifier();
            dbusnotifier.notifyDisappearing(FsoFramework.Usage.ServiceDBusName, onUsageServiceDisappearing);
            dbusnotifier.notifyAppearing(FsoFramework.Usage.ServiceDBusName, onUsageServiceAppearing);

            /* Forward modem status to connect clients */
            this.modem.statusUpdate.connect((status) => modem_status(status));
            /* Handle all incomming unsolicited response */
            this.modem.requestHandleUnsolicitedResponse.connect(dispatchUnsolicitedResponse);

            servicename = "org.msmcomm";
            objectpath = "/org/msmcomm";

            /* Create all services */
            services = new Gee.HashMap<GLib.Type,BaseService>();
            services[typeof(Msmcomm.Misc)] = new MiscService(modem);
            services[typeof(Msmcomm.State)] = new StateService(modem);
            services[typeof(Msmcomm.Sim)] = new SimService(modem);
            services[typeof(Msmcomm.Phonebook)] = new PhonebookService(modem);
            services[typeof(Msmcomm.Call)] = new CallService(modem);
            services[typeof(Msmcomm.Network)] = new NetworkService(modem);
            services[typeof(Msmcomm.Voicemail)] = new VoicemailService(modem);
            services[typeof(Msmcomm.Sound)] = new SoundService(modem);
            services[typeof(Msmcomm.Sms)] = new SmsService(modem);
            services[typeof(Msmcomm.Sups)] = new SupsService(modem);
            services[typeof(Msmcomm.GPS)] = new GpsService(modem);
        }

        public bool register()
        {
            try
            {
                dbusconn = GLib.Bus.get_sync(GLib.BusType.SYSTEM);

                resourceRegistered = false;
                resourceRegistrationPending = true;
                Idle.add(() => { registerWithResource(); return false; });

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

                /* register all specific command services */
                registerService<Msmcomm.Misc>();
                registerService<Msmcomm.State>();
                registerService<Msmcomm.Sim>();
                registerService<Msmcomm.Phonebook>();
                registerService<Msmcomm.Call>();
                registerService<Msmcomm.Network>();
                registerService<Msmcomm.Voicemail>();
                registerService<Msmcomm.Sound>();
                registerService<Msmcomm.Sms>();
                registerService<Msmcomm.Sups>();
                registerService<Msmcomm.GPS>();
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
            modem.handlePowerState(ModemPowerState.RESUME);
        }

        public async void suspend() throws FreeSmartphone.ResourceError
        {
            var result = yield modem.handlePowerState(ModemPowerState.SUSPEND);
            if (!result)
            {
                // FIXME we need some correct named error first
                // throw new FreeSmartphone.ResourceError ...
            }
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
            if (modem.active)
            {
                logger.warning("Don't initializing the modem again as it is already initialized!");
                return;
            }

            logger.info("Powering up the modem on user request ...");
            if (!modem.start())
            {
                var msg = @"Could not startup connected modem";
                throw new Msmcomm.Error.FAILED(msg);
            }
        }

        public async void shutdown() throws GLib.Error, Msmcomm.Error
        {
            if (!modem.active)
            {
                logger.warning("Don't shutting down the modem as it is already in shutdown state!");
                return;
            }

            modem.stop();
        }

        public async void reset() throws GLib.Error, Msmcomm.Error
        {
            shutdown();
            initialize();
        }
    }
} // namespace Msmcomm

