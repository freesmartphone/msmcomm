/* 
 * (c) 2010-2011 by Simon Busch <morphis@gravedo.de>
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

#include <stdint.h>

struct plmn_field
{
	uint16_t mcc;
	uint8_t mnc;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_plmn_field_init(struct plmn_field* self)
{
}


struct call_event
{
	uint8_t call_id;
	uint8_t call_type;
	uint8_t unknown0;
#define CALL_EVENT_CALLER_ID_SIZE 15
	uint8_t caller_id[15];
#define CALL_EVENT_UNKNOWN1_SIZE 39
	uint8_t unknown1[39];
	struct plmn_field plmn;
#define CALL_EVENT_UNKNOWN2_SIZE 7
	uint8_t unknown2[7];
	uint8_t caller_id_len;
#define CALL_EVENT_UNKNOWN3_SIZE 522
	uint8_t unknown3[522];
	uint8_t cause_value0;
#define CALL_EVENT_UNKNOWN4_SIZE 4
	uint8_t unknown4[4];
	uint8_t cause_value1;
#define CALL_EVENT_UNKNOWN5_SIZE 28
	uint8_t unknown5[28];
	uint8_t cause_value2;
	uint8_t reject_type;
	uint8_t reject_value;
#define CALL_EVENT_UNKNOWN6_SIZE 306
	uint8_t unknown6[306];
	uint8_t is_tty;
#define CALL_EVENT_UNKNOWN7_SIZE 173
	uint8_t unknown7[173];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_event_init(struct call_event* self)
{
	self->caller_id_len = 15;
}


struct call_callback_resp
{
	uint32_t ref_id;
	uint16_t cmd_type;
	uint8_t unknown0;
	uint8_t result;
#define CALL_CALLBACK_RESP_UNKNOWN1_SIZE 2
	uint8_t unknown1[2];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_callback_resp_init(struct call_callback_resp* self)
{
}


struct call_answer_msg
{
	uint32_t ref_id;
	uint8_t call_id;
	uint8_t value0;
	uint8_t value1;
	uint8_t value2;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_answer_msg_init(struct call_answer_msg* self)
{
}


struct call_end_msg
{
	uint32_t ref_id;
	uint8_t value0;
	uint8_t call_id;
#define CALL_END_MSG_UNKNOWN0_SIZE 55
	uint8_t unknown0[55];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_end_msg_init(struct call_end_msg* self)
{
}


struct call_origination_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t value0;
#define CALL_ORIGINATION_MSG_UNKNOWN1_SIZE 99
	uint8_t unknown1[99];
#define CALL_ORIGINATION_MSG_CALLER_ID_SIZE 64
	uint8_t caller_id[64];
	uint8_t caller_id_len;
#define CALL_ORIGINATION_MSG_UNKNOWN2_SIZE 2
	uint8_t unknown2[2];
	uint8_t value1;
#define CALL_ORIGINATION_MSG_UNKNOWN3_SIZE 31
	uint8_t unknown3[31];
	uint8_t block;
	uint8_t unknown4;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_origination_msg_init(struct call_origination_msg* self)
{
	self->caller_id_len = 64;
}


struct call_sups_msg
{
	uint32_t ref_id;
	uint8_t command;
	uint8_t call_id;
#define CALL_SUPS_MSG_UNKNOWN0_SIZE 79
	uint8_t unknown0[79];
	uint8_t value0;
#define CALL_SUPS_MSG_UNKNOWN1_SIZE 20
	uint8_t unknown1[20];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_call_sups_msg_init(struct call_sups_msg* self)
{
}


struct misc_test_alive_msg
{
	uint32_t ref_id;
	uint8_t some_value1;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_test_alive_msg_init(struct misc_test_alive_msg* self)
{
}


struct misc_get_imei_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_imei_msg_init(struct misc_get_imei_msg* self)
{
}


struct misc_get_imei_resp
{
	uint32_t ref_id;
#define MISC_GET_IMEI_RESP_IMEI_SIZE 17
	uint8_t imei[17];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_imei_resp_init(struct misc_get_imei_resp* self)
{
}


struct misc_get_radio_firmware_version_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_radio_firmware_version_msg_init(struct misc_get_radio_firmware_version_msg* self)
{
}


struct misc_get_radio_firmware_version_resp
{
	uint32_t ref_id;
	uint8_t carrier_id;
#define MISC_GET_RADIO_FIRMWARE_VERSION_RESP_UNKNOWN0_SIZE 3
	uint8_t unknown0[3];
#define MISC_GET_RADIO_FIRMWARE_VERSION_RESP_FIRMWARE_VERSION_SIZE 13
	uint8_t firmware_version[13];
#define MISC_GET_RADIO_FIRMWARE_VERSION_RESP_UNKNOWN1_SIZE 122
	uint8_t unknown1[122];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_radio_firmware_version_resp_init(struct misc_get_radio_firmware_version_resp* self)
{
}


struct misc_get_charger_status_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint16_t voltage;
	uint8_t unknown1;
	uint8_t mode;
#define MISC_GET_CHARGER_STATUS_MSG_UNKNOWN2_SIZE 3
	uint8_t unknown2[3];
	uint8_t rc;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_charger_status_msg_init(struct misc_get_charger_status_msg* self)
{
}


struct misc_set_charge_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t mode;
	uint16_t voltage;
	uint8_t rc;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_set_charge_msg_init(struct misc_set_charge_msg* self)
{
}


struct misc_set_date_msg
{
	uint32_t ref_id;
	uint16_t year;
	uint16_t month;
	uint16_t day;
	uint16_t hour;
	uint16_t minutes;
	uint16_t seconds;
#define MISC_SET_DATE_MSG_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
	int32_t timezone_offset;
	uint8_t value0;
	uint8_t unknown1;
	uint8_t time_source;
	uint8_t unknown2;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_set_date_msg_init(struct misc_set_date_msg* self)
{
}


struct misc_set_date_resp
{
	uint32_t ref_id;
	uint8_t rc;
	uint8_t unknown0;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_set_date_resp_init(struct misc_set_date_resp* self)
{
}


struct misc_get_home_network_name_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_home_network_name_msg_init(struct misc_get_home_network_name_msg* self)
{
}


struct misc_get_home_network_name_resp
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t rc;
#define MISC_GET_HOME_NETWORK_NAME_RESP_UNKNOWN1_SIZE 84
	uint8_t unknown1[84];
	uint8_t operator_name_len;
#define MISC_GET_HOME_NETWORK_NAME_RESP_OPERATOR_NAME_SIZE 16
	uint8_t operator_name[16];
	uint16_t mcc;
	uint8_t mnc;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_get_home_network_name_resp_init(struct misc_get_home_network_name_resp* self)
{
	self->operator_name_len = 16;
}


struct misc_charger_status_event
{
#define MISC_CHARGER_STATUS_EVENT_UNKNOWN0_SIZE 5
	uint8_t unknown0[5];
	uint16_t voltage;
#define MISC_CHARGER_STATUS_EVENT_UNKNOWN1_SIZE 6
	uint8_t unknown1[6];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_charger_status_event_init(struct misc_charger_status_event* self)
{
}


struct misc_radio_reset_ind_event
{
#define MISC_RADIO_RESET_IND_EVENT_UNKNOWN0_SIZE 76
	uint8_t unknown0[76];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_misc_radio_reset_ind_event_init(struct misc_radio_reset_ind_event* self)
{
}


struct state_change_operation_mode_msg
{
	uint32_t ref_id;
	uint8_t mode;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_state_change_operation_mode_msg_init(struct state_change_operation_mode_msg* self)
{
}


struct state_sys_sel_pref_msg
{
	uint32_t ref_id;
	uint8_t mode;
#define STATE_SYS_SEL_PREF_MSG_UNKNOWN0_SIZE 5
	uint8_t unknown0[5];
	uint8_t value0;
#define STATE_SYS_SEL_PREF_MSG_UNKNOWN1_SIZE 3
	uint8_t unknown1[3];
	uint8_t value1;
#define STATE_SYS_SEL_PREF_MSG_UNKNOWN2_SIZE 5
	uint8_t unknown2[5];
	uint8_t value2;
	uint8_t unknown3;
	uint8_t value3;
	uint8_t value4;
	uint8_t value5;
#define STATE_SYS_SEL_PREF_MSG_UNKNOWN4_SIZE 4
	uint8_t unknown4[4];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_state_sys_sel_pref_msg_init(struct state_sys_sel_pref_msg* self)
{
}


struct state_callback_resp
{
	uint32_t ref_id;
#define STATE_CALLBACK_RESP_UNKNOWN0_SIZE 7
	uint8_t unknown0[7];
	uint8_t result;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_state_callback_resp_init(struct state_callback_resp* self)
{
}


struct network_info_field
{
	struct plmn_field plmn;
	uint8_t unknown0;
	uint8_t radio_type;
#define NETWORK_INFO_FIELD_UNKNOWN1_SIZE 7
	uint8_t unknown1[7];
	uint8_t name_len;
#define NETWORK_INFO_FIELD_NAME_SIZE 82
	uint8_t name[82];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_network_info_field_init(struct network_info_field* self)
{
	self->name_len = 82;
}


struct state_event
{
	uint8_t unknown0;
	uint8_t mode;
#define STATE_EVENT_UNKNOWN1_SIZE 5
	uint8_t unknown1[5];
	uint8_t service_mode_preference;
#define STATE_EVENT_UNKNOWN2_SIZE 9
	uint8_t unknown2[9];
	uint8_t network_mode_preference;
	struct plmn_field current_plmn;
#define STATE_EVENT_UNKNOWN3_SIZE 251
	uint8_t unknown3[251];
	uint8_t network_count;
#define STATE_EVENT_UNKNOWN4_SIZE 3
	uint8_t unknown4[3];
#define STATE_EVENT_NETWORKS_SIZE 10
	struct network_info_field networks[10];
#define STATE_EVENT_UNKNOWN5_SIZE 2853
	uint8_t unknown5[2853];
	uint8_t als_allowed;
	uint8_t line;
#define STATE_EVENT_UNKNOWN6_SIZE 17
	uint8_t unknown6[17];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_state_event_init(struct state_event* self)
{
}


struct wms_read_template_field
{
#define WMS_READ_TEMPLATE_FIELD_UNKNOWN0_SIZE 172
	uint8_t unknown0[172];
	uint8_t received_mask;
#define WMS_READ_TEMPLATE_FIELD_UNKNOWN1_SIZE 44
	uint8_t unknown1[44];
	uint8_t digit_mode;
	uint32_t number_mode;
	uint8_t number_type;
	uint8_t numbering_plan;
	uint8_t smsc_number_len;
#define WMS_READ_TEMPLATE_FIELD_SMSC_NUMBER_SIZE 21
	uint8_t smsc_number[21];
#define WMS_READ_TEMPLATE_FIELD_UNKNOWN2_SIZE 15
	uint8_t unknown2[15];
	uint8_t protocol_id;
#define WMS_READ_TEMPLATE_FIELD_UNKNOWN3_SIZE 1813
	uint8_t unknown3[1813];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_read_template_field_init(struct wms_read_template_field* self)
{
	self->smsc_number_len = 21;
}


struct wms_sms_received_field
{
#define WMS_SMS_RECEIVED_FIELD_UNKNOWN0_SIZE 15
	uint8_t unknown0[15];
	uint8_t sender_len;
#define WMS_SMS_RECEIVED_FIELD_SENDER_SIZE 36
	uint8_t sender[36];
#define WMS_SMS_RECEIVED_FIELD_UNKNOWN1_SIZE 2
	uint8_t unknown1[2];
	uint32_t pdu_len;
#define WMS_SMS_RECEIVED_FIELD_PDU_SIZE 2017
	uint8_t pdu[2017];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_sms_received_field_init(struct wms_sms_received_field* self)
{
	self->sender_len = 36;
	self->pdu_len = 2017;
}


struct wms_msg_group_event
{
	uint8_t response_type;
#define WMS_MSG_GROUP_EVENT_UNKNOWN0_SIZE 3
	uint8_t unknown0[3];
	uint32_t ref_id;
#define WMS_MSG_GROUP_EVENT_COMMAND_DATA_SIZE 2075
	uint8_t command_data[2075];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_msg_group_event_init(struct wms_msg_group_event* self)
{
}


struct wms_cfg_group_event
{
	uint8_t response_type;
#define WMS_CFG_GROUP_EVENT_UNKNOWN0_SIZE 1542
	uint8_t unknown0[1542];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_cfg_group_event_init(struct wms_cfg_group_event* self)
{
}


struct wms_acknowledge_msg
{
	uint32_t ref_id;
#define WMS_ACKNOWLEDGE_MSG_UNKNOWN0_SIZE 1897
	uint8_t unknown0[1897];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_acknowledge_msg_init(struct wms_acknowledge_msg* self)
{
}


struct wms_send_msg
{
	uint32_t ref_id;
#define WMS_SEND_MSG_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
	uint8_t nr;
	uint8_t five;
	uint8_t unknown1;
	uint32_t ffffffff;
#define WMS_SEND_MSG_UNKNOWN2_SIZE 6
	uint8_t unknown2[6];
	uint8_t number_type;
	uint8_t number_plan;
	uint8_t service_center_len;
#define WMS_SEND_MSG_SERVICE_CENTER_SIZE 36
	uint8_t service_center[36];
	uint16_t six_three;
	uint32_t pdu_len;
#define WMS_SEND_MSG_PDU_SIZE 255
	uint8_t pdu[255];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_send_msg_init(struct wms_send_msg* self)
{
	self->service_center_len = 36;
	self->pdu_len = 255;
}


struct sms_get_info_msg
{
	uint32_t ref_id;
#define SMS_GET_INFO_MSG_UNKNOWN0_SIZE 5
	uint8_t unknown0[5];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sms_get_info_msg_init(struct sms_get_info_msg* self)
{
}


struct wms_read_template_msg
{
	uint32_t ref_id;
	uint16_t template;
#define WMS_READ_TEMPLATE_MSG_UNKNOWN0_SIZE 3
	uint8_t unknown0[3];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_read_template_msg_init(struct wms_read_template_msg* self)
{
}


struct wms_cfg_set_gw_domain_pref_msg
{
	uint32_t ref_id;
	uint8_t mode;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_cfg_set_gw_domain_pref_msg_init(struct wms_cfg_set_gw_domain_pref_msg* self)
{
}


struct wms_cfg_set_routes_msg
{
	uint32_t ref_id;
#define WMS_CFG_SET_ROUTES_MSG_UNKNOWN_BYTES_SIZE 25
	uint8_t unknown_bytes[25];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_cfg_set_routes_msg_init(struct wms_cfg_set_routes_msg* self)
{
}


struct wms_cfg_get_message_list_msg
{
	uint32_t ref_id;
	uint8_t value0;
#define WMS_CFG_GET_MESSAGE_LIST_MSG_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_cfg_get_message_list_msg_init(struct wms_cfg_get_message_list_msg* self)
{
}


struct wms_read_msg
{
	uint32_t ref_id;
#define WMS_READ_MSG_UNKNOWN0_SIZE 5
	uint8_t unknown0[5];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_read_msg_init(struct wms_read_msg* self)
{
}


struct wms_delete_msg
{
	uint32_t ref_id;
#define WMS_DELETE_MSG_UNKNOWN0_SIZE 5
	uint8_t unknown0[5];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_delete_msg_init(struct wms_delete_msg* self)
{
}


struct wms_get_memory_status_msg
{
	uint32_t ref_id;
	uint8_t value0;
#define WMS_GET_MEMORY_STATUS_MSG_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_get_memory_status_msg_init(struct wms_get_memory_status_msg* self)
{
}


struct wms_return_resp
{
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_return_resp_init(struct wms_return_resp* self)
{
}


struct wms_callback_resp
{
	uint16_t command;
#define WMS_CALLBACK_RESP_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
	uint32_t ref_id;
	uint8_t rc;
	uint8_t unknown1;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_wms_callback_resp_init(struct wms_callback_resp* self)
{
}


struct sim_pin_status_msg
{
	uint32_t ref_id;
	uint8_t pin_type;
#define SIM_PIN_STATUS_MSG_PIN_SIZE 8
	uint8_t pin[8];
	uint8_t unknown0;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_pin_status_msg_init(struct sim_pin_status_msg* self)
{
}


struct sim_get_call_forward_info_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_get_call_forward_info_msg_init(struct sim_get_call_forward_info_msg* self)
{
}


struct sim_return_resp
{
	uint32_t ref_id;
	uint16_t command;
	uint16_t rc;
#define SIM_RETURN_RESP_UNKNOWN0_SIZE 260
	uint8_t unknown0[260];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_return_resp_init(struct sim_return_resp* self)
{
}


struct sim_read_resp
{
	uint16_t file_type;
	uint8_t result;
	uint8_t unknown0;
	uint8_t file_data_len;
#define SIM_READ_RESP_FILE_DATA_SIZE 8
	uint8_t file_data[8];
#define SIM_READ_RESP_UNKNOWN1_SIZE 1911
	uint8_t unknown1[1911];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_read_resp_init(struct sim_read_resp* self)
{
	self->file_data_len = 8;
}


struct sim_verify_pin_resp
{
	uint8_t unknown0;
	uint8_t pin_retries;
	uint8_t sw1;
	uint8_t sw2;
#define SIM_VERIFY_PIN_RESP_UNKNOWN1_SIZE 1920
	uint8_t unknown1[1920];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_verify_pin_resp_init(struct sim_verify_pin_resp* self)
{
}


struct sim_pin_status_resp
{
	uint8_t pin_count;
#define SIM_PIN_STATUS_RESP_UNKNOWN0_SIZE 1923
	uint8_t unknown0[1923];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_pin_status_resp_init(struct sim_pin_status_resp* self)
{
}


struct sim_get_fdn_status_resp
{
#define SIM_GET_FDN_STATUS_RESP_UNKNOWN0_SIZE 7
	uint8_t unknown0[7];
	uint8_t usim;
#define SIM_GET_FDN_STATUS_RESP_UNKNOWN1_SIZE 1916
	uint8_t unknown1[1916];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_get_fdn_status_resp_init(struct sim_get_fdn_status_resp* self)
{
}


struct sim_callback_resp
{
#define SIM_CALLBACK_RESP_UNKNOWN0_SIZE 4
	uint8_t unknown0[4];
	uint8_t rc;
	uint32_t ref_id;
	uint8_t response_type;
#define SIM_CALLBACK_RESP_RESPONSE_DATA_SIZE 1924
	uint8_t response_data[1924];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_callback_resp_init(struct sim_callback_resp* self)
{
}


struct sim_change_pin_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
#define SIM_CHANGE_PIN_MSG_OLD_PIN_SIZE 9
	uint8_t old_pin[9];
#define SIM_CHANGE_PIN_MSG_NEW_PIN_SIZE 9
	uint8_t new_pin[9];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_change_pin_msg_init(struct sim_change_pin_msg* self)
{
}


struct sim_get_sim_capabilities_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_get_sim_capabilities_msg_init(struct sim_get_sim_capabilities_msg* self)
{
}


struct sim_read_msg
{
	uint32_t ref_id;
	uint16_t field_type;
#define SIM_READ_MSG_UNKNOWN0_SIZE 35
	uint8_t unknown0[35];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_read_msg_init(struct sim_read_msg* self)
{
}


struct sim_get_all_pin_status_info_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sim_get_all_pin_status_info_msg_init(struct sim_get_all_pin_status_info_msg* self)
{
}


struct phonebook_read_record_msg
{
	uint32_t ref_id;
	uint8_t position;
	uint8_t book_type;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_read_record_msg_init(struct phonebook_read_record_msg* self)
{
}


struct phonebook_read_record_bulk_msg
{
	uint32_t ref_id;
	uint8_t first_position;
	uint8_t first_book_type;
	uint8_t last_position;
	uint8_t last_book_type;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_read_record_bulk_msg_init(struct phonebook_read_record_bulk_msg* self)
{
}


struct phonebook_write_record_msg
{
	uint32_t ref_id;
	uint8_t position;
	uint8_t book_type;
#define PHONEBOOK_WRITE_RECORD_MSG_NUMBER_SIZE 41
	uint8_t number[41];
	uint8_t unknown0;
#define PHONEBOOK_WRITE_RECORD_MSG_TITLE_SIZE 90
	uint8_t title[90];
	uint8_t value0;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_write_record_msg_init(struct phonebook_write_record_msg* self)
{
}


struct phonebook_extended_file_info_msg
{
	uint32_t ref_id;
	uint8_t book_type;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_extended_file_info_msg_init(struct phonebook_extended_file_info_msg* self)
{
}


struct phonebook_return_resp
{
	uint32_t ref_id;
	uint16_t command_id;
	uint8_t result;
	uint8_t position;
	uint8_t book_type;
#define PHONEBOOK_RETURN_RESP_NUMBER_SIZE 42
	uint8_t number[42];
#define PHONEBOOK_RETURN_RESP_TITLE_SIZE 90
	uint8_t title[90];
	uint8_t encoding_type;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_return_resp_init(struct phonebook_return_resp* self)
{
}


struct phonebook_event
{
	uint8_t position;
	uint8_t unknown0;
	uint8_t book_type;
#define PHONEBOOK_EVENT_UNKNOWN1_SIZE 200
	uint8_t unknown1[200];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_event_init(struct phonebook_event* self)
{
}


struct phonebook_extended_file_info_event
{
	uint8_t result;
	uint8_t book_type;
	uint32_t slots_used;
	uint32_t slot_count;
	uint32_t max_chars_per_title;
	uint32_t max_chars_per_number;
#define PHONEBOOK_EXTENDED_FILE_INFO_EVENT_UNKNOWN0_SIZE 185
	uint8_t unknown0[185];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_phonebook_extended_file_info_event_init(struct phonebook_extended_file_info_event* self)
{
}


struct network_report_rssi_msg
{
	uint32_t ref_id;
	uint8_t mode;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_network_report_rssi_msg_init(struct network_report_rssi_msg* self)
{
}


struct network_report_health_msg
{
	uint32_t ref_id;
	uint8_t mode;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_network_report_health_msg_init(struct network_report_health_msg* self)
{
}


struct network_callback_resp
{
	uint32_t ref_id;
	uint16_t command;
#define NETWORK_CALLBACK_RESP_UNKNOWN0_SIZE 2
	uint8_t unknown0[2];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_network_callback_resp_init(struct network_callback_resp* self)
{
}


struct network_state_info_event
{
#define NETWORK_STATE_INFO_EVENT_CHANGE_FIELD_SIZE 8
	uint8_t change_field[8];
	uint8_t serv_status;
	uint8_t servce_domain;
	uint8_t service_capability;
	uint8_t gprs_attached;
	uint16_t roam;
	uint8_t unknown0;
	struct plmn_field plmn;
#define NETWORK_STATE_INFO_EVENT_UNKNOWN1_SIZE 3
	uint8_t unknown1[3];
	uint8_t operator_name_len;
#define NETWORK_STATE_INFO_EVENT_OPERATOR_NAME_SIZE 80
	uint8_t operator_name[80];
#define NETWORK_STATE_INFO_EVENT_UNKNOWN2_SIZE 3
	uint8_t unknown2[3];
	uint8_t hplmn_or_spdi;
	uint8_t hplmn_length;
#define NETWORK_STATE_INFO_EVENT_UNKNOWN3_SIZE 16
	uint8_t unknown3[16];
	uint16_t rssi;
	uint16_t ecio;
#define NETWORK_STATE_INFO_EVENT_UNKNOWN4_SIZE 4
	uint8_t unknown4[4];
	uint8_t with_nitz_update;
#define NETWORK_STATE_INFO_EVENT_UNKNOWN5_SIZE 522
	uint8_t unknown5[522];
	uint8_t year;
	uint8_t month;
	uint8_t day;
	uint8_t hours;
	uint8_t minutes;
	uint8_t seconds;
	uint16_t timezone_offset;
#define NETWORK_STATE_INFO_EVENT_UNKNOWN6_SIZE 11
	uint8_t unknown6[11];
	uint8_t gsm_icon_ind;
	uint8_t unknown7;
	uint8_t reg_status;
	uint8_t unknown8;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_network_state_info_event_init(struct network_state_info_event* self)
{
	self->operator_name_len = 80;
}


struct sound_set_device_msg
{
	uint32_t ref_id;
	uint8_t class;
	uint8_t unknown0;
	uint8_t sub_class;
#define SOUND_SET_DEVICE_MSG_UNKNOWN1_SIZE 3
	uint8_t unknown1[3];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sound_set_device_msg_init(struct sound_set_device_msg* self)
{
}


struct sound_callback_resp
{
	uint32_t ref_id;
#define SOUND_CALLBACK_RESP_UNKNOWN0_SIZE 7
	uint8_t unknown0[7];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sound_callback_resp_init(struct sound_callback_resp* self)
{
}


struct sups_interrogate_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t feature_code;
#define SUPS_INTERROGATE_MSG_UNKNOWN1_SIZE 4
	uint8_t unknown1[4];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_interrogate_msg_init(struct sups_interrogate_msg* self)
{
}


struct sups_register_msg
{
	uint32_t ref_id;
	uint8_t feature_code;
#define SUPS_REGISTER_MSG_UNKNOWN0_SIZE 4
	uint8_t unknown0[4];
	uint8_t value0;
	uint8_t number_len;
	uint8_t bearer;
#define SUPS_REGISTER_MSG_NUMBER_SIZE 21
	uint8_t number[21];
#define SUPS_REGISTER_MSG_UNKNOWN1_SIZE 45
	uint8_t unknown1[45];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_register_msg_init(struct sups_register_msg* self)
{
	self->number_len = 21;
}


struct sups_erase_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t feature_code;
#define SUPS_ERASE_MSG_UNKNOWN1_SIZE 4
	uint8_t unknown1[4];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_erase_msg_init(struct sups_erase_msg* self)
{
}


struct sups_status_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t feature_code;
#define SUPS_STATUS_MSG_UNKNOWN1_SIZE 9
	uint8_t unknown1[9];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_status_msg_init(struct sups_status_msg* self)
{
}


struct sups_callback_resp
{
	uint32_t ref_id;
	uint8_t command;
	uint8_t unknown0;
	uint8_t result;
	uint8_t unknown1;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_callback_resp_init(struct sups_callback_resp* self)
{
}


struct sups_event
{
#define SUPS_EVENT_UNKNOWN0_SIZE 3
	uint8_t unknown0[3];
	uint8_t feature_code;
#define SUPS_EVENT_UNKNOWN1_SIZE 4
	uint8_t unknown1[4];
	uint8_t value0;
	uint8_t number_len;
	uint8_t bearer;
#define SUPS_EVENT_NUMBER_SIZE 21
	uint8_t number[21];
#define SUPS_EVENT_UNKNOWN2_SIZE 4112
	uint8_t unknown2[4112];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_sups_event_init(struct sups_event* self)
{
	self->number_len = 21;
}


struct voicemail_get_info_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));

static void msmcomm_low_level_structures_voicemail_get_info_msg_init(struct voicemail_get_info_msg* self)
{
}


struct voicemail_return_resp
{
	uint32_t ref_id;
#define VOICEMAIL_RETURN_RESP_UNKNOWN0_SIZE 3
	uint8_t unknown0[3];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_voicemail_return_resp_init(struct voicemail_return_resp* self)
{
}


struct voicemail_event
{
	uint8_t line0_vm_count;
	uint8_t line1_vm_count;
#define VOICEMAIL_EVENT_UNKNOWN0_SIZE 7
	uint8_t unknown0[7];
} __attribute__ ((packed));

static void msmcomm_low_level_structures_voicemail_event_init(struct voicemail_event* self)
{
}

#endif

