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
    public class SimResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x10;

        public SimResponseMessageGroup()
        {
            base(SimResponseMessageGroup.GROUP_ID);

            message_types[SimCallbackResponseMessage.MESSAGE_ID] = typeof(SimCallbackResponseMessage);
        }
    }

    public class SimUnsolicitedResponseMessageGroup : UniformMessageGroup<SimUnsolicitedResponseMessage>
    {
        public static const uint8 GROUP_ID = 0x11;

        public SimUnsolicitedResponseMessageGroup()
        {
            base(SimUnsolicitedResponseMessageGroup.GROUP_ID);
        }

        protected override void set_message_type(uint16 id, BaseMessage message)
        {
            switch (id)
            {
                case 0x0:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INSERTED;
                    break;
                case 0x1:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_REMOVED;
                    break;
                case 0x2:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_DRIVER_ERROR;
                    break;
                case 0x3:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERROR;
                    break;
                case 0x4:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING;
                    break;
                case 0x5:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NO_SIM_EVENT;
                    break;
                case 0x6:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NO_SIM;
                    break;
                case 0x7:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED;
                    break;
                case 0x8:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_NO_PROV;
                    break;
                case 0x9:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED;
                    break;
                case 0xa:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_BLOCKED;
                    break;
                case 0xb:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED;
                    break;
                case 0xc:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED;
                    break;
                case 0xd:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED;
                    break;
                case 0xe:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_CHANGED;
                    break;
                case 0xf:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED;
                    break;
                case 0x10:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_VERIFIED;
                    break;
                case 0x11:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED;
                    break;
                case 0x12:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED;
                    break;
                case 0x13:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED;
                    break;
                case 0x14:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED;
                    break;
                case 0x15:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_CHANGED;
                    break;
                case 0x16:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED;
                    break;
                case 0x17:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NO_EVENT;
                    break;
                case 0x18:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL;
                    break;
                case 0x19:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL;
                    break;
                case 0x1a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET;
                    break;
                case 0x1b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT;
                    break;
                case 0x1c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_FDN_ENABLE;
                    break;
                case 0x1d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_FDN_DISABLE;
                    break;
                case 0x1e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INSERTED_2;
                    break;
                case 0x1f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_REMOVED_2;
                    break;
                case 0x20:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERROR_2;
                    break;
                case 0x21:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_MEMORY_WARNING_2;
                    break;
                case 0x22:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NO_SIM_EVENT_2;
                    break;
                case 0x23:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_2;
                    break;
                case 0x24:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_INIT_COMPLETED_NO_PROV_2;
                    break;
                case 0x25:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_VERIFIED_2;
                    break;
                case 0x26:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_BLOCKED_2;
                    break;
                case 0x27:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_UNBLOCKED_2;
                    break;
                case 0x28:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_ENABLED_2;
                    break;
                case 0x29:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_DISABLED_2;
                    break;
                case 0x2a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_CHANGED_2;
                    break;
                case 0x2b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN1_PERM_BLOCKED_2;
                    break;
                case 0x2c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_VERIFIED_2;
                    break;
                case 0x2d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_BLOCKED_2;
                    break;
                case 0x2e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_UNBLOCKED_2;
                    break;
                case 0x2f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_ENABLED_2;
                    break;
                case 0x30:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_DISABLED_2;
                    break;
                case 0x31:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_CHANGED_2;
                    break;
                case 0x32:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PIN2_PERM_BLOCKED_2;
                    break;
                case 0x33:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_RESET_2;
                    break;
                case 0x34:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_2;
                    break;
                case 0x35:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_FDN_ENABLE_2;
                    break;
                case 0x36:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_FDN_DISABLE_2;
                    break;
                case 0x37:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_OK_FOR_TERMINAL_PROFILE_DL_2;
                    break;
                case 0x38:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL_2;
                    break;
                case 0x39:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN;
                    break;
                case 0x3a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_SIM_INIT_FCN_2;
                    break;
                case 0x3b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FCN;
                    break;
                case 0x3c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FCN_2;
                    break;
                case 0x3d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_FAILED;
                    break;
                case 0x3e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_START_SWITCH_SLOT;
                    break;
                case 0x3f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_FINISH_SWITCH_SLOT;
                    break;
                case 0x40:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_INIT_COMPLETED;
                    break;
                case 0x41:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP1;
                    break;
                case 0x42:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL;
                    break;
                case 0x43:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_ILLEGAL_2;
                    break;
                case 0x44:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V2_COMPLETE;
                    break;
                case 0x45:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_SIM_UHZI_V1_COMPLETE;
                    break;
                case 0x46:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVENT_GEN_PROP2;
                    break;
                case 0x47:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_INTERNAL_SIM_RESET;
                    break;
                case 0x48:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR;
                    break;
                case 0x49:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE;
                    break;
                case 0x4a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET;
                    break;
                case 0x4b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES;
                    break;
                case 0x4c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES;
                    break;
                case 0x4d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH;
                    break;
                case 0x4e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS;
                    break;
                case 0x4f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS;
                    break;
                case 0x50:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR;
                    break;
                case 0x51:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR;
                    break;
                case 0x52:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR;
                    break;
                case 0x53:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED;
                    break;
                case 0x54:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION;
                    break;
                case 0x55:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE;
                    break;
                case 0x56:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE;
                    break;
                case 0x57:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE;
                    break;
                case 0x58:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE;
                    break;
                case 0x59:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE;
                    break;
                case 0x5a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POLL_ERROR_2;
                    break;
                case 0x5b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_WITH_MAX_VOLTAGE_2;
                    break;
                case 0x5c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_NO_ATR_RECEIVED_AFTER_INT_RESET_2;
                    break;
                case 0x5d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CORRUPT_ATR_RCVD_MAX_TIMES_2;
                    break;
                case 0x5e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_PPS_TIMED_OUT_MAX_TIMES_2;
                    break;
                case 0x5f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_VOLTAGE_MISMATCH_2;
                    break;
                case 0x60:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_TIMED_OUT_AFTER_PPS_2;
                    break;
                case 0x61:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_EXCEED_MAX_ATTEMPTS_2;
                    break;
                case 0x62:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_PARITY_ERROR_2;
                    break;
                case 0x63:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_RX_BREAK_ERROR_2;
                    break;
                case 0x64:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAXED_OVERRUN_ERROR_2;
                    break;
                case 0x65:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_TRANSACTION_TIMER_EXPIRED_2;
                    break;
                case 0x66:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_POWER_DOWN_CMD_NOTIFICATION_2;
                    break;
                case 0x67:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_INT_CMD_ERR_IN_PASSIVE_MODE_2;
                    break;
                case 0x68:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_CMD_TIMED_OUT_IN_PASSIVE_MODE_2;
                    break;
                case 0x69:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_PARITY_IN_PASSIVE_2;
                    break;
                case 0x6a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_RXBRK_IN_PASSIVE_2;
                    break;
                case 0x6b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_CARD_ERR_MAX_OVERRUN_IN_PASSIVE_2;
                    break;
                case 0x6c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET;
                    break;
                case 0x6d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET;
                    break;
                case 0x6e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_APP_RESET_2;
                    break;
                case 0x6f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_REFRESH_3G_SESSION_RESET_2;
                    break;
                case 0x70:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_APP_SELECTED;
                    break;
                case 0x71:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_APP_SELECTED_2;
                    break;
                case 0x72:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NW_FAILURE;
                    break;
                case 0x73:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NS_FAILURE;
                    break;
                case 0x74:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SP_FAILURE;
                    break;
                case 0x75:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CP_FAILURE;
                    break;
                case 0x76:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SIM_FAILURE;
                    break;
                case 0x77:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NW_DEACTIVATED;
                    break;
                case 0x78:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NS_DEACTIVATED;
                    break;
                case 0x79:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SP_DEACTIVATED;
                    break;
                case 0x7a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CP_DEACTIVATED;
                    break;
                case 0x7b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SIM_DEACTIVATED;
                    break;
                case 0x7c:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NCK_BLOCKED;
                    break;
                case 0x7d:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NSK_BLOCKED;
                    break;
                case 0x7e:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SPK_BLOCKED;
                    break;
                case 0x7f:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CCK_BLOCKED;
                    break;
                case 0x80:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_PPK_BLOCKED;
                    break;
                case 0x81:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NCK_UNBLOCKED;
                    break;
                case 0x82:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_NSK_UNBLOCKED;
                    break;
                case 0x83:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SPK_UNBLOCKED;
                    break;
                case 0x84:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_CCK_UNBLOCKED;
                    break;
                case 0x85:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_PPK_UNBLOCKED;
                    break;
                case 0x86:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_SANITY_ERROR;
                    break;
                case 0x87:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP1;
                    break;
                case 0x88:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_GEN_PROP2;
                    break;
                case 0x89:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PERSO_EVT_INIT_COMPLETED;
                    break;
                case 0x8a:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_ENABLE;
                    break;
                case 0x8b:
                    message.message_type = MessageType.UNSOLICITED_RESPONSE_SIM_PLMN_SEL_MENU_DISABLE;
                    break;
            }
        }
    }
}
