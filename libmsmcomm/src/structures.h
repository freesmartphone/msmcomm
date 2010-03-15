/* 
 * (c) 2010 by Simon Busch <morphis@gravedo.de>
 * All Rights Reserved
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */
#ifndef STRUCTURES_H_
#define STRUCTURES_H_

/* All structures in this file are autogenerated by generate_structs.py */

struct call_status_event
{
	uint8_t call_id;
	uint8_t call_type;
	uint8_t unknown0;
	uint8_t caller_id[15];
	uint8_t unknown1[45];
	uint8_t caller_id_len;
	uint8_t unknown2[526];
	uint8_t cause_value0;
	uint8_t unknown3[4];
	uint8_t cause_value1;
	uint8_t unknown4[28];
	uint8_t cause_value2;
	uint8_t reject_type;
	uint8_t reject_value;
	uint8_t unknown5[306];
	uint8_t is_tty;
	uint8_t unknown6[173];
} __attribute__ ((packed));


struct cm_call_resp
{
	uint32_t ref_id;
	uint16_t cmd_type;
	uint8_t unknown0[2];
	uint16_t error_code;
} __attribute__ ((packed));


struct answer_call_msg
{
	uint32_t ref_id;
	uint8_t host_id;
	uint8_t call_nr;
	uint8_t unknown0[2];
} __attribute__ ((packed));


struct end_call_msg
{
	uint32_t ref_id;
	uint8_t host_id;
	uint8_t call_nr;
	uint8_t unknown0[55];
} __attribute__ ((packed));


struct dial_call_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t const_value;
	uint8_t unknown1[99];
	uint8_t caller_id[64];
	uint8_t caller_id_len;
	uint8_t unknown2[2];
	uint8_t some_value_0;
	uint8_t unknown3[31];
	uint8_t some_value_1;
	uint8_t unknown4;
} __attribute__ ((packed));


struct cm_sups_event
{
} __attribute__ ((packed));


struct sups_resp
{
} __attribute__ ((packed));


struct get_sim_capabilities_resp
{
	uint8_t unknown0[1934];
} __attribute__ ((packed));


struct verify_pin_msg
{
	uint8_t pin_type;
	uint8_t unknown0[4];
	uint8_t pin[8];
	uint8_t unknown1;
} __attribute__ ((packed));


struct network_state_info_event
{
	uint8_t change_field[8];
	uint8_t new_value;
	uint8_t servce_domain;
	uint8_t service_capability;
	uint8_t gprs_attached;
	uint16_t roam;
	uint8_t unknown0;
	uint8_t plmn[3];
	uint8_t unknown1[3];
	uint8_t operator_name_len;
	uint8_t operator_name[80];
	uint8_t unknown2[3];
	uint8_t hplmn_or_spdi;
	uint8_t hplmn_length;
	uint8_t unknown3[16];
	uint16_t rssi;
	uint16_t ecio;
	uint8_t unknown4[546];
	uint8_t modem_gsm_icon_ind;
	uint8_t unknown5[3];
} __attribute__ ((packed));


struct cm_ph_info_available_event
{
} __attribute__ ((packed));


struct charger_status_event
{
	uint8_t unknown0[5];
	uint16_t voltage;
	uint8_t unknown1[6];
} __attribute__ ((packed));


struct radio_reset_ind_event
{
} __attribute__ ((packed));


struct operator_mode_event
{
} __attribute__ ((packed));


struct power_state_event
{
	uint8_t unknown0[4];
	uint8_t power_state;
	uint8_t unknown1[7];
} __attribute__ ((packed));


struct test_alive_event
{
} __attribute__ ((packed));


struct get_firmware_info_resp
{
	uint32_t ref_id;
	uint8_t hci_version;
	uint8_t unknown0[3];
	uint8_t firmware_version[13];
	uint8_t unknown1[122];
} __attribute__ ((packed));


struct get_imei_resp
{
	uint32_t ref_id;
	uint8_t imei[17];
} __attribute__ ((packed));


struct get_imei_msg
{
	uint8_t unknown0[4];
} __attribute__ ((packed));


struct change_operation_mode_msg
{
	uint32_t ref_id;
	uint8_t operation_mode;
} __attribute__ ((packed));


struct test_alive_msg
{
	uint8_t some_value0;
	uint8_t unknown0[3];
	uint8_t some_value1;
} __attribute__ ((packed));


struct get_firmware_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));


struct get_phone_state_info_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));


struct set_audio_profile_msg
{
	uint32_t ref_id;
	uint8_t unknown0[6];
} __attribute__ ((packed));


struct charger_status_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint16_t voltage;
	uint8_t unknown1;
	uint8_t mode;
	uint8_t unknown2[3];
	uint8_t rc;
} __attribute__ ((packed));


struct charging_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t mode;
	uint16_t voltage;
	uint8_t rc;
} __attribute__ ((packed));


struct test_alive_resp
{
} __attribute__ ((packed));


struct sound_resp
{
	uint8_t unknown0[11];
} __attribute__ ((packed));


struct pdsm_pd_done_event
{
} __attribute__ ((packed));


struct pd_position_data_event
{
} __attribute__ ((packed));


struct pd_parameter_change_event
{
} __attribute__ ((packed));


struct pdsm_lcs_event
{
} __attribute__ ((packed));


struct pdsm_xtra_event
{
} __attribute__ ((packed));


struct pdsm_pd_get_pos_resp
{
} __attribute__ ((packed));


struct pdsm_pd_end_session_resp
{
} __attribute__ ((packed));


struct pa_set_param_resp
{
} __attribute__ ((packed));


struct lcs_agent_client_rsp_resp
{
} __attribute__ ((packed));


struct xtra_set_data_resp
{
} __attribute__ ((packed));


struct get_location_priv_pref_msg
{
	uint8_t unknown0[12];
} __attribute__ ((packed));

#endif

