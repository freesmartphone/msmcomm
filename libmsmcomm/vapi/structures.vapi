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

/* All structures in this file are autogenerated by ./tools/generate-structures-vala.py */

namespace Msmcomm.LowLevel.Structures
{
[CCode (cname = "struct plmn_field", cheader_filename = "structures.h", destroy_function = "")]
struct PlmnField
{
	public uint16 mcc;
	public uint8 mnc;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PlmnField );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_plmn_field_init")]
	public PlmnField();
}


[CCode (cname = "struct call_event", cheader_filename = "structures.h", destroy_function = "")]
struct CallEvent
{
	public uint8 call_id;
	public uint8 call_type;
	public uint8 unknown0;
	[CCode (array_length_cname = "caller_id_len")]
	public uint8 caller_id[];
	public uint8 unknown1[39];
	public PlmnField plmn;
	public uint8 unknown2[7];
	public uint8 caller_id_len;
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
	[CCode (cname = "msmcomm_low_level_structures_call_event_init")]
	public CallEvent();
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
	[CCode (cname = "msmcomm_low_level_structures_call_callback_resp_init")]
	public CallCallbackResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_call_answer_msg_init")]
	public CallAnswerMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_call_end_msg_init")]
	public CallEndMessage();
}


[CCode (cname = "struct call_origination_msg", cheader_filename = "structures.h", destroy_function = "")]
struct CallOriginationMessage
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 value0;
	public uint8 unknown1[99];
	[CCode (array_length_cname = "caller_id_len")]
	public uint8 caller_id[];
	public uint8 caller_id_len;
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
	[CCode (cname = "msmcomm_low_level_structures_call_origination_msg_init")]
	public CallOriginationMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_call_sups_msg_init")]
	public CallSupsMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_test_alive_msg_init")]
	public MiscTestAliveMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_imei_msg_init")]
	public MiscGetImeiMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_imei_resp_init")]
	public MiscGetImeiResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_radio_firmware_version_msg_init")]
	public MiscGetRadioFirmwareVersionMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_radio_firmware_version_resp_init")]
	public MiscGetRadioFirmwareVersionResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_charger_status_msg_init")]
	public MiscGetChargerStatusMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_set_charge_msg_init")]
	public MiscSetChargeMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_set_date_msg_init")]
	public MiscSetDateMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_set_date_resp_init")]
	public MiscSetDateResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_home_network_name_msg_init")]
	public MiscGetHomeNetworkNameMessage();
}


[CCode (cname = "struct misc_get_home_network_name_resp", cheader_filename = "structures.h", destroy_function = "")]
struct MiscGetHomeNetworkNameResponse
{
	public uint32 ref_id;
	public uint8 unknown0;
	public uint8 rc;
	public uint8 unknown1[84];
	public uint8 operator_name_len;
	[CCode (array_length_cname = "operator_name_len")]
	public uint8 operator_name[];
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
	[CCode (cname = "msmcomm_low_level_structures_misc_get_home_network_name_resp_init")]
	public MiscGetHomeNetworkNameResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_charger_status_event_init")]
	public MiscChargerStatusEvent();
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
	[CCode (cname = "msmcomm_low_level_structures_misc_radio_reset_ind_event_init")]
	public MiscRadioResetIndEvent();
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
	[CCode (cname = "msmcomm_low_level_structures_state_change_operation_mode_msg_init")]
	public StateChangeOperationModeMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_state_sys_sel_pref_msg_init")]
	public StateSysSelPrefMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_state_callback_resp_init")]
	public StateCallbackResponse();
}


[CCode (cname = "struct network_info_field", cheader_filename = "structures.h", destroy_function = "")]
struct NetworkInfoField
{
	public PlmnField plmn;
	public uint8 unknown0;
	public uint8 radio_type;
	public uint8 unknown1[7];
	public uint8 name_len;
	[CCode (array_length_cname = "name_len")]
	public uint8 name[];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( NetworkInfoField );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_network_info_field_init")]
	public NetworkInfoField();
}


[CCode (cname = "struct state_event", cheader_filename = "structures.h", destroy_function = "")]
struct StateEvent
{
	public uint8 unknown0;
	public uint8 mode;
	public uint8 unknown1[5];
	public uint8 service_mode_preference;
	public uint8 unknown2[9];
	public uint8 network_mode_preference;
	public PlmnField current_plmn;
	public uint8 unknown3[251];
	public uint8 network_count;
	public uint8 unknown4[3];
	public NetworkInfoField networks[10];
	public uint8 unknown5[2853];
	public uint8 als_allowed;
	public uint8 line;
	public uint8 unknown6[17];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( StateEvent );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_state_event_init")]
	public StateEvent();
}


