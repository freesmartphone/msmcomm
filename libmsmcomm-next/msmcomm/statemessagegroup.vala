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
    public class StateResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x4;

        public StateResponseMessageGroup()
        {
            base(StateResponseMessageGroup.GROUP_ID);

            message_types[StateCallbackResponseMessage.MESSAGE_ID] = typeof(StateCallbackResponseMessage);
        }
    }

    public class StateUnsolicitedResponseMessageGroup : UniformMessageGroup<StateUnsolicitedResponseMessage>
    {
        public static const uint8 GROUP_ID = 0x5;

        public StateUnsolicitedResponseMessageGroup()
        {
            base(StateUnsolicitedResponseMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_OPRT_MODE;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_TEST_CONTROL_TYPE;
                    break;
                case 0x2:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SYS_SEL_PREF;
                    break;
                case 0x3:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_ANSWER_VOICE;
                    break;
                case 0x4:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_NAM_SEL;
                    break;
                case 0x5:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_CURR_NAM;
                    break;
                case 0x6:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_IN_USE_STATE;
                    break;
                case 0x7:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_CDMA_LOCK_MODE;
                    break;
                case 0x8:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_UZ_CHANGED;
                    break;
                case 0x9:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_MAINTREQ;
                    break;
                case 0xa:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_STANDBY_SLEEP;
                    break;
                case 0xb:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_STANDBY_WAKE;
                    break;
                case 0xc:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_INFO;
                    break;
                case 0xd:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_PACKET_STATE;
                    break;
                case 0xe:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_INFO_AVAIL;
                    break;
                case 0xf:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_AVAILABLE;
                    break;
                case 0x10:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_NOT_AVAILABLE;
                    break;
                case 0x11:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SUBSCRIPTION_CHANGED;
                    break;
                case 0x12:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_AVAILABLE_NETWORKS_CONF;
                    break;
                case 0x13:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_CONF;
                    break;
                case 0x14:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_FUNDS_LOW;
                    break;
                case 0x15:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_WAKEUP_FROM_STANDBY;
                    break;
                case 0x16:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_NVRUIM_CONFIG_CHANGED;
                    break;
                case 0x17:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_PREFERRED_NETWORKS_SET;
                    break;
                case 0x18:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_DDTM_PREF;
                    break;
                case 0x19:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_PS_ATTACH_FAILED;
                    break;
                case 0x1a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_RESET_ACM_COMPLETED;
                    break;
                case 0x1b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SET_ACMMAX_COMPLETED;
                    break;
                case 0x1c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_CDMA_CAPABILITY_UPDATED;
                    break;
                case 0x1d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_LINE_SWITCHING;
                    break;
                case 0x1e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SELECTED_LINE;
                    break;
                case 0x1f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SECONDARY_MSM;
                    break;
                case 0x20:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_TERMINATE_GET_NETWORKS;
                    break;
                case 0x21:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_DDTM_STATUS;
                    break;
                case 0x22:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_CCBS_STORE_INFO_CHANGED;
                    break;
                case 0x23:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_EVENT_UNFORCE_ORIG_COMPLETE;
                    break;
                case 0x24:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_STATE_SEND_MANUAL_NET_SELECTN;
                    break;
            }
        }
    }
}
