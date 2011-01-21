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
[CCode (cname = "struct call_event", cheader_filename = "structures.h", destroy_function = "")]
struct CallEvent
{
	public uint8 call_id;
	public uint8 call_type;
	public uint8 unknown0;
	[CCode (array_length_cname = "caller_id_len")]
	public uint8 caller_id[15];
	public uint8 unknown1[39];
	public uint8 plmn[3];
	public uint8 unknown2[7];
	public uint8 unknown3[522];
	public uint8 cause_value0;
	public uint8 unknown4[4];
	public uint8 cause_value1;
	public uint8 unknown5[28];
	public uint8 cause_value2;
	public uint8 reject_type;
	public uint8 reject_value;
	public uint8 unknown6[306];
	public uint8 is_tty;
	public uint8 unknown7[173];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallEvent );
			return res;
		}
	}
}


[CCode (cname = "struct call_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct CallCallbackResponse
{
	public uint32 ref_id;
	public uint16 cmd_type;
	public uint8 unknown0;
	public uint8 result;
	public uint8 unknown1[2];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallCallbackResponse );
			return res;
		}
	}
}


[CCode (cname = "struct call_answer_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallAnswerMessage
{
	public uint32 ref_id;
	public uint8 call_id;
	public uint8 value0;
	public uint8 value1;
	public uint8 value2;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallAnswerMessage );
			return res;
		}
	}
}


[CCode (cname = "struct call_end_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallEndMessage
{
	public uint32 ref_id;
	public uint8 value0;
	public uint8 call_id;
	public uint8 unknown0[55];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallEndMessage );
			return res;
		}
	}
}


[CCode (cname = "struct call_origination_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallOriginationMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 value0;
	public uint8 unknown1[99];
	[CCode (array_length_cname = "caller_id_len")]
	public uint8 caller_id[64];
	public uint8 unknown2[2];
	public uint8 value1;
	public uint8 unknown3[31];
	public uint8 block;
	public uint8 unknown4;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallOriginationMessage );
			return res;
		}
	}
}


[CCode (cname = "struct call_sups_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallSupsMessage
{
	public uint32 ref_id;
	public uint8 command;
	public uint8 call_id;
	public uint8 unknown0[79];
	public uint8 value0;
	public uint8 unknown1[20];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( CallSupsMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_test_alive_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscTestAliveMessage
{
	public uint32 ref_id;
	public uint8 some_value1;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscTestAliveMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_imei_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetImeiMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetImeiMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_imei_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetImeiResponse
{
	public uint32 ref_id;
	public uint8 imei[17];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetImeiResponse );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_radio_firmware_version_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetRadioFirmwareVersionMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetRadioFirmwareVersionMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_radio_firmware_version_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetRadioFirmwareVersionResponse
{
	public uint32 ref_id;
	public uint8 carrier_id;
	public uint8 unknown0[3];
	public uint8 firmware_version[13];
	public uint8 unknown1[122];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetRadioFirmwareVersionResponse );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_charger_status_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetChargerStatusMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint16 voltage;
	public uint8 unknown1;
	public uint8 mode;
	public uint8 unknown2[3];
	public uint8 rc;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetChargerStatusMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_set_charge_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscSetChargeMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 mode;
	public uint16 voltage;
	public uint8 rc;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscSetChargeMessage );
			return res;
		}
	}
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
	public uint8 unknown0[2];
	public int32 timezone_offset;
	public uint8 value0;
	public uint8 unknown1;
	public uint8 time_source;
	public uint8 unknown2;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscSetDateMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_set_date_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscSetDateResponse
{
	public uint32 ref_id;
	public uint8 rc;
	public uint8 unknown0;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscSetDateResponse );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_home_network_name_msg", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetHomeNetworkNameMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetHomeNetworkNameMessage );
			return res;
		}
	}
}


