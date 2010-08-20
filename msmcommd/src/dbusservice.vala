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

namespace Msmcomm
{
    private const string DBUS_SERVICE_BUS               = "org.freedesktop.DBus";
    private const string DBUS_PATH_DBUS                 = "/org/freedesktop/DBus";
    private const string DBUS_INTERFACE_DBUS            = "org.freedesktop.DBus";
    
    [DBus (name = "org.msmcomm.Management")]
    public interface IDaemonService : GLib.Object
    {
        public abstract async void start() throws DBus.Error;
        public abstract async void stop() throws DBus.Error;
        public abstract async void reset() throws DBus.Error;
        public abstract async bool get_active() throws DBus.Error;
        
        public abstract async void TestAlive() throws DBus.Error, Msmcomm.CommandError;
        public abstract async void ChangeOperationMode(string mode) throws DBus.Error, Msmcomm.CommandError;
    }

    [Dbus (name = "org.msmcomm.Management")]
    public class DBusService : GLib.Object, IDaemonService
    {
        private FsoFramework.Logger logger;
        private ModemControl modem;
        private DBus.Connection dbusconn;
        private dynamic DBus.Object dbusobj;
        private string servicename;
        private string objectpath;

        //
        // public API
        //

        public DBusService(ModemControl modem)
        {
            logger = FsoFramework.theLogger;
            this.modem = modem;
            servicename = "org.msmcomm";
            objectpath = "/org/msmcomm";
        }

        public bool register()
        {
            try 
            {
                dbusconn = DBus.Bus.get(DBus.BusType.SESSION);
                dbusobj = dbusconn.get_object(DBUS_SERVICE_BUS, 
                                              DBUS_PATH_DBUS,
                                              DBUS_INTERFACE_DBUS);

                uint res = dbusobj.RequestName(servicename, (uint) 0);

                if (res != DBus.RequestNameReply.PRIMARY_OWNER)
                {
                    logger.critical(@"Can't accquire service name $servicename; service already running or not allowed in dbus configuration");
                    return false;
                }

                dbusconn.register_object(objectpath, this);
            }
            catch (DBus.Error err)
            {
                logger.error(@"Could not handle DBus connection: $(err.message)");
                return false;
            }

            return true;
        }
   
        //
        // DBUS (org.msmcomm.Management)
        //

        public async void start() throws DBus.Error
        {
            logger.debug("SERVICE: start()");
            if (!modem.start())
            {
                // FIXME throw some exception ...
            }
        }

        public async void stop() throws DBus.Error
        {
            logger.debug("SERVICE: stop()");
            modem.stop();
        }

        public async void reset() throws DBus.Error
        {
            logger.debug("SERVICE: reset()");
            if(!modem.reset())
            {
                // FIXME throw some exception ...
            }
        }

        public async bool get_active() throws DBus.Error
        {
            logger.debug("SERVICE: get_active()");
            return modem.active;
        }
        
        public async void TestAlive() throws DBus.Error, Msmcomm.CommandError
        {
            var cmd = new TestAliveCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void ChangeOperationMode(string mode) throws DBus.Error, Msmcomm.CommandError
        {
            var cmd = new ChangeOperationModeCommand();
            cmd.mode = mode;
            yield modem.processCommand(cmd);
        }
    }
} // namespace Msmcomm
