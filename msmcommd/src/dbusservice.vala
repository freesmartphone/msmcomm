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
    
    public delegate void UnsolicitedResponseHandler(Msmcomm.Message msg);
    
    public class UnsolicitedResponseHandlerWrapper
    {
        public UnsolicitedResponseHandler func;
    }

    public class DBusService : 
        GLib.Object,
        FreeSmartphone.Resource,
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
        private dynamic DBus.Object usage;
        
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
                reset_radio_ind(); 
            });
            
            urc_handlers[Msmcomm.EventType.CHARGER_STATUS] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.ChargerStatus chargerStatusMsg = (Msmcomm.Unsolicited.ChargerStatus) msg;
                charger_status(chargerStatusMsg.voltage);
            });
            
            urc_handlers[Msmcomm.EventType.OPERATION_MODE] = createUnsolicitedResponseHandler((msg) => {
                operation_mode();
            });
            
            urc_handlers[Msmcomm.EventType.CM_PH_INFO_AVAILABLE] = createUnsolicitedResponseHandler((msg) => {
                cm_ph_info_available();
            });
            
            urc_handlers[Msmcomm.EventType.NETWORK_STATE_INFO] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.NetworkStateInfo networkStateInfoMsg = (Msmcomm.Unsolicited.NetworkStateInfo) msg;
                
                network_state_info(networkStateInfoMsg.only_rssi_update, 
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
                
                call_incomming(callStatusMsg.number, 
                             callTypeToString(callStatusMsg.type), 
                             callStatusMsg.id, 
                             callStatusMsg.reject_type, 
                             callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_END] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                call_end(callStatusMsg.number, 
                        callTypeToString(callStatusMsg.type), 
                        callStatusMsg.id, 
                        callStatusMsg.reject_type, 
                        callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_CONNECT] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                call_connect(callStatusMsg.number, 
                            callTypeToString(callStatusMsg.type), 
                            callStatusMsg.id, 
                            callStatusMsg.reject_type, 
                            callStatusMsg.reject_value);
            });
            
            urc_handlers[Msmcomm.EventType.CALL_ORIGINATION] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.CallStatus callStatusMsg = (Msmcomm.Unsolicited.CallStatus) msg;
                
                call_origination(callStatusMsg.number, 
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
                
                network_list(networks);
            });
            
            urc_handlers[Msmcomm.EventType.PHONEBOOK_READY] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookReady phonebookReadyMsg = (Msmcomm.Unsolicited.PhonebookReady) msg;
                
                phonebook_ready(phonebookTypeToString(phonebookReadyMsg.book_type));
            });
            
            urc_handlers[Msmcomm.EventType.PHONEBOOK_MODIFIED] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookModified phonebookModifiedMsg = (Msmcomm.Unsolicited.PhonebookModified) msg;
                
                phonebook_modified(phonebookTypeToString(phonebookModifiedMsg.book_type), phonebookModifiedMsg.position);
            });
            
            /**
             * SIM
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_INSERTED] = createUnsolicitedResponseHandler((msg) => {
                sim_inserted();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_REMOVED] = createUnsolicitedResponseHandler((msg) => {
                sim_removed();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_NO_SIM] = createUnsolicitedResponseHandler((msg) => {
                sim_not_available();
            });
            
            /**
             * PIN1
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                pin1_verified();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_blocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_unblocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                pin1_enabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                pin1_disabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                pin1_changed();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN1_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_perm_blocked();
            });
            
            /**
             * PIN2
             **/
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                pin2_verified();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_blocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_unblocked();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                pin2_enabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                pin2_disabled();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                pin2_changed();
            });
            
            urc_handlers[Msmcomm.EventType.SIM_PIN2_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_perm_blocked();
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
        
        private bool registerWithResource()
        {
            usage = dbusconn.get_object( "org.freesmartphone.ousaged",
                                         "/org/freesmartphone/Usage",
                                         "org.freesmartphone.Usage" ); /* dynamic for async */
                
            var path =  new DBus.ObjectPath("/org/msmcomm");
            usage.register_resource( "Modem", path, onRegisterResourceReply );
            return false;
        }
        
        private void onRegisterResourceReply(GLib.Error err)
        {
            if (err != null)
            {
                logger.error(@"Error: $(err.message): Can't register resource with org.freesmartphone.ousaged, enabling unconditionally...");
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
            this.modem.requestHandleUnsolicitedResponse.connect(dispatchUnsolicitedResponse);
            this.modem.statusUpdate.connect((status) => { status_update(status); });
            servicename = "org.msmcomm";
            objectpath = "/org/msmcomm";
            
            urc_handlers = new Gee.HashMap<Msmcomm.EventType,UnsolicitedResponseHandlerWrapper>();
            registerUnsolicitedResponseHandlers();
        }

        public bool register()
        {
            try 
            {
                dbusconn = DBus.Bus.get(DBus.BusType.SYSTEM);
                
                
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
                
                Idle.add(registerWithResource);
            }
            catch (DBus.Error err)
            {
                logger.error(@"Could not handle DBus connection: $(err.message)");
                return false;
            }

            return true;
        }

        //
        // DBUS (org.freesmartphone.Resource)
        //

        public async void disable() throws FreeSmartphone.ResourceError, DBus.Error
        {
            modem.stop();
        }

        public async void enable() throws FreeSmartphone.ResourceError, DBus.Error
        {
            logger.info("Starting modem ...");
            if (!modem.start())
            {
                var msg = @"Could not startup connected modem";
                throw new FreeSmartphone.ResourceError.UNABLE_TO_ENABLE(msg);   
            }
        }

        public async void resume() throws FreeSmartphone.ResourceError, DBus.Error
        {
            // FIXME
        }
        
        public async void suspend() throws FreeSmartphone.ResourceError, DBus.Error
        {
            // FIXME
        }
   
        //
        // DBUS (org.msmcomm.Management)
        //

        public async void reset() throws DBus.Error, Msmcomm.Error
        {
            if(!modem.reset())
            {
                // FIXME throw some exception ...
            }
        }

        public async bool get_active() throws DBus.Error, Msmcomm.Error
        {
            return modem.active;
        }
        
        //
        // DBUS (org.msmcomm.Commands)
        //
        
        public async void test_alive() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new TestAliveCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void change_operation_mode(string mode) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChangeOperationModeCommand();
            cmd.mode = mode;
            yield modem.processCommand(cmd);
        }
        
        public async string get_imei() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetImeiCommand();
            yield modem.processCommand(cmd);
            return cmd.imei;
        }
        
        public async GLib.HashTable<string,string> get_firmware_info() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetFirmwareInfoCommand();
            yield modem.processCommand(cmd);
            return cmd.result;
        }
        
        public async void charging(string mode, string voltage) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChargingCommand();
            cmd.mode = mode;
            cmd.voltage = voltage;
            yield modem.processCommand(cmd);
        }
        
        public async GLib.HashTable<string,string> get_charger_status() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetChargerStatusCommand();
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async void reset_modem() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ResetCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void get_phone_state_info() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhoneStateInfoCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void verify_pin(string pin_type, string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new VerifyPinCommand();
            cmd.pin = pin;
            cmd.pin_type = pin_type;
            yield modem.processCommand(cmd);
        }
        
        public async void end_call(int call_id) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new EndCallCommand();
            cmd.call_id = (uint8) call_id;
            yield modem.processCommand(cmd);
        }
        
        public async void answer_call(int call_id) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new AnswerCallCommand();
            cmd.call_id = (uint8) call_id;
            yield modem.processCommand(cmd);
        }
        
        public async void dial_call(string number, bool block) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DialCallCommand();
            cmd.number = number;
            cmd.block = block;
            yield modem.processCommand(cmd);
        }
        
        public async void change_pin(string old_pin, string new_pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChangePinCommand();
            cmd.old_pin = old_pin;
            cmd.new_pin = new_pin;
            yield modem.processCommand(cmd);
        }
        
        public async void enable_pin(string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new EnablePinCommand();
            cmd.pin = pin;
            yield modem.processCommand(cmd);
        }
        
        public async void disable_pin(string pin) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DisablePinCommand();
            cmd.pin = pin;
            yield modem.processCommand(cmd);
        }
        
        public async void set_system_time(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset) throws DBus.Error, Msmcomm.Error
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
        
        public async void rssi_status(bool status) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new RssiStatusCommand();
            cmd.status = status;
            yield modem.processCommand(cmd);
        }
        
        public async GLib.HashTable<string,string> get_phonebook_properties(string book_type) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhonebookPropertiesCommand();
            cmd.book_type = book_type;
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async GLib.HashTable<string,string> read_phonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ReadPhonebookCommand();
            cmd.book_type = book_type;
            cmd.position = (uint8) position;
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async uint write_phonebook(string book_type, string number, string title) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new WritePhonebookCommand();
            cmd.book_type = book_type;
            cmd.number = number;
            cmd.title = title;
            yield modem.processCommand(cmd);
            
            return cmd.modify_id;
        }
        
        public async void delete_phonebook(string book_type, uint position) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new DeletePhonebookCommand();
            cmd.book_type = book_type;
            cmd.position = (uint8) position;
            yield modem.processCommand(cmd);
        }
        
        public async void get_network_list() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetNetworkListCommand();
            yield modem.processCommand(cmd);
        }
        
        public async void set_mode_preference(string mode) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SetModePreferenceCommand();
            cmd.mode = mode;
            yield modem.processCommand(cmd);
        }
        
        public async string sim_info(string field_type) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SimInfoCommand();
            cmd.field_type = field_type;
            yield modem.processCommand(cmd);
            
            return cmd.field_data;
        }
        
        public async uint[] get_audio_modem_tuning_params() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetAudioModemTuningParamsCommand();
            yield modem.processCommand(cmd);
            
            var tmp = new uint[1];
            return tmp;
        }
        
        public async void set_audio_profile(uint _class, uint sub_class) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new SetAudioProfileCommand();
            cmd.class = (uint8) _class;
            cmd.sub_class = (uint8) sub_class;
            yield modem.processCommand(cmd);
        }
    }
} // namespace Msmcomm