[CCode (cname = "struct misc_get_home_network_name_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetHomeNetworkNameResponse
{
	public uint32 ref_id;
	public uint8 unknown0[94];
	[CCode (array_length_cname = "operator_name_len")]
	public uint8 operator_name[16];
	public uint16 mcc;
	public uint8 mnc;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscGetHomeNetworkNameResponse );
			return res;
		}
	}
}


[CCode (cname = "struct misc_charger_status_event", cheader_filename = "structures.h", destroy_function = "")]
struct MiscChargerStatusEvent
{
	public uint8 unknown0[5];
	public uint16 voltage;
	public uint8 unknown1[6];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscChargerStatusEvent );
			return res;
		}
	}
}


[CCode (cname = "struct misc_radio_reset_ind_event", cheader_filename = "structures.h", destroy_function = "")]
struct MiscRadioResetIndEvent
{
	public uint8 unknown0[76];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( MiscRadioResetIndEvent );
			return res;
		}
	}
}


[CCode (cname = "struct state_change_operation_mode_msg", cheader_filename = "structures.h", destroy_function = "")]
struct StateChangeOperationModeMessage
{
	public uint32 ref_id;
	public uint8 mode;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( StateChangeOperationModeMessage );
			return res;
		}
	}
}


[CCode (cname = "struct state_sys_sel_pref_msg", cheader_filename = "structures.h", destroy_function = "")]
struct StateSysSelPrefMessage
{
	public uint32 ref_id;
	public uint8 mode;
	public uint8 unknown0[5];
	public uint8 value0;
	public uint8 unknown1[3];
	public uint8 value1;
	public uint8 unknown2[5];
	public uint8 value2;
	public uint8 unknown3;
	public uint8 value3;
	public uint8 value4;
	public uint8 value5;
	public uint8 unknown4[4];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( StateSysSelPrefMessage );
			return res;
		}
	}
}


[CCode (cname = "struct state_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct StateCallbackResponse
{
	public uint32 ref_id;
	public uint8 unknown0[7];
	public uint8 result;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( StateCallbackResponse );
			return res;
		}
	}
}


[CCode (cname = "struct state_event", cheader_filename = "structures.h", destroy_function = "")]
struct StateEvent
{
	public uint8 unknown0;
	public uint8 mode;
	public uint8 unknown1[4077];
	public uint8 als_allowed;
	public uint8 line;
	public uint8 unknown2[17];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( StateEvent );
			return res;
		}
	}
}


[CCode (cname = "struct wms_msg_group_event", cheader_filename = "structures.h", destroy_function = "")]
struct WmsMsgGroupEvent
{
	public uint8 unknown0[23];
	public uint8 sender_length;
	public uint8 sender[36];
	public uint8 unknown1[2];
	public uint32 pdu_length;
	public uint8 pdu_start;
	public uint8 pdu[2016];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsMsgGroupEvent );
			return res;
		}
	}
}


[CCode (cname = "struct wms_acknowledge_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsAcknowledgeMessage
{
	public uint32 ref_id;
	public uint8 unknown0[4];
	public uint8 value0;
	public uint8 value1;
	public uint8 unknown1[1891];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsAcknowledgeMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_send_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsSendMessage
{
	public uint32 ref_id;
	public uint8 unknown0[17];
	public uint8 recipient_length;
	public uint8 recipient[36];
	public uint8 unknown1[2];
	public uint32 pdu_length;
	public uint8 pdu[255];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsSendMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_read_template_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsReadTemplateMessage
{
	public uint32 ref_id;
	public uint16 record;
	public uint8 unknown0[3];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsReadTemplateMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_cfg_set_gw_domain_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsCfgSetGwDomainMessage
{
	public uint32 ref_id;
	public uint8 mode;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsCfgSetGwDomainMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_cfg_set_routes_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsCfgSetRoutesMessage
{
	public uint32 ref_id;
	public uint8 unknown0[25];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsCfgSetRoutesMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_cfg_get_message_list_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsCfgGetMessageListMessage
{
	public uint32 ref_id;
	public uint8 unknown0[3];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsCfgGetMessageListMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_read_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsReadMessage
{
	public uint32 ref_id;
	public uint8 unknown0[5];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsReadMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_delete_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsDeleteMessage
{
	public uint32 ref_id;
	public uint8 unknown0[5];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsDeleteMessage );
			return res;
		}
	}
}


[CCode (cname = "struct wms_return_resp", cheader_filename = "structures.h", destroy_function = "")]
struct WmsReturnResponse
{
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsReturnResponse );
			return res;
		}
	}
}


[CCode (cname = "struct wms_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct WmsCallbackResponse
{
	public uint8 command_id;
	public uint8 unknown0[9];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsCallbackResponse );
			return res;
		}
	}
}


[CCode (cname = "struct sim_pin_status_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimPinStatusMessage
{
	public uint32 ref_id;
	public uint8 pin_type;
	public uint8 pin[8];
	public uint8 unknown0;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimPinStatusMessage );
			return res;
		}
	}
}


[CCode (cname = "struct sim_return_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimReturnResponse
{
	public uint32 ref_id;
	public uint8 unknown0[2];
	public uint16 rc;
	public uint8 unknown1[260];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimReturnResponse );
			return res;
		}
	}
}


