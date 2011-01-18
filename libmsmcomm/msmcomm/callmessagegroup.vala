/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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


namespace Msmcomm.LowLevel
{
    public class CallResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x1;

        public CallResponseMessageGroup()
        {
            base(CallResponseMessageGroup.GROUP_ID);

            message_types[CallCallbackResponseMessage.MESSAGE_ID] = typeof(CallCallbackResponseMessage);
            message_types[CallReturnResponseMessage.MESSAGE_ID] = typeof(CallReturnResponseMessage);
        }
    }

    public class CallUnsolicitedResponseMessageGroup : UniformMessageGroup<CallUnsolicitedResponseMessage>
    {
        public static const uint8 GROUP_ID = 0x2;

        public CallUnsolicitedResponseMessageGroup()
        {
            base(CallUnsolicitedResponseMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ORIG;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ANSWER;
                    break;
                case 0x2:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_END_REQ;
                    break;
                case 0x3:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_END;
                    break;
                case 0x4:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SUPS;
                    break;
                case 0x5:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_INCOM;
                    break;
                case 0x6:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CONNECT;
                    break;
                case 0x7:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SRV_OPT;
                    break;
                case 0x8:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PRIVACY;
                    break;
                case 0x9:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PRIVACY_PREF;
                    break;
                case 0xa:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALLER_ID;
                    break;
                case 0xb:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ABRV_ALERT;
                    break;
                case 0xc:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ABRV_REORDER;
                    break;
                case 0xd:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ABRV_INTERCEPT;
                    break;
                case 0xe:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SIGNAL;
                    break;
                case 0xf:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_DISPLAY;
                    break;
                case 0x10:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALLED_PARTY;
                    break;
                case 0x11:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CONNECTED_NUM;
                    break;
                case 0x12:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_INFO;
                    break;
                case 0x13:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_EXT_DISP;
                    break;
                case 0x14:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_NDSS_START;
                    break;
                case 0x15:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_NDSS_CONNECT;
                    break;
                case 0x16:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_EXT_BRST_INTL;
                    break;
                case 0x17:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_NSS_CLIR_REC;
                    break;
                case 0x18:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_NSS_REL_REC;
                    break;
                case 0x19:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_NSS_AUD_CTRL;
                    break;
                case 0x1a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_L2ACK_CALL_HOLD;
                    break;
                case 0x1b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SETUP_IND;
                    break;
                case 0x1c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SETUP_RES;
                    break;
                case 0x1d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_CONF;
                    break;
                case 0x1e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_ACTIVATE_IND;
                    break;
                case 0x1f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_ACTIVATE_RES;
                    break;
                case 0x20:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_REQ;
                    break;
                case 0x21:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_IND;
                    break;
                case 0x22:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_REJ;
                    break;
                case 0x23:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_MODIFY_CONF;
                    break;
                case 0x24:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REL_IND;
                    break;
                case 0x25:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_IND;
                    break;
                case 0x26:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_REQ;
                    break;
                case 0x27:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_CONF;
                    break;
                case 0x28:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_REJ;
                    break;
                case 0x29:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_RAB_REESTAB_FAIL;
                    break;
                case 0x2a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PS_DATA_AVAILABLE;
                    break;
                case 0x2b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_MNG_CALLS_CONF;
                    break;
                case 0x2c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_BARRED;
                    break;
                case 0x2d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_IS_WAITING;
                    break;
                case 0x2e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_ON_HOLD;
                    break;
                case 0x2f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_RETRIEVED;
                    break;
                case 0x30:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ORIG_FWD_STATUS;
                    break;
                case 0x31:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_FORWARDED;
                    break;
                case 0x32:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_BEING_FORWARDED;
                    break;
                case 0x33:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_INCOM_FWD_CALL;
                    break;
                case 0x34:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_RESTRICTED;
                    break;
                case 0x35:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CUG_INFO_RECEIVED;
                    break;
                case 0x36:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CNAP_INFO_RECEIVED;
                    break;
                case 0x37:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_EMERGENCY_FLASHED;
                    break;
                case 0x38:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PROGRESS_INFO_IND;
                    break;
                case 0x39:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_DEFLECTION;
                    break;
                case 0x3a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_TRANSFERRED_CALL;
                    break;
                case 0x3b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_EXIT_TC;
                    break;
                case 0x3c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_REDIRECTING_NUMBER;
                    break;
                case 0x3d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PDP_PROMOTE_IND;
                    break;
                case 0x3e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_UMTS_CDMA_HANDOVER_START;
                    break;
                case 0x3f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_UMTS_CDMA_HANDOVER_END;
                    break;
                case 0x40:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_SECONDARY_MSM;
                    break;
                case 0x41:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ORIG_MOD_TO_SS;
                    break;
                case 0x42:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_USER_DATA_IND;
                    break;
                case 0x43:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_USER_DATA_CONG_IND;
                    break;
                case 0x44:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_MODIFY_IND;
                    break;
                case 0x45:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_MODIFY_REQ;
                    break;
                case 0x46:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_LINE_CTRL;
                    break;
                case 0x47:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CCBS_ALLOWED;
                    break;
                case 0x48:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_ACT_CCBS_CNF;
                    break;
                case 0x49:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CCBS_RECALL_IND;
                    break;
                case 0x4a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CCBS_RECALL_RSP;
                    break;
                case 0x4b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CALL_ORIG_THR;
                    break;
                case 0x4c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_VS_AVAIL;
                    break;
                case 0x4d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_VS_NOT_AVAIL;
                    break;
                case 0x4e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_MODIFY_COMPLETE_CONF;
                    break;
                case 0x4f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_MODIFY_RES;
                    break;
                case 0x50:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_CONNECT_ORDER_ACK;
                    break;
                case 0x51:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_TUNNEL_MSG;
                    break;
                case 0x52:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_END_VOIP_CALL;
                    break;
                case 0x53:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_VOIP_CALL_END_CNF;
                    break;
                case 0x54:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_REQ;
                    break;
                case 0x55:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_CNF;
                    break;
                case 0x56:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_CALL_PS_SIG_REL_IND;
                    break;
            }
        }

    }
}
