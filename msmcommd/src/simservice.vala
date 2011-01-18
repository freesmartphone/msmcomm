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
    public class SimService : BaseService, Msmcomm.Sim
    {
        public SimService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            switch (message.message_type)
            {
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INSERTED:
                    sim_inserted();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_REMOVED:
                    sim_removed();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_DRIVER_ERROR:
                    driver_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERROR:
                    card_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING:
                    memory_warning();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_NO_SIM:
                    no_sim();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED:
                    sim_init_completed();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED:
                    pin1_verified();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED:
                    pin1_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED:
                    pin1_disabled();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED:
                    pin1_perm_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED:
                    pin1_enabled();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED:
                    pin2_enabled();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED:
                    pin2_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED:
                    pin2_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED:
                    pin2_disabled();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED:
                    pin2_perm_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_NO_EVENT:
                    no_event();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL:
                    ok_for_terminal_profile_dl();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL:
                    not_ok_for_terminal_profile_dl();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET:
                    refresh_sim_reset();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT:
                    refresh_sim_init();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_FDN_ENABLE:
                    fdn_enable();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_FDN_DISABLE:
                    fdn_disable();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INSERTED_2:
                    sim_inserted_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_REMOVED_2:
                    sim_removed_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERROR_2:
                    card_error_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING_2:
                    memory_warning_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_NO_SIM_EVENT_2:
                    no_sim_event_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_2:
                    sim_init_completed_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_NO_PROV_2:
                    sim_init_completed_no_prov_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED_2:
                    pin1_verified_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_BLOCKED_2:
                    pin1_blocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED_2:
                    pin1_unblocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED_2:
                    pin1_enabled_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED_2:
                    pin1_disabled_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_CHANGED_2:
                    pin1_changed_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED_2:
                    pin1_perm_blocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_VERIFIED_2:
                    pin2_verified_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED_2:
                    pin2_blocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED_2:
                    pin2_unblocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED_2:
                    pin2_enabled_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED_2:
                    pin2_disabled_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_CHANGED_2:
                    pin2_changed_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED_2:
                    pin2_perm_blocked_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET_2:
                    refresh_sim_reset_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_2:
                    refresh_sim_init_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_FDN_ENABLE_2:
                    fdn_enable_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_FDN_DISABLE_2:
                    fdn_disable_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL_2:
                    ok_for_terminal_profile_dl_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL_2:
                    not_ok_for_terminal_profile_dl_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN:
                    refresh_sim_init_fcn();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN_2:
                    refresh_sim_init_fcn_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FCN:
                    refresh_fcn();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FCN_2:
                    refresh_fcn_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FAILED:
                    refresh_failed();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_START_SWITCH_SLOT:
                    start_switch_slot();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_FINISH_SWITCH_SLOT:
                    finish_switch_slot();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_INIT_COMPLETED:
                    perso_init_completed();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP1:
                    perso_event_gen_prop1();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL:
                    sim_illegal();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL_2:
                    sim_illegal_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V2_COMPLETE:
                    sim_uhzi_v2_complete();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V1_COMPLETE:
                    sim_uhzi_v1_complete();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP2:
                    perso_event_gen_prop2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_INTERNAL_SIM_RESET:
                    internal_sim_reset();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR:
                    card_err_poll_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE:
                    card_err_no_atr_received_with_max_voltage();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET:
                    card_err_no_atr_received_after_int_reset();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES:
                    card_err_corrupt_atr_rcvd_max_times();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES:
                    card_err_pps_timed_out_max_times();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH:
                    card_err_voltage_mismatch();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS:
                    card_err_int_cmd_timed_out_after_pps();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS:
                    card_err_int_cmd_err_exceed_max_attempts();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR:
                    card_err_maxed_parity_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR:
                    card_err_maxed_rx_break_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR:
                    card_err_maxed_overrun_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED:
                    card_err_transaction_timer_expired();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION:
                    card_err_power_down_cmd_notification();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE:
                    card_err_int_cmd_err_in_passive_mode();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE:
                    card_err_cmd_timed_out_in_passive_mode();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE:
                    card_err_max_parity_in_passive();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE:
                    card_err_max_rxbrk_in_passive();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE:
                    card_err_max_overrun_in_passive();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR_2:
                    card_err_poll_error_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE_2:
                    card_err_no_atr_received_with_max_voltage_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET_2:
                    card_err_no_atr_received_after_int_reset_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES_2:
                    card_err_corrupt_atr_rcvd_max_times_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES_2:
                    card_err_pps_timed_out_max_times_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH_2:
                    card_err_voltage_mismatch_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS_2:
                    card_err_int_cmd_timed_out_after_pps_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS_2:
                    card_err_int_cmd_err_exceed_max_attempts_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR_2:
                    card_err_maxed_parity_error_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR_2:
                    card_err_maxed_rx_break_error_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR_2:
                    card_err_maxed_overrun_error_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED_2:
                    card_err_transaction_timer_expired_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION_2:
                    card_err_power_down_cmd_notification_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE_2:
                    card_err_int_cmd_err_in_passive_mode_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE_2:
                    card_err_cmd_timed_out_in_passive_mode_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE_2:
                    card_err_max_parity_in_passive_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE_2:
                    card_err_max_rxbrk_in_passive_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE_2:
                    card_err_max_overrun_in_passive_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET:
                    refresh_app_reset();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET:
                    refresh_3g_session_reset();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET_2:
                    refresh_app_reset_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET_2:
                    refresh_3g_session_reset_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_APP_SELECTED:
                    app_selected();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_APP_SELECTED_2:
                    app_selected_2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NW_FAILURE:
                    perso_nw_failure();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NS_FAILURE:
                    perso_ns_failure();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SP_FAILURE:
                    perso_sp_failure();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CP_FAILURE:
                    perso_cp_failure();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SIM_FAILURE:
                    perso_sim_failure();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NW_DEACTIVATED:
                    perso_nw_deactivated();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NS_DEACTIVATED:
                    perso_ns_deactivated();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SP_DEACTIVATED:
                    perso_sp_deactivated();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CP_DEACTIVATED:
                    perso_cp_deactivated();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SIM_DEACTIVATED:
                    perso_sim_deactivated();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NCK_BLOCKED:
                    perso_nck_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NSK_BLOCKED:
                    perso_nsk_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SPK_BLOCKED:
                    perso_spk_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CCK_BLOCKED:
                    perso_cck_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_PPK_BLOCKED:
                    perso_ppk_blocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NCK_UNBLOCKED:
                    perso_nck_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NSK_UNBLOCKED:
                    perso_nsk_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SPK_UNBLOCKED:
                    perso_spk_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CCK_UNBLOCKED:
                    perso_cck_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_PPK_UNBLOCKED:
                    perso_ppk_unblocked();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SANITY_ERROR:
                    perso_sanity_error();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP1:
                    perso_gen_prop1();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP2:
                    perso_gen_prop2();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVT_INIT_COMPLETED:
                    perso_evt_init_completed();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_ENABLE:
                    plmn_sel_menu_enable();
                    return true;
                case MessageType.UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_DISABLE:
                    plmn_sel_menu_disable();
                    return true;
            }
            return false;
        }

        protected override string repr()
        {
            return "";
        }

        public async void verify_pin(SimPinType pin_type, string pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimVerfiyPinCommandMessage();
            message.pin_type = convertSimPinTypeForModem(pin_type);
            message.pin = pin;

            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }

        public async void change_pin(string old_pin, string new_pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimChangePinCommandMessage();
            message.old_pin = old_pin;
            message.new_pin = new_pin;

            var response = (yield channel.enqueueAsync(message)) as SimCallbackResponseMessage;
            checkResponse(response);
        }

        public async void enable_pin(string pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimEnablePinCommandMessage();
            message.pin = pin;

            var response = (yield channel.enqueueAsync(message)) as SimCallbackResponseMessage;
            checkResponse(response);

        }

        public async void disable_pin(string pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimDisablePinCommandMessage();
            message.pin = pin;

            var response = (yield channel.enqueueAsync(message)) as SimCallbackResponseMessage;
            checkResponse(response);
        }

        public async SimCapabilitiesInfo get_sim_capabilities(SimField field_type) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimGetSimCapabilitiesCommandMessage();
            message.field_type = convertSimFieldForModem(field_type);

            var response = (yield channel.enqueueAsync(message)) as SimCallbackResponseMessage;
            checkResponse(response);

            return SimCapabilitiesInfo();
        }

        public async void get_all_pin_status_info() throws GLib.Error, Msmcomm.Error
        {
            var message = new SimGetAllPinStatusInfoCommandMessage();

            var response = (yield channel.enqueueAsync(message)) as SimCallbackResponseMessage;
            checkResponse(response);

        }
    }
}