[CCode (cname = "struct sim_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimCallbackResponse
{
	public uint8 unknown0[4];
	public uint8 result0;
	public uint32 ref_id;
	public uint8 resp_type;
	public uint16 field_type;
	public uint8 result1;
	public uint8 unknown1;
	[CCode (array_length_cname = "field_len")]
	public uint8 field[8];
	public uint8 unknown2[1911];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimCallbackResponse );
			return res;
		}
	}
}


[CCode (cname = "struct sim_change_pin_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimChangePinMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 old_pin[9];
	public uint8 new_pin[9];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimChangePinMessage );
			return res;
		}
	}
}


[CCode (cname = "struct sim_get_sim_capabilities_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimGetSimCapabilitiesMessage
{
	public uint32 ref_id;
	public uint16 sim_file;
	public uint8 unknown0[35];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimGetSimCapabilitiesMessage );
			return res;
		}
	}
}


[CCode (cname = "struct sim_get_all_pin_status_info_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimGetAllPinStatusInfoMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimGetAllPinStatusInfoMessage );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_read_record_msg", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookReadRecordMessage
{
	public uint32 ref_id;
	public uint8 position;
	public uint8 book_type;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookReadRecordMessage );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_read_record_bulk_msg", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookReadRecordBulkMessage
{
	public uint32 ref_id;
	public uint8 first_position;
	public uint8 first_book_type;
	public uint8 last_position;
	public uint8 last_book_type;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookReadRecordBulkMessage );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_write_record_msg", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookWriteRecordMessage
{
	public uint32 ref_id;
	public uint8 position;
	public uint8 book_type;
	public uint8 number[41];
	public uint8 unknown0;
	public uint8 title[90];
	public uint8 value0;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookWriteRecordMessage );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_extended_file_info_msg", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookExtendedFileInfoMessage
{
	public uint32 ref_id;
	public uint8 book_type;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookExtendedFileInfoMessage );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_return_resp", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookReturnResponse
{
	public uint32 ref_id;
	public uint16 command_id;
	public uint8 result;
	public uint8 position;
	public uint8 book_type;
	public uint8 number[42];
	public uint8 title[90];
	public uint8 encoding_type;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookReturnResponse );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_event", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookEvent
{
	public uint8 position;
	public uint8 unknown0;
	public uint8 book_type;
	public uint8 unknown1[200];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookEvent );
			return res;
		}
	}
}


[CCode (cname = "struct phonebook_extended_file_info_event", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookExtendedFileInfoEvent
{
	public uint8 unknown0;
	public uint8 book_type;
	public uint32 slots_used;
	public uint32 slot_count;
	public uint32 max_chars_per_title;
	public uint32 max_chars_per_number;
	public uint8 unknown1[185];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookExtendedFileInfoEvent );
			return res;
		}
	}
}

} /* namespace Msmcomm.LowLevel.Structures */ 

