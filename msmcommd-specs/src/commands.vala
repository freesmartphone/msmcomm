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
    [DBus (timeout = 120000, name = "org.msmcomm.Commands")]
    public interface Commands : GLib.Object
    {
        public abstract async void test_alive() throws GLib.Error, Msmcomm.Error;
        public abstract async void change_operation_mode(ModemOperationMode mode) throws GLib.Error, Msmcomm.Error;
        public abstract async PhoneStateInfo get_phone_state_info() throws GLib.Error, Msmcomm.Error;
        public abstract async void reset_modem() throws GLib.Error, Msmcomm.Error;
        public abstract async FirmwareInfo get_firmware_info() throws GLib.Error, Msmcomm.Error;
        public abstract async string get_imei() throws GLib.Error, Msmcomm.Error;
       
        public abstract async void charging(ChargerStatusMode mode, ChargerStatusVoltage voltage) throws GLib.Error, Msmcomm.Error;
        public abstract async ChargerStatus get_charger_status() throws GLib.Error, Msmcomm.Error;
        
        public abstract async void verify_pin(string pin_type, string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void change_pin(string old_pin, string new_pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void enable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void disable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        
        public abstract async void end_call(int call_id) throws GLib.Error, Msmcomm.Error;
        public abstract async void answer_call(int call_id) throws GLib.Error, Msmcomm.Error;
        public abstract async void originate_call(string number, bool block) throws GLib.Error, Msmcomm.Error;
        public abstract async void execute_call_sups_command(CallCommandType command_type, int call_id) throws GLib.Error, Msmcomm.Error;
        
        public abstract async void set_system_time(int year, int month, int day, int hours, int minutes, int seconds, int timezone_offset) throws GLib.Error, Msmcomm.Error;
        public abstract async void rssi_status(bool status) throws GLib.Error, Msmcomm.Error;
        
        public abstract async PhonebookProperties get_phonebook_properties(PhonebookBookType book_type) throws GLib.Error, Msmcomm.Error;
        public abstract async PhonebookEntry read_phonebook(PhonebookBookType book_type, uint position) throws GLib.Error, Msmcomm.Error;
        public abstract async uint write_phonebook(PhonebookBookType book_type, string number, string title) throws GLib.Error, Msmcomm.Error;
        public abstract async void delete_phonebook(PhonebookBookType book_type, uint position) throws GLib.Error, Msmcomm.Error;
        
        public abstract async void get_network_list() throws GLib.Error, Msmcomm.Error;
        public abstract async void set_mode_preference(string mode) throws GLib.Error, Msmcomm.Error;
        public abstract async string sim_info(string field_type) throws GLib.Error, Msmcomm.Error;
        public abstract async uint[] get_audio_modem_tuning_params() throws GLib.Error, Msmcomm.Error;
        public abstract async void set_audio_profile(uint class, uint sub_class) throws GLib.Error, Msmcomm.Error;
        
        public abstract async void get_all_pin_status_info() throws GLib.Error, Msmcomm.Error;
        public abstract async void read_template(TemplateType template_type) throws GLib.Error, Msmcomm.Error;
    }
}
