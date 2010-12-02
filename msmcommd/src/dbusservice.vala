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
        
        private Gee.HashMap<Msmcomm.MessageType,UnsolicitedResponseHandlerWrapper> urc_handlers;
        
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
        
        private UnsolicitedResponseHandlerWrapper createUnsolicitedResponseHandler(UnsolicitedResponseHandler func)
        {
            UnsolicitedResponseHandlerWrapper handler = new UnsolicitedResponseHandlerWrapper();
            handler.func = func;
            return handler;
        }

        private void registerUnsolicitedResponseHandlers()
        {
            urc_handlers[Msmcomm.MessageType.EVENT_RESET_RADIO_IND] = createUnsolicitedResponseHandler((msg) => { 
                reset_radio_ind(); 
            });

            urc_handlers[Msmcomm.MessageType.EVENT_CHARGER_STATUS] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.ChargerStatus chargerStatusMsg = (Msmcomm.Unsolicited.ChargerStatus) msg;
                charger_status(chargerStatusMsg.voltage);
            });

            urc_handlers[Msmcomm.MessageType.EVENT_OPERATION_MODE] = createUnsolicitedResponseHandler((msg) => {
                operation_mode();
            });

            urc_handlers[Msmcomm.MessageType.EVENT_CM_PH_INFO_AVAILABLE] = createUnsolicitedResponseHandler((msg) => {
                cm_ph_info_available();
            });

            urc_handlers[Msmcomm.MessageType.EVENT_NETWORK_STATE_INFO] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.NetworkStateInfo networkStateInfoMsg = (Msmcomm.Unsolicited.NetworkStateInfo) msg;

                var reg_status = NetworkRegistrationStatus.INVALID;

                switch ( networkStateInfoMsg.registration_status )
                {
                    case Msmcomm.NetworkRegistrationStatusType.NO_SERVICE:
                        reg_status = Msmcomm.NetworkRegistrationStatus.NO_SERVICE;
                        break;
                    case Msmcomm.NetworkRegistrationStatusType.DENIED:
                        reg_status = Msmcomm.NetworkRegistrationStatus.DENIED;
                        break;
                    case Msmcomm.NetworkRegistrationStatusType.ROAMING:
                        reg_status = Msmcomm.NetworkRegistrationStatus.ROAMING;
                        break;
                    case Msmcomm.NetworkRegistrationStatusType.SEARCHING:
                        reg_status = Msmcomm.NetworkRegistrationStatus.SEARCHING;
                        break;
                    case Msmcomm.NetworkRegistrationStatusType.HOME:
                        reg_status = Msmcomm.NetworkRegistrationStatus.HOME;
                        break;
                    case Msmcomm.NetworkRegistrationStatusType.UNKNOWN:
                        reg_status = Msmcomm.NetworkRegistrationStatus.UNKNOWN;
                        break;
                }

                var ns_info = NetworkStateInfo(networkStateInfoMsg.only_rssi_update, 
                                               networkStateInfoMsg.change_field,
                                               networkStateInfoMsg.new_value,
                                               networkStateInfoMsg.operator_name == null ? "" : networkStateInfoMsg.operator_name,
                                               networkStateInfoMsg.rssi,
                                               networkStateInfoMsg.ecio,
                                               networkStateInfoMsg.service_domain,
                                               networkStateInfoMsg.service_capability,
                                               (bool) networkStateInfoMsg.gprs_attached,
                                               networkStateInfoMsg.roam,
                                               reg_status);
                
                network_state_info(ns_info);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_CM_CALL_INCOMMING] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.Call callStatusMsg = (Msmcomm.Unsolicited.Call) msg;
                
                var info = CallInfo(callStatusMsg.number, 
                                    callTypeToString(callStatusMsg.type), 
                                    callStatusMsg.id, 
                                    callStatusMsg.reject_type, 
                                    callStatusMsg.reject_value);
                call_incomming(info);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_CM_CALL_END] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.Call callStatusMsg = (Msmcomm.Unsolicited.Call) msg;
                
                var info = CallInfo(callStatusMsg.number, 
                                    callTypeToString(callStatusMsg.type), 
                                    callStatusMsg.id, 
                                    callStatusMsg.reject_type, 
                                    callStatusMsg.reject_value);                
                call_end(info);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_CM_CALL_CONNECT] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.Call callStatusMsg = (Msmcomm.Unsolicited.Call) msg;
                
                var info = CallInfo(callStatusMsg.number, 
                                    callTypeToString(callStatusMsg.type), 
                                    callStatusMsg.id, 
                                    callStatusMsg.reject_type, 
                                    callStatusMsg.reject_value);
                call_connect(info);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_CM_CALL_ORIGINATION] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.Call callStatusMsg = (Msmcomm.Unsolicited.Call) msg;
                
                var info = CallInfo(callStatusMsg.number, 
                                    callTypeToString(callStatusMsg.type), 
                                    callStatusMsg.id, 
                                    callStatusMsg.reject_type, 
                                    callStatusMsg.reject_value);
                call_origination(info);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_GET_NETWORKLIST] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.GetNetworkList networkListMsg = (Msmcomm.Unsolicited.GetNetworkList) msg;
                NetworkProvider[] networks = { };
                
                for(int n = 0; n < networkListMsg.network_count; n++)
                {
                    var np = NetworkProvider(networkListMsg.getNetworkName(n),
                                             networkListMsg.getPlmn(n));
                    networks += np;
                }
                
                network_list(networks);
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_PHONEBOOK_READY] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookReady phonebookReadyMsg = (Msmcomm.Unsolicited.PhonebookReady) msg;
                
                phonebook_ready(convertPhonebookType(phonebookReadyMsg.book_type));    
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_PHONEBOOK_MODIFIED] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.PhonebookModified phonebookModifiedMsg = (Msmcomm.Unsolicited.PhonebookModified) msg;
                
                phonebook_modified(convertPhonebookType(phonebookModifiedMsg.book_type), phonebookModifiedMsg.position);
            });
            
            /**
             * SIM
             **/
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_INSERTED] = createUnsolicitedResponseHandler((msg) => {
                sim_inserted();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_REMOVED] = createUnsolicitedResponseHandler((msg) => {
                sim_removed();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_NO_SIM] = createUnsolicitedResponseHandler((msg) => {
                sim_not_available();
            });
            
            /**
             * PIN1
             **/
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                pin1_verified();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_blocked();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_unblocked();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                pin1_enabled();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                pin1_disabled();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                pin1_changed();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN1_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin1_perm_blocked();
            });
            
            /**
             * PIN2
             **/
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_VERIFIED] = createUnsolicitedResponseHandler((msg) => {
                pin2_verified();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_blocked();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_UNBLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_unblocked();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_ENABLED] = createUnsolicitedResponseHandler((msg) => {
                pin2_enabled();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_DISABLED] = createUnsolicitedResponseHandler((msg) => {
                pin2_disabled();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_CHANGED] = createUnsolicitedResponseHandler((msg) => {
                pin2_changed();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SIM_PIN2_PERM_BLOCKED] = createUnsolicitedResponseHandler((msg) => {
                pin2_perm_blocked();
            });
            
            /**
             * SMS
             **/
             
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_RECEIVED_MESSAGE] = createUnsolicitedResponseHandler((msg) => {
                unowned Msmcomm.Unsolicited.SMS.SmsRecieved smsRecievedMsg = (Msmcomm.Unsolicited.SMS.SmsRecieved) msg;
                
                Msmcomm.SmsInfo info = Msmcomm.SmsInfo(smsRecievedMsg.sender_number, smsRecievedMsg.pdu);
                sms_message_recieved(info); 
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_MESSAGE_LIST] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_message_list();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_gw_domain_pref();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_EVENT_ROUTES] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_event_routes();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_MEMORY_STATUS] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_memory_status();
            });
            
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_memory_status_set();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_CFG_GW_READY] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_cfg_gw_ready();
            });
            
            urc_handlers[Msmcomm.MessageType.EVENT_SMS_WMS_READ_TEMPLATE] = createUnsolicitedResponseHandler((msg) => {
                sms_wms_read_template();
            });
    
        }
        
        private void dispatchUnsolicitedResponse(Msmcomm.MessageType type, Msmcomm.Message message)
        {
            UnsolicitedResponseHandlerWrapper handler = null;
            
            //logger.debug(@"Got message: $(message.to_string())");
            
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
            
            urc_handlers = new Gee.HashMap<Msmcomm.MessageType,UnsolicitedResponseHandlerWrapper>();
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
                
                #if 0
                Idle.add(registerWithResource);
                #endif
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
        
        public async GLib.HashTable<string,GLib.Value?> get_dependencies () throws FreeSmartphone.ResourceError, DBus.Error
        {
            GLib.HashTable<string,GLib.Value?> result = new GLib.HashTable<string,string>(str_hash, str_equal);
            return result;
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
        
        public async void change_operation_mode(ModemOperationMode mode) throws DBus.Error, Msmcomm.Error
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
        
        public async FirmwareInfo get_firmware_info() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetFirmwareInfoCommand();
            yield modem.processCommand(cmd);
            
            // WORKAROUND a nasty vala bug with structs ...
            // try: return cmd.result; and you will get this error:
            // dbusservice.c: In function ‘msmcomm_dbus_service_real_get_firmware_info_co’:
            // dbusservice.c:3539: error: lvalue required as unary ‘&’ operand
            
            // NOTE Need to fix this error, when I have a little bit more time !!  
            
            return FirmwareInfo(cmd.result.version_string, 
                                cmd.result.hci_version);
        }
        
        public async void charging(ChargerStatusMode mode, ChargerStatusVoltage voltage) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ChargingCommand();
            cmd.mode = mode;
            cmd.voltage = voltage;
            yield modem.processCommand(cmd);
        }
        
        public async ChargerStatus get_charger_status() throws DBus.Error, Msmcomm.Error
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
        
        public async PhoneStateInfo get_phone_state_info() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhoneStateInfoCommand();
            yield modem.processCommand(cmd);
            
            return cmd.result;
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
        
        public async void originate_call(string number, bool block) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new OriginateCallCommand();
            cmd.number = number;
            cmd.block = block;
            yield modem.processCommand(cmd);
        }
        
        public async void execute_call_sups_command(CallCommandType command_type, int call_id) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ManageCallsCommand();
            cmd.command_type = command_type;
            cmd.call_id = call_id;
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
        
        public async PhonebookProperties get_phonebook_properties(PhonebookBookType book_type) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetPhonebookPropertiesCommand();
            cmd.book_type = book_type;
            yield modem.processCommand(cmd);
            
            return cmd.result;
        }
        
        public async PhonebookEntry read_phonebook(PhonebookBookType book_type, uint position) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new ReadPhonebookCommand();
            cmd.book_type = book_type;
            cmd.position = (uint8) position;
            yield modem.processCommand(cmd);
            
            // NOTE Seed get_firmware_info method for description of this
            // workaround ...
            return new PhonebookEntry(cmd.result.book_type,
                                      cmd.result.position,
                                      cmd.result.number,
                                      cmd.result.title,
                                      cmd.result.encoding_type);
        }
        
        public async uint write_phonebook(PhonebookBookType book_type, string number, string title) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new WritePhonebookCommand();
            cmd.book_type = book_type;
            cmd.number = number;
            cmd.title = title;
            yield modem.processCommand(cmd);
            
            return cmd.modify_id;
        }
        
        public async void delete_phonebook(PhonebookBookType book_type, uint position) throws DBus.Error, Msmcomm.Error
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
        
        public async void get_all_pin_status_info() throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();
            
            var cmd = new GetAllPinStatusInfoCommand();
            yield modem.processCommand(cmd);
        }

        public async void read_template(TemplateType tt) throws DBus.Error, Msmcomm.Error
        {
            checkModemActivity();

            var cmd = new ReadTemplateCommand();
            cmd.template_type = tt;
            yield modem.processCommand(cmd);
        }
    }
} // namespace Msmcomm

