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
    [DBus (timeout = 120000, name = "org.msmcomm.Unsolicited")]
    public interface ResponseUnsolicited : GLib.Object
    {
        public signal void power_state(uint state);
        public signal void charger_status(uint voltage);
        public signal void call_incomming(CallInfo info);
        public signal void call_connect(CallInfo info);
        public signal void call_end(CallInfo info);
        public signal void call_origination(CallInfo info);
        public signal void network_list(NetworkProvider[] networks);
        public signal void network_state_info(NetworkStateInfo state_info);
        public signal void phonebook_ready(string book_type);
        public signal void phonebook_modified(string book_type, uint position);
        public signal void cm_ph(string[] plmns);
        
        public signal void reset_radio_ind();
        public signal void operation_mode();
        public signal void cm_ph_info_available();
        
        public signal void sim_inserted();
        public signal void sim_removed();
        public signal void sim_not_available();
        
        public signal void pin1_verified();
        public signal void pin1_blocked();
        public signal void pin1_unblocked();
        public signal void pin1_enabled();
        public signal void pin1_disabled();
        public signal void pin1_changed();
        public signal void pin1_perm_blocked();
        
        public signal void pin2_verified();
        public signal void pin2_blocked();
        public signal void pin2_unblocked();
        public signal void pin2_enabled();
        public signal void pin2_disabled();
        public signal void pin2_changed();
        public signal void pin2_perm_blocked();
        
        public signal void sms_message_recieved(SmsInfo info);
    }
}
