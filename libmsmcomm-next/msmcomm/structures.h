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

#include <stdint.h>

struct call_status_event
{
	uint8_t call_id;
	uint8_t call_type;
	uint8_t unknown0;
	uint8_t caller_id[15];
	uint8_t unknown1[39];
	uint8_t plmn[3];
	uint8_t unknown2[7];
	uint8_t caller_id_len;
	uint8_t unknown3[522];
	uint8_t cause_value0;
	uint8_t unknown4[4];
	uint8_t cause_value1;
	uint8_t unknown5[28];
	uint8_t cause_value2;
	uint8_t reject_type;
	uint8_t reject_value;
	uint8_t unknown6[306];
	uint8_t is_tty;
	uint8_t unknown7[173];
} __attribute__ ((packed));


struct call_callback_resp
{
	uint32_t ref_id;
	uint16_t cmd_type;
	uint8_t unknown0;
	uint8_t result;
	uint8_t unknown1[2];
} __attribute__ ((packed));


struct call_answer_msg
{
	uint32_t ref_id;
	uint8_t call_id;
	uint8_t value0;
	uint8_t value1;
	uint8_t value2;
} __attribute__ ((packed));


struct call_end_msg
{
	uint32_t ref_id;
	uint8_t value0;
	uint8_t call_id;
	uint8_t unknown0[55];
} __attribute__ ((packed));


struct call_origination_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t value0;
	uint8_t unknown1[99];
	uint8_t caller_id[64];
	uint8_t caller_id_len;
	uint8_t unknown2[2];
	uint8_t value1;
	uint8_t unknown3[31];
	uint8_t block;
	uint8_t unknown4;
} __attribute__ ((packed));


struct call_sups_msg
{
	uint32_t ref_id;
	uint8_t command;
	uint8_t call_id;
	uint8_t unknown0[79];
	uint8_t value0;
	uint8_t unknown1[20];
} __attribute__ ((packed));


struct misc_test_alive_msg
{
	uint32_t ref_id;
	uint8_t some_value1;
} __attribute__ ((packed));


struct misc_get_imei_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));


struct misc_get_imei_resp
{
	uint32_t ref_id;
	uint8_t imei[17];
} __attribute__ ((packed));


struct misc_get_radio_firmware_version_msg
{
	uint32_t ref_id;
} __attribute__ ((packed));


struct misc_get_radio_firmware_version_resp
{
	uint32_t ref_id;
	uint8_t carrier_id;
	uint8_t unknown0[3];
	uint8_t firmware_version[13];
	uint8_t unknown1[122];
} __attribute__ ((packed));


struct misc_get_charger_status_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint16_t voltage;
	uint8_t unknown1;
	uint8_t mode;
	uint8_t unknown2[3];
	uint8_t rc;
} __attribute__ ((packed));


struct misc_set_charge_msg
{
	uint32_t ref_id;
	uint8_t unknown0;
	uint8_t mode;
	uint16_t voltage;
	uint8_t rc;
} __attribute__ ((packed));


struct misc_set_date_msg
{
	uint32_t ref_id;
	uint16_t year;
	uint16_t month;
	uint16_t day;
	uint16_t hour;
	uint16_t minutes;
	uint16_t seconds;
	uint8_t unknown0[2];
	int32_t timezone_offset;
	uint8_t value0;
	uint8_t unknown1;
	uint8_t time_source;
	uint8_t unknown2;
} __attribute__ ((packed));


struct misc_set_date_resp
{
	uint32_t ref_id;
	uint8_t rc;
	uint8_t unknown0;
} __attribute__ ((packed));


struct misc_charger_status_event
{
	uint8_t unknown0[5];
	uint16_t voltage;
	uint8_t unknown1[6];
} __attribute__ ((packed));


struct misc_radio_reset_ind_event
{
	uint8_t unknown0[76];
} __attribute__ ((packed));


struct state_change_operation_mode_msg
{
	uint32_t ref_id;
	uint8_t mode;
} __attribute__ ((packed));


struct state_callback_resp
{
	uint32_t ref_id;
	uint8_t unknown0[7];
	uint8_t result;
} __attribute__ ((packed));


struct state_event
{
	uint8_t unknown0;
	uint8_t mode;
	uint8_t unknown1[4077];
	uint8_t als_allowed;
	uint8_t line;
	uint8_t unknown2[17];
} __attribute__ ((packed));

#endif

