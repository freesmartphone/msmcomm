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

/* All structures in this file are autogenerated by ./tools/generate-structures-vala.py */

namespace Msmcomm.LowLevel.Structures
{
[CCode (cname = "struct call_status_event", cheader_filename = "structures.h", destroy_function = "")]
struct CallStatusEvent
{
	public uint8 call_id;
	public uint8 call_type;
	public uint8 unknown0;
	public uint8[] caller_id;
	public uint8[] unknown1;
	public uint8[] plmn;
	public uint8[] unknown2;
	public uint8 caller_id_len;
	public uint8[] unknown3;
	public uint8 cause_value0;
	public uint8[] unknown4;
	public uint8 cause_value1;
	public uint8[] unknown5;
	public uint8 cause_value2;
	public uint8 reject_type;
	public uint8 reject_value;
	public uint8[] unknown6;
	public uint8 is_tty;
	public uint8[] unknown7;
}


[CCode (cname = "struct call_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct CallCallbackResponse
{
	public uint32 ref_id;
	public uint16 cmd_type;
	public uint8 unknown0;
	public uint8 result;
	public uint8[] unknown1;
}


[CCode (cname = "struct call_answer_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallAnswerMessage
{
	public uint32 ref_id;
	public uint8 call_id;
	public uint8 value0;
	public uint8 value1;
	public uint8 value2;
}


[CCode (cname = "struct call_end_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallEndMessage
{
	public uint32 ref_id;
	public uint8 value0;
	public uint8 call_id;
	public uint8[] unknown0;
}


[CCode (cname = "struct call_origination_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallOriginationMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 value0;
	public uint8[] unknown1;
	public uint8[] caller_id;
	public uint8 caller_id_len;
	public uint8[] unknown2;
	public uint8 value1;
	public uint8[] unknown3;
	public uint8 block;
	public uint8 unknown4;
}


[CCode (cname = "struct call_sups_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallSupsMessage
{
	public uint32 ref_id;
	public uint8 command;
	public uint8 call_id;
	public uint8[] unknown0;
	public uint8 value0;
	public uint8[] unknown1;
}


[CCode (cname = "struct misc_test_alive_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscTestAliveMessage
{
	public uint32 ref_id;
	public uint8 some_value1;
}


[CCode (cname = "struct misc_get_imei_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetImeiMessage
{
	public uint32 ref_id;
}


[CCode (cname = "struct misc_get_imei_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetImeiResponse
{
	public uint32 ref_id;
	public uint8[] imei;
}


[CCode (cname = "struct misc_get_radio_firmware_version_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetRadioFirmwareVersionMessage
{
	public uint32 ref_id;
}


[CCode (cname = "struct misc_get_radio_firmware_version_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetRadioFirmwareVersionResponse
{
	public uint32 ref_id;
	public uint8 carrier_id;
	public uint8[] unknown0;
	public uint8[] firmware_version;
	public uint8[] unknown1;
}


[CCode (cname = "struct misc_get_charger_status_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetChargerStatusMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint16 voltage;
	public uint8 unknown1;
	public uint8 mode;
	public uint8[] unknown2;
	public uint8 rc;
}


[CCode (cname = "struct misc_set_charge_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscSetChargeMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 mode;
	public uint16 voltage;
	public uint8 rc;
}


[CCode (cname = "struct misc_set_date_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscSetDateMessage
{
	public uint32 ref_id;
	public uint16 year;
	public uint16 month;
	public uint16 day;
	public uint16 hour;
	public uint16 minutes;
	public uint16 seconds;
	public uint8[] unknown0;
	public int32 timezone_offset;
	public uint8 value0;
	public uint8 unknown1;
	public uint8 time_source;
	public uint8 unknown2;
}


[CCode (cname = "struct misc_set_date_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscSetDateResponse
{
	public uint32 ref_id;
	public uint8 rc;
	public uint8 unknown0;
}


[CCode (cname = "struct misc_charger_status_event", cheader_filename = "structures.h", destroy_function = "")]
struct MiscChargerStatusEvent
{
	public uint8[] unknown0;
	public uint16 voltage;
	public uint8[] unknown1;
}


[CCode (cname = "struct misc_radio_reset_ind_event", cheader_filename = "structures.h", destroy_function = "")]
struct MiscRadioResetIndEvent
{
	public uint8[] unknown0;
}


[CCode (cname = "struct state_change_operation_mode_msg", cheader_filename = "structures.h", destroy_function = "")]
struct StateChangeOperationModeMessage
{
	public uint32 ref_id;
	public uint8 operation_mode;
}


[CCode (cname = "struct state_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct StateCallbackResponse
{
	public uint32 ref_id;
	public uint8[] unknown0;
	public uint8 result;
}

} /* namespace Msmcomm.LowLevel.Structures */ 

