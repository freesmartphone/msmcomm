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
    public errordomain Error
    {
        INVALID_ARGUMENTS,
        FAILED,
        MODEM_INACTIVE,
    }
 
    [DBus (timeout = 120000, name = "org.msmcomm.Management")]
    public interface Management : GLib.Object
    {
        public abstract async void start() throws DBus.Error, Msmcomm.Error;
        public abstract async void stop() throws DBus.Error, Msmcomm.Error;
        public abstract async void reset() throws DBus.Error, Msmcomm.Error;
        public abstract async bool get_active() throws DBus.Error, Msmcomm.Error;
    }
    
    [DBus (timeout = 120000, name = "org.msmcomm.Commands")]
    public interface Commands : GLib.Object
    {
        public abstract async void TestAlive() throws DBus.Error, Msmcomm.Error;
        public abstract async void ChangeOperationMode(string mode) throws DBus.Error, Msmcomm.Error;
        public abstract async void GetPhoneStateInfo() throws DBus.Error, Msmcomm.Error;
        public abstract async void Reset() throws DBus.Error, Msmcomm.Error;
        public abstract async GLib.HashTable<string,string> GetFirmwareInfo() throws DBus.Error, Msmcomm.Error;
        public abstract async string GetImei() throws DBus.Error, Msmcomm.Error;
       
        public abstract async void Charging(string mode, string voltage) throws DBus.Error, Msmcomm.Error;
        public abstract async GLib.HashTable<string,string> GetChargerStatus() throws DBus.Error, Msmcomm.Error;
        
        public abstract async void VerifyPin(string pin_type, string pin) throws DBus.Error, Msmcomm.Error;
        public abstract async void ChangePin(string old_pin, string new_pin) throws DBus.Error, Msmcomm.Error;
        public abstract async void EnablePin(string pin) throws DBus.Error, Msmcomm.Error;
        public abstract async void DisablePin(string pin) throws DBus.Error, Msmcomm.Error;
        
        public abstract async void EndCall(int call_id) throws DBus.Error, Msmcomm.Error;
        public abstract async void AnswerCall(int call_id) throws DBus.Error, Msmcomm.Error;
        public abstract async void DialCall(string number, bool block) throws DBus.Error, Msmcomm.Error;
        
        public abstract async void SetSystemTime(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset) throws DBus.Error, Msmcomm.Error;
        public abstract async void RssiStatus(bool status) throws DBus.Error, Msmcomm.Error;
        
        public abstract async GLib.HashTable<string,string> GetPhonebookProperties(string book_type) throws DBus.Error, Msmcomm.Error;
        public abstract async GLib.HashTable<string,string> ReadPhonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error;
        public abstract async uint WritePhonebook(string book_type, string number, string title) throws DBus.Error, Msmcomm.Error;
        public abstract async void DeletePhonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error;
        
        public abstract async void GetNetworkList() throws DBus.Error, Msmcomm.Error;
        public abstract async void SetModePreference(string mode) throws DBus.Error, Msmcomm.Error;
        public abstract async string SimInfo(string field_type) throws DBus.Error, Msmcomm.Error;
        public abstract async uint[] GetAudioModemTuningParams() throws DBus.Error, Msmcomm.Error;
        public abstract async void SetAudioProfile(uint class, uint sub_class) throws DBus.Error, Msmcomm.Error;
    }
    
    [DBus (timeout = 120000, name = "org.msmcomm.Unsolicited")]
    public interface ResponseUnsolicited : GLib.Object
    {
        public signal void PowerState(uint state);
        public signal void ChargerStatus(uint voltage);
        public signal void CallIncoming(string number, string type, uint id, uint reject_type, uint reject_value);
        public signal void CallConnect(string number, string type, uint id, uint reject_type, uint reject_value);
        public signal void CallEnd(string number, string type, uint id, uint reject_type, uint reject_value);
        public signal void CallOrigination(string number, string type, uint id, uint reject_type, uint reject_value);
        public signal void NetworkList(GLib.HashTable<string,string> networks);
        public signal void NetworkStateInfo(bool only_rssi_update, uint change_field, uint new_value, string operator_name, uint rssi, uint ecio, uint service_domain, uint service_capability, bool gprs_attached, uint roam);
        public signal void PhonebookReady(string book_type);
        public signal void PhonebookModified(string book_type, uint position);
        public signal void CmPh(string[] plmns);
        
        public signal void ResetRadioInd();
        public signal void OperationMode();
        public signal void CmPhInfoAvailable();
        
        public signal void SimInserted();
        public signal void SimRemoved();
        public signal void SimNotAvailable();
        
        public signal void Pin1Verified();
        public signal void Pin1Blocked();
        public signal void Pin1Unblocked();
        public signal void Pin1Enabled();
        public signal void Pin1Disabled();
        public signal void Pin1Changed();
        public signal void Pin1PermBlocked();
        
        public signal void Pin2Verified();
        public signal void Pin2Blocked();
        public signal void Pin2Unblocked();
        public signal void Pin2Enabled();
        public signal void Pin2Disabled();
        public signal void Pin2Changed();
        public signal void Pin2PermBlocked();
        
    }
    
    public delegate void UnsolicitedResponseHandler(Msmcomm.Message msg);
    
    public class UnsolicitedResponseHandlerWrapper
    {
        public UnsolicitedResponseHandler func;
    }

    public class DBusService : 
        GLib.Object, 
        Msmcomm.Management,
        Msmcomm.Commands,
        Msmcomm.ResponseUnsolicited
    {
        private FsoFramework.Logger logger;
        private ModemControl modem;
        private DBus.Connection dbusconn;
        private dynamic DBus.Object dbusobj;
        private string servicename;
        private string objectpath;
        
        private Gee.HashMap<Msmcomm.EventType,UnsolicitedResponseHandlerWrapper> urc_handlers;
        
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
        
        private string phonebookTypeToString(Msmcomm.PhonebookType book_type)
        {
            string result = "unknown";
            
            switch (book_type)
            {
                case Msmcomm.PhonebookType.ADN:
                    result = "adn";
                    break;
                case Msmcomm.PhonebookType.FDN:
                    result = "fdn";
                    break;
                case Msmcomm.PhonebookType.SDN:
                    result = "SDN";
                    break;
                case Msmcomm.PhonebookType.MBN:
                    result = "mbn";
                    break;
                case Msmcomm.PhonebookType.MBDN:
                    result = "mbdn";
                    break;
                case Msmcomm.PhonebookType.EFECC:
                    result = "efecc";
                    break;
            }
            
            return result;
        }
        
        private string callTypeToString(Msmcomm.CallType type)
        {
            string result = "unknown";
            
            switch (type)
            {
                case Msmcomm.CallType.AUDIO:
                    result = "audio";
                    break;
                case Msmcomm.CallType.DATA:
                    result = "data";
                    break;
            }
            
            return result;
        }
        
        private UnsolicitedResponseHandlerWrapper createUnsolicitedResponseHandler(UnsolicitedResponseHandler func)
        {
            UnsolicitedResponseHandlerWrapper handler = new UnsolicitedResponseHandlerWrapper();
            handler.func = func;
            return handler;
        }
        
        private void registerUnsolicitedResponseHandlers()
        {
            urc_handlers[Msmcomm.EventType.RESET_RADIO_IND] = createUnsolicitedResponseHandler((msg) => { 
                ResetRadioInd(); 
            });
            
            urc_handlers[Msmcomm.EventType.CHARGER_STATUS] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.ChargerStatus chargerStatusMsg = (Msmcomm.Unsolicited.ChargerStatus) msg;
                ChargerStatus(chargerStatusMsg.voltage);
            });
            
            urc_handlers[Msmcomm.EventType.OPERATION_MODE] = createUnsolicitedResponseHandler((msg) => {
                OperationMode();
            });
            
            urc_handlers[Msmcomm.EventType.CM_PH_INFO_AVAILABLE] = createUnsolicitedResponseHandler((msg) => {
                CmPhInfoAvailable();
            });
            
            urc_handlers[Msmcomm.EventType.NETWORK_STATE_INFO] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.NetworkStateInfo networkStateInfoMsg = (Msmcomm.Unsolicited.NetworkStateInfo) msg;
                
                NetworkStateInfo(networkStateInfoMsg.only_rssi_update, 
                                 networkStateInfoMsg.change_field,
                                 networkStateInfoMsg.new_value,
                                 networkStateInfoMsg.operator_name,
                                 networkStateInfoMsg.rssi,
                                 networkStateInfoMsg.ecio,
                                 networkStateInfoMsg.service_domain,
                                 networkStateInfoMsg.service_capability,
                                 (bool) networkStateInfoMsg.gprs_attached,
                                 networkStateInfoMsg.roam);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_INCOMMING] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                CallIncoming(callStatusMsg.number, 
                             callTypeToString(callStatusMsg.type), 
                             callStatusMsg.id, 
                             callStatusMsg.reject_type, 
                             callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_END] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                CallEnd(callStatusMsg.number, 
                        callTypeToString(callStatusMsg.type), 
                        callStatusMsg.id, 
                        callStatusMsg.reject_type, 
                        callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_CONNECT] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                CallConnect(callStatusMsg.number, 
                            callTypeToString(callStatusMsg.type), 
                            callStatusMsg.id, 
                            callStatusMsg.reject_type, 
                            callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_ORIGINATION] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                CallOrigination(callStatusMsg.number, 
                                callTypeToString(callStatusMsg.type), 
                                callStatusMsg.id, 
                                callStatusMsg.reject_type, 
                                callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.GET_NETWORKLIST] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.GetNetworkList networkListMsg = (Msmcomm.Unsolicited.GetNetworkList) msg;
                GLib.HashTable<string,string> networks = new HashTable<string,string>(str_hash, str_equal);
                
                for(int n = 0; n < networkListMsg.network_count; n++)
                {
                    networks.insert(@"$(networkListMsg.getPlmn(n))", @"$(networkListMsg.getNetworkName(n))");
                }
                
                NetworkList(networks);
            });
            
            urc_handlers[Msmcomm.EventType.PHONEBOOK_READY] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookReady phonebookReadyMsg = (Msmcomm.Unsolicited.PhonebookReady) msg;
                
                PhonebookReady(phonebookTypeToString(phonebookReadyMsg.book_type));
            });
            
            urc_handlers[Msmcomm.EventType.PHONEBOOK_MODIFIED] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookModified phonebookModifiedMsg = (Msmcomm.Unsolicited.PhonebookModified) msg;
                
                PhonebookModified(phonebookTypeToString(phonebookModifiedMsg.book_type), phonebookModifiedMsg.position);
            });
            
            /**
             * SIM
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_INSERTED] = createUnsolicitedResponseHandler((msg) => {
                SimInserted();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_REMOVED] = createUnsolicitedResponseHandler((msg) => {
                SimRemoved();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_NO_SIM] = createUnsolicitedResponseHandler((msg) => {
                SimNotAvailable();
            });
            
            /**
             * PIN1
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Verified();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Blocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Unblocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Enabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Disabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                Pin1Changed();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin1PermBlocked();
            });
            
            /**
             * PIN2
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Verified();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Blocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Unblocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Enabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Disabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                Pin2Changed();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                Pin2PermBlocked();
            });
        }
        
        private void dispatchUnsolicitedResponse(Msmcomm.EventType type, Msmcomm.Message message)
        {
            UnsolicitedResponseHandlerWrapper handler = null;
            
            if (urc_handlers.has_key(type))
            {
                handler = urc_handlers[type];
                handler.func(message);
            }
        }

        //
        // public API
        //

        public DBusService(ModemControl modem)
        {
            logger = FsoFramework.theLogger;
            this.modem = modem;
            this.modem.requestHandleUnsolicitedResponse.connect(dispatchUnsolicitedResponse);
            servicename = "org.msmcomm";
            objectpath = "/org/msmcomm";
            
            urc_handlers = new Gee.HashMap<Msmcomm.EventType,UnsolicitedResponseHandlerWrapper>();
            registerUnsolicitedResponseHandlers();
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

        public async void start() throws DBus.Error, Msmcomm.Error
        {
            logger.debug("SERVICE: start()");
            if (!modem.start())
            {
                // FIXME throw some exception ...
            }
        }

        public async void stop() throws DBus.Error, Msmcomm.Error
        {
            logger.debug("SERVICE: stop()");
            modem.stop();
        }

        public async void reset() throws DBus.Error, Msmcomm.Error
        {
            logger.debug("SERVICE: reset()");
            if(!modem.reset())
            {
                // FIXME throw some exception ...
            }
        }

        public async bool get_active() throws DBus.Error, Msmcomm.Error
        {
            logger.debug("SERVICE: get_active()");
            return modem.active;
        }
        
        //
        // DBUS (org.msmcomm.Commands)
        //
        
        public async void TestAlive() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new TestAliveCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void ChangeOperationMode(string mode) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChangeOperationModeCommand();
            cmd.mode = mode;
            yield modem.processCommand(cmd);
        }
        
        public async string GetImei() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetImeiCommand();
            yield modem.processCommand(cmd);
            return cmd.imei;
        }
        
        public async GLib.HashTable<string,string> GetFirmwareInfo() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetFirmwareInfoCommand();
            yield modem.processCommand(cmd);
            return cmd.result;
        }
        
        public async void Charging(string mode, string voltage) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChargingCommand();
            cmd.mode = mode;
            cmd.voltage = voltage;
            yield modem.processCommand(cmd);
        }
        
        public async GLib.HashTable<string,string> GetChargerStatus() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetChargerStatusCommand();
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async void Reset() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ResetCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void GetPhoneStateInfo() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhoneStateInfoCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void VerifyPin(string pin_type, string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new VerifyPinCommand();
            cmd.pin = pin;
            cmd.pin_type = pin_type;
            yield modem.processCommand(cmd);
        }
        
        public async void EndCall(int call_id) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new EndCallCommand();
            cmd.call_id = (uint8) call_id;
            yield modem.processCommand(cmd);
        }
        
        public async void AnswerCall(int call_id) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new AnswerCallCommand();
            cmd.call_id = (uint8) call_id;
            yield modem.processCommand(cmd);
        }
        
        public async void DialCall(string number, bool block) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DialCallCommand();
            cmd.number = number;
            cmd.block = block;
            yield modem.processCommand(cmd);
        }
        
        public async void ChangePin(string old_pin, string new_pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChangePinCommand();
            cmd.old_pin = old_pin;
            cmd.new_pin = new_pin;
            yield modem.processCommand(cmd);
        }
        
        public async void EnablePin(string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new EnablePinCommand();
            cmd.pin = pin;
            yield modem.processCommand(cmd);
        }
        
        public async void DisablePin(string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DisablePinCommand();
            cmd.pin = pin;
            yield modem.processCommand(cmd);
        }
        
        public async void SetSystemTime(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SetSystemTimeCommand();
            cmd.year = year;
            cmd.month = month;
            cmd.day = day;
            cmd.hours = hours;
            cmd.minutes = minutes;
            cmd.seconds = seconds;
            cmd.timezone_offset = timezone_offset;
            yield modem.processCommand(cmd);
        }
        
        public async void RssiStatus(bool status) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new RssiStatusCommand();
            cmd.status = status;
            yield modem.processCommand(cmd);
        }
        
        public async GLib.HashTable<string,string> GetPhonebookProperties(string book_type) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhonebookPropertiesCommand();
            cmd.book_type = book_type;
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async GLib.HashTable<string,string> ReadPhonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ReadPhonebookCommand();
            cmd.book_type = book_type;
            cmd.position = (uint8) position;
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async uint WritePhonebook(string book_type, string number, string title) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new WritePhonebookCommand();
            cmd.book_type = book_type;
            cmd.number = number;
            cmd.title = title;
            yield modem.processCommand(cmd);
            
            return cmd.modify_id;
        }
        
        public async void DeletePhonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DeletePhonebookCommand();
            cmd.book_type = book_type;
            cmd.position = (uint8) position;
            yield modem.processCommand(cmd);
        }
        
        public async void GetNetworkList() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetNetworkListCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void SetModePreference(string mode) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SetModePreferenceCommand();
            cmd.mode = mode;
            yield modem.processCommand(cmd);
        }
        
        public async string SimInfo(string field_type) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SimInfoCommand();
            cmd.field_type = field_type;
            yield modem.processCommand(cmd);
            
            return cmd.field_data;
        }
        
        public async uint[] GetAudioModemTuningParams() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetAudioModemTuningParamsCommand();
            yield modem.processCommand(cmd);
            
            var tmp = new uint[1];
            return tmp;
        }
        
        public async void SetAudioProfile(uint _class, uint sub_class) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SetAudioProfileCommand();
            cmd.class = (uint8) _class;
            cmd.sub_class = (uint8) sub_class;
            yield modem.processCommand(cmd);
        }
    }
} // namespace Msmcomm