[CCode (cname = "struct wms_read_template_field", cheader_filename = "structures.h", destroy_function = "")]
struct WmsReadTemplateField
{
	public uint8 unknown0[172];
	public uint8 received_mask;
	public uint8 unknown1[44];
	public uint8 digit_mode;
	public uint32 number_mode;
	public uint8 number_type;
	public uint8 numbering_plan;
	public uint8 smsc_number_len;
	[CCode (array_length_cname = "smsc_number_len")]
	public uint8 smsc_number[];
	public uint8 unknown2[15];
	public uint8 protocol_id;
	public uint8 unknown3[1813];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsReadTemplateField );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_read_template_field_init")]
	public WmsReadTemplateField();
}


[CCode (cname = "struct wms_sms_received_field", cheader_filename = "structures.h", destroy_function = "")]
struct WmsSmsReceivedField
{
	public uint8 unknown0[15];
	public uint8 sender_len;
	[CCode (array_length_cname = "sender_len")]
	public uint8 sender[];
	public uint8 unknown1[2];
	public uint32 pdu_len;
	public uint8 pdu_start;
	[CCode (array_length_cname = "pdu_len")]
	public uint8 pdu[];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsSmsReceivedField );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_sms_received_field_init")]
	public WmsSmsReceivedField();
}


[CCode (cname = "struct wms_msg_group_event", cheader_filename = "structures.h", destroy_function = "")]
struct WmsMsgGroupEvent
{
	public uint8 response_type;
	public uint8 unknown0[3];
	public uint32 ref_id;
	public WmsReadTemplateField wms_read_template
	{
		get
		{
			return (WmsReadTemplateField?) command_data;
		}
	}
	public uint8 command_data[2075];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsMsgGroupEvent );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_msg_group_event_init")]
	public WmsMsgGroupEvent();
}


