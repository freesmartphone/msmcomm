/*
 * vim: noai:ts=4:sw=4:expandtab
 *
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

#include "internal.h"

extern void *talloc_msmc_ctx;

/*
 * SIM status events
 */

unsigned int event_sim_status_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == MSMCOMM_MESSAGE_GROUP_EVENT_GSDI);
}

void event_sim_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
}

void event_sim_status_free(struct msmcomm_message *msg)
{
}

msmcomm_message_type_t event_sim_status_get_type(struct msmcomm_message *msg)
{
    /* Ignore all events from second sim card */
    if ((msg->msg_id >= 30 && msg->msg_id <= 56) || msg->msg_id == 58 || msg->msg_id == 60)
        return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_SIM2_EVENT;

    /* some events about real reset failure */
    if ((msg->msg_id >= 75 && msg->msg_id <= 107) || msg->msg_id == 72)
        return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REAL_RESET_FAILURE;

    switch (msg->msg_id)
    {
        case 0x00:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INSERTED;
        case 0x01:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REMOVED;
        case 0x05:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_SIM_EVENT;
        case 0x06:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_EVENT;
        case 0x02:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_DRIVER_ERROR;
        case 0x09:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_VERIFIED;
        case 0x0a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_BLOCKED;
        case 0x0b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_UNBLOCKED;
        case 0x0c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_ENABLED;
        case 0x0d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_DISABLED;
        case 0x0e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_CHANGED;
        case 0x0f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN1_PERM_BLOCKED;
        case 0x10:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_VERIFIED;
        case 0x11:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_BLOCKED;
        case 0x12:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_UNBLOCKED;
        case 0x13:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_ENABLED;
        case 0x14:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_DISABLED;
        case 0x15:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_CHANGED;
        case 0x16:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PIN2_PERM_BLOCKED;
        case 0x1a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_RESET;
        case 0x1b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_INIT;
        case 0x39:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_INIT_FCN;
        case 0x3d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_FAILED;
        case 0x1c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_FDN_ENABLE;
        case 0x1d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_FDN_DISABLE;
        case 0x42:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_ILLEGAL;
        case 0x43:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_ILLEGAL_2;
        case 0x44:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_UHZI_V2_COMPLETE;
        case 0x45:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_UHZI_V1_COMPLETE;
        case 0x46:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_EVENT_GEN_PROP2;
        case 0x47:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INTERNAL_RESET;
        case 0x18:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL;
        case 0x19:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL;
        case 0x08:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_INIT_COMPLETED_NO_PROV;
        case 0x04:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_MEMORY_WARNING;
        case 0x49:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_CARD_ERR_NOT_ATR_RECEIVED_WITH_MAX_VOLTAGE;
        case 0x50:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REAL_RESET_FAILURE;
        case 0x03:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_CARD_ERROR;
        case 0x17:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_NO_EVENT;
        case 0x72:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_GET_PERSO_NW_FAILURE;
        case 0x76:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_GET_PERSO_NW_BLOCKED;
        case 0x6c:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_APP_RESET;
        case 0x6d:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_REFRESH_3G_SESSION_RESET;
        case 0x6e:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_APP_RESET;
        case 0x6f:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_3G_SESSION_RESET_2;
        case 0x70:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_APP_SELECTED;
        case 0x86:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_SANITY_ERROR;
        case 0x87:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_GEN_PROP1;
        case 0x88:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_GEN_PROP2;
        case 0x89:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PERSO_EVT_INIT_COMPLETED;
        case 0x8a:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PLMN_SEL_MENU_ENABLE;
        case 0x8b:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_PLMN_SEL_MENU_DISABLE;
        case 0x90:
            return MSMCOMM_MESSAGE_TYPE_EVENT_SIM_DEFAULT;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_TYPE_INVALID;
}

