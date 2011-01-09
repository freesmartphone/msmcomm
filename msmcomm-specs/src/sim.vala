/**
 * This file is part of msmcomm-specs
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
 * GNU General Public License for more infos.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm
{
    [CCode (cprefix = "MSMCOMM_SIM_PIN_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SimPinType
    {
        PIN1,
        PIN2,
    }

    [CCode (cprefix = "MSMCOMM_SIM_FIELD_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SimField
    {
        IMSI,
        MSISDN,
    }

    [CCode (type_id = "MSMCOMM_SIM_CAPABILITIES_INFO", cheader_filename="msmcomm-specs.h")]
    public struct SimCapabilitiesInfo
    {
        SimField field_type;
        string field_data;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.SIM")]
    public interface Sim : GLib.Object
    {
        public abstract async void verify_pin(SimPinType pin_type, string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void change_pin(string old_pin, string new_pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void enable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async void disable_pin(string pin) throws GLib.Error, Msmcomm.Error;
        public abstract async SimCapabilitiesInfo get_sim_capabilities(SimField field_type) throws GLib.Error, Msmcomm.Error;
        public abstract async void get_all_pin_status_info() throws GLib.Error, Msmcomm.Error;

        public signal void sim_inserted();
        public signal void sim_removed();
        public signal void driver_error();
        public signal void card_error();
        public signal void memory_warning();
        public signal void no_sim_event();
        public signal void no_sim();
        public signal void sim_init_completed();
        public signal void sim_init_completed_no_prov();
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
        public signal void no_event();
        public signal void ok_for_terminal_profile_dl();
        public signal void not_ok_for_terminal_profile_dl();
        public signal void refresh_sim_reset();
        public signal void refresh_sim_init();
        public signal void fdn_enable();
        public signal void fdn_disable();
        public signal void sim_inserted_2();
        public signal void sim_removed_2();
        public signal void card_error_2();
        public signal void memory_warning_2();
        public signal void no_sim_event_2();
        public signal void sim_init_completed_2();
        public signal void sim_init_completed_no_prov_2();
        public signal void pin1_verified_2();
        public signal void pin1_blocked_2();
        public signal void pin1_unblocked_2();
        public signal void pin1_enabled_2();
        public signal void pin1_disabled_2();
        public signal void pin1_changed_2();
        public signal void pin1_perm_blocked_2();
        public signal void pin2_verified_2();
        public signal void pin2_blocked_2();
        public signal void pin2_unblocked_2();
        public signal void pin2_enabled_2();
        public signal void pin2_disabled_2();
        public signal void pin2_changed_2();
        public signal void pin2_perm_blocked_2();
        public signal void refresh_sim_reset_2();
        public signal void refresh_sim_init_2();
        public signal void fdn_enable_2();
        public signal void fdn_disable_2();
        public signal void ok_for_terminal_profile_dl_2();
        public signal void not_ok_for_terminal_profile_dl_2();
        public signal void refresh_sim_init_fcn();
        public signal void refresh_sim_init_fcn_2();
        public signal void refresh_fcn();
        public signal void refresh_fcn_2();
        public signal void refresh_failed();
        public signal void start_switch_slot();
        public signal void finish_switch_slot();
        public signal void perso_init_completed();
        public signal void perso_event_gen_prop1();
        public signal void sim_illegal();
        public signal void sim_illegal_2();
        public signal void sim_uhzi_v2_complete();
        public signal void sim_uhzi_v1_complete();
        public signal void perso_event_gen_prop2();
        public signal void internal_sim_reset();
        public signal void card_err_poll_error();
        public signal void card_err_no_atr_received_with_max_voltage();
        public signal void card_err_no_atr_received_after_int_reset();
        public signal void card_err_corrupt_atr_rcvd_max_times();
        public signal void card_err_pps_timed_out_max_times();
        public signal void card_err_voltage_mismatch();
        public signal void card_err_int_cmd_timed_out_after_pps();
        public signal void card_err_int_cmd_err_exceed_max_attempts();
        public signal void card_err_maxed_parity_error();
        public signal void card_err_maxed_rx_break_error();
        public signal void card_err_maxed_overrun_error();
        public signal void card_err_transaction_timer_expired();
        public signal void card_err_power_down_cmd_notification();
        public signal void card_err_int_cmd_err_in_passive_mode();
        public signal void card_err_cmd_timed_out_in_passive_mode();
        public signal void card_err_max_parity_in_passive();
        public signal void card_err_max_rxbrk_in_passive();
        public signal void card_err_max_overrun_in_passive();
        public signal void card_err_poll_error_2();
        public signal void card_err_no_atr_received_with_max_voltage_2();
        public signal void card_err_no_atr_received_after_int_reset_2();
        public signal void card_err_corrupt_atr_rcvd_max_times_2();
        public signal void card_err_pps_timed_out_max_times_2();
        public signal void card_err_voltage_mismatch_2();
        public signal void card_err_int_cmd_timed_out_after_pps_2();
        public signal void card_err_int_cmd_err_exceed_max_attempts_2();
        public signal void card_err_maxed_parity_error_2();
        public signal void card_err_maxed_rx_break_error_2();
        public signal void card_err_maxed_overrun_error_2();
        public signal void card_err_transaction_timer_expired_2();
        public signal void card_err_power_down_cmd_notification_2();
        public signal void card_err_int_cmd_err_in_passive_mode_2();
        public signal void card_err_cmd_timed_out_in_passive_mode_2();
        public signal void card_err_max_parity_in_passive_2();
        public signal void card_err_max_rxbrk_in_passive_2();
        public signal void card_err_max_overrun_in_passive_2();
        public signal void refresh_app_reset();
        public signal void refresh_3g_session_reset();
        public signal void refresh_app_reset_2();
        public signal void refresh_3g_session_reset_2();
        public signal void app_selected();
        public signal void app_selected_2();
        public signal void perso_nw_failure();
        public signal void perso_ns_failure();
        public signal void perso_sp_failure();
        public signal void perso_cp_failure();
        public signal void perso_sim_failure();
        public signal void perso_nw_deactivated();
        public signal void perso_ns_deactivated();
        public signal void perso_sp_deactivated();
        public signal void perso_cp_deactivated();
        public signal void perso_sim_deactivated();
        public signal void perso_nck_blocked();
        public signal void perso_nsk_blocked();
        public signal void perso_spk_blocked();
        public signal void perso_cck_blocked();
        public signal void perso_ppk_blocked();
        public signal void perso_nck_unblocked();
        public signal void perso_nsk_unblocked();
        public signal void perso_spk_unblocked();
        public signal void perso_cck_unblocked();
        public signal void perso_ppk_unblocked();
        public signal void perso_sanity_error();
        public signal void perso_gen_prop1();
        public signal void perso_gen_prop2();
        public signal void perso_evt_init_completed();
        public signal void plmn_sel_menu_enable();
        public signal void plmn_sel_menu_disable();
    }
}