[CCode (cname = "struct wms_acknowledge_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsAcknowledgeMessage
{
	public uint32 ref_id;
	public uint8 unknown0[4];
	public uint8 value0;
	public uint8 value1;
	public uint8 value2;
	public uint8 unknown1[1899];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsAcknowledgeMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_acknowledge_msg_init")]
	public WmsAcknowledgeMessage();
}


[CCode (cname = "struct wms_send_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsSendMessage
{
	public uint32 ref_id;
	public uint8 unknown0[2];
	public uint8 nr;
	public uint8 five;
	public uint8 unknown1;
	public uint32 ffffffff;
	public uint8 unknown2[6];
	public uint8 number_type;
	public uint8 number_plan;
	public uint8 service_center_len;
	[CCode (array_length_cname = "service_center_len")]
	public uint8 service_center[];
	public uint16 six_three;
	public uint32 pdu_len;
	[CCode (array_length_cname = "pdu_len")]
	public uint8 pdu[];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsSendMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_send_msg_init")]
	public WmsSendMessage();
}


[CCode (cname = "struct sms_get_info_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SmsGetInfoMessage
{
	public uint32 ref_id;
	public uint8 value0;
	public uint8 value1;
	public uint8 unknown0[3];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SmsGetInfoMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sms_get_info_msg_init")]
	public SmsGetInfoMessage();
}


[CCode (cname = "struct wms_read_template_msg", cheader_filename = "structures.h", destroy_function = "")]
struct WmsReadTemplateMessage
{
	public uint32 ref_id;
	public uint16 template;
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
	[CCode (cname = "msmcomm_low_level_structures_wms_read_template_msg_init")]
	public WmsReadTemplateMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_cfg_set_gw_domain_msg_init")]
	public WmsCfgSetGwDomainMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_cfg_set_routes_msg_init")]
	public WmsCfgSetRoutesMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_cfg_get_message_list_msg_init")]
	public WmsCfgGetMessageListMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_read_msg_init")]
	public WmsReadMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_delete_msg_init")]
	public WmsDeleteMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_wms_return_resp_init")]
	public WmsReturnResponse();
}


[CCode (cname = "struct wms_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct WmsCallbackResponse
{
	public uint16 command;
	public uint8 unknown0[2];
	public uint32 ref_id;
	public uint8 rc;
	public uint8 unknown1;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( WmsCallbackResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_wms_callback_resp_init")]
	public WmsCallbackResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_sim_pin_status_msg_init")]
	public SimPinStatusMessage();
}


[CCode (cname = "struct sim_get_call_forward_info_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimGetCallForwardInfoMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimGetCallForwardInfoMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_get_call_forward_info_msg_init")]
	public SimGetCallForwardInfoMessage();
}


[CCode (cname = "struct sim_return_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimReturnResponse
{
	public uint32 ref_id;
	public uint16 command;
	public uint16 rc;
	public uint8 unknown0[260];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimReturnResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_return_resp_init")]
	public SimReturnResponse();
}


[CCode (cname = "struct sim_read_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimReadResponse
{
	public uint16 file_type;
	public uint8 result;
	public uint8 unknown0;
	public uint8 file_data_len;
	[CCode (array_length_cname = "file_data_len")]
	public uint8 file_data[];
	public uint8 unknown1[1911];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimReadResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_read_resp_init")]
	public SimReadResponse();
}


[CCode (cname = "struct sim_verify_pin_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimVerifyPinResponse
{
	public uint8 unknown0;
	public uint8 pin_retries;
	public uint8 sw1;
	public uint8 sw2;
	public uint8 unknown1[1920];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimVerifyPinResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_verify_pin_resp_init")]
	public SimVerifyPinResponse();
}


[CCode (cname = "struct sim_pin_status_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimPinStatusResponse
{
	public uint8 pin_count;
	public uint8 unknown0[1923];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimPinStatusResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_pin_status_resp_init")]
	public SimPinStatusResponse();
}


[CCode (cname = "struct sim_get_fdn_status_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimGetFdnStatusResponse
{
	public uint8 unknown0[7];
	public uint8 usim;
	public uint8 unknown1[1916];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimGetFdnStatusResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_get_fdn_status_resp_init")]
	public SimGetFdnStatusResponse();
}


[CCode (cname = "struct sim_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SimCallbackResponse
{
	public uint8 unknown0[4];
	public uint8 rc;
	public uint32 ref_id;
	public uint8 response_type;
	public SimReadResponse sim_read_resp
	{
		get
		{
			return (SimReadResponse?) response_data;
		}
	}
	public SimVerifyPinResponse sim_verify_pin_resp
	{
		get
		{
			return (SimVerifyPinResponse?) response_data;
		}
	}
	public SimPinStatusResponse sim_pin_status_resp
	{
		get
		{
			return (SimPinStatusResponse?) response_data;
		}
	}
	public SimGetFdnStatusResponse sim_get_fdn_status_resp
	{
		get
		{
			return (SimGetFdnStatusResponse?) response_data;
		}
	}
	public uint8 response_data[1924];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimCallbackResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_callback_resp_init")]
	public SimCallbackResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_sim_change_pin_msg_init")]
	public SimChangePinMessage();
}


[CCode (cname = "struct sim_get_sim_capabilities_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimGetSimCapabilitiesMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimGetSimCapabilitiesMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_get_sim_capabilities_msg_init")]
	public SimGetSimCapabilitiesMessage();
}


[CCode (cname = "struct sim_read_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SimReadMessage
{
	public uint32 ref_id;
	public uint16 field_type;
	public uint8 unknown0[35];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SimReadMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sim_read_msg_init")]
	public SimReadMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_sim_get_all_pin_status_info_msg_init")]
	public SimGetAllPinStatusInfoMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_read_record_msg_init")]
	public PhonebookReadRecordMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_read_record_bulk_msg_init")]
	public PhonebookReadRecordBulkMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_write_record_msg_init")]
	public PhonebookWriteRecordMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_extended_file_info_msg_init")]
	public PhonebookExtendedFileInfoMessage();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_return_resp_init")]
	public PhonebookReturnResponse();
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
	[CCode (cname = "msmcomm_low_level_structures_phonebook_event_init")]
	public PhonebookEvent();
}


[CCode (cname = "struct phonebook_extended_file_info_event", cheader_filename = "structures.h", destroy_function = "")]
struct PhonebookExtendedFileInfoEvent
{
	public uint8 result;
	public uint8 book_type;
	public uint32 slots_used;
	public uint32 slot_count;
	public uint32 max_chars_per_title;
	public uint32 max_chars_per_number;
	public uint8 unknown0[185];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( PhonebookExtendedFileInfoEvent );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_phonebook_extended_file_info_event_init")]
	public PhonebookExtendedFileInfoEvent();
}


[CCode (cname = "struct network_report_rssi_msg", cheader_filename = "structures.h", destroy_function = "")]
struct NetworkReportRssiMessage
{
	public uint32 ref_id;
	public uint8 mode;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( NetworkReportRssiMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_network_report_rssi_msg_init")]
	public NetworkReportRssiMessage();
}


[CCode (cname = "struct network_report_health_msg", cheader_filename = "structures.h", destroy_function = "")]
struct NetworkReportHealthMessage
{
	public uint32 ref_id;
	public uint8 mode;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( NetworkReportHealthMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_network_report_health_msg_init")]
	public NetworkReportHealthMessage();
}


[CCode (cname = "struct network_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct NetworkCallbackResponse
{
	public uint32 ref_id;
	public uint16 command;
	public uint8 unknown0[2];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( NetworkCallbackResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_network_callback_resp_init")]
	public NetworkCallbackResponse();
}


[CCode (cname = "struct network_state_info_event", cheader_filename = "structures.h", destroy_function = "")]
struct NetworkStateInfoEvent
{
	public uint8 change_field[8];
	public uint8 serv_status;
	public uint8 servce_domain;
	public uint8 service_capability;
	public uint8 gprs_attached;
	public uint16 roam;
	public uint8 unknown0;
	public PlmnField plmn;
	public uint8 unknown1[3];
	public uint8 operator_name_len;
	[CCode (array_length_cname = "operator_name_len")]
	public uint8 operator_name[];
	public uint8 unknown2[3];
	public uint8 hplmn_or_spdi;
	public uint8 hplmn_length;
	public uint8 unknown3[16];
	public uint16 rssi;
	public uint16 ecio;
	public uint8 unknown4[4];
	public uint8 with_nitz_update;
	public uint8 unknown5[522];
	public uint8 year;
	public uint8 month;
	public uint8 day;
	public uint8 hours;
	public uint8 minutes;
	public uint8 seconds;
	public uint16 timezone_offset;
	public uint8 unknown6[11];
	public uint8 gsm_icon_ind;
	public uint8 unknown7;
	public uint8 reg_status;
	public uint8 unknown8;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( NetworkStateInfoEvent );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_network_state_info_event_init")]
	public NetworkStateInfoEvent();
}


[CCode (cname = "struct sound_set_device_msg", cheader_filename = "structures.h", destroy_function = "")]
struct SoundSetDeviceMessage
{
	public uint32 ref_id;
	public uint8 class;
	public uint8 unknown0;
	public uint8 sub_class;
	public uint8 unknown1[3];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SoundSetDeviceMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sound_set_device_msg_init")]
	public SoundSetDeviceMessage();
}


[CCode (cname = "struct sound_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SoundCallbackResponse
{
	public uint32 ref_id;
	public uint8 unknown0[7];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SoundCallbackResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sound_callback_resp_init")]
	public SoundCallbackResponse();
}


[CCode (cname = "struct sups_callback_resp", cheader_filename = "structures.h", destroy_function = "")]
struct SupsCallbackResponse
{
	public uint32 ref_id;
	public uint8 command;
	public uint8 unknown0;
	public uint8 result;
	public uint8 unknown1;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( SupsCallbackResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_sups_callback_resp_init")]
	public SupsCallbackResponse();
}


[CCode (cname = "struct voicemail_get_info_msg", cheader_filename = "structures.h", destroy_function = "")]
struct VoicemailGetInfoMessage
{
	public uint32 ref_id;
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( VoicemailGetInfoMessage );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_voicemail_get_info_msg_init")]
	public VoicemailGetInfoMessage();
}


[CCode (cname = "struct voicemail_return_resp", cheader_filename = "structures.h", destroy_function = "")]
struct VoicemailReturnResponse
{
	public uint32 ref_id;
	public uint8 unknown0[3];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( VoicemailReturnResponse );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_voicemail_return_resp_init")]
	public VoicemailReturnResponse();
}


[CCode (cname = "struct voicemail_event", cheader_filename = "structures.h", destroy_function = "")]
struct VoicemailEvent
{
	public uint8 line0_vm_count;
	public uint8 line1_vm_count;
	public uint8 unknown0[7];
	public unowned uint8[] data
	{
		get
		{
			unowned uint8[] res = (uint8[])(&this);
			res.length = (int)sizeof( VoicemailEvent );
			return res;
		}
	}
	[CCode (cname = "msmcomm_low_level_structures_voicemail_event_init")]
	public VoicemailEvent();
}

} /* namespace Msmcomm.LowLevel.Structures */ 

