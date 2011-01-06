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


[CCode (cname = "struct misc_test_alive_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscTestAliveResponse
{
	public uint32 ref_id;
	public uint8 unknown0;
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

