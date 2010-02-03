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

#include "internal.h"

extern void *talloc_msmc_ctx;

/*
 * SIM event group handler
 */

unsigned int group_sim_is_valid(struct msmcomm_message *msg)
{
	return (msg->group_id == 0x11);
}

void group_sim_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len)
{ }

void group_sim_free(struct msmcomm_message *msg)
{ }

unsigned int group_sim_get_type(struct msmcomm_message *msg)
{
	/* Ignore all events from second sim card */
	if ((msg->msg_id >= 30 && msg->msg_id <= 56) ||
		msg->msg_id == 58 ||
		msg->msg_id == 60) 
		return MSMCOMM_EVENT_SIM_SIM2_EVENT;
		
	/* some events about real reset failure */
	if ((msg->msg_id >= 75 && msg->msg_id <= 107) ||
		msg->msg_id == 72) 
		return MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE;
	
	switch (msg->msg_id) {
	case 0: 
		return MSMCOMM_EVNET_SIM_INSERTED;
	case 9:
		return MSMCOMM_EVENT_SIM_PIN1_VERIFIED;
	case 10:
		return MSMCOMM_EVENT_SIM_PIN1_BLOCKED;
	case 11:
		return MSMCOMM_EVENT_SIM_PIN1_UNBLOCKED;
	case 12:
		return MSMCOMM_EVENT_SIM_PIN1_ENABLED;
	case 13:
		return MSMCOMM_EVENT_SIM_PIN1_DISABLED;
	case 14:
		return MSMCOMM_EVENT_SIM_PIN1_CHANGED;
	case 15:
		return MSMCOMM_EVENT_SIM_PIN1_PERM_BLOCKED;
	case 16:
		return MSMCOMM_EVENT_SIM_PIN2_VERIFIED;
	case 17:
		return MSMCOMM_EVENT_SIM_PIN2_BLOCKED;
	case 18:
		return MSMCOMM_EVENT_SIM_PIN2_UNBLOCKED;
	case 19:
		return MSMCOMM_EVENT_SIM_PIN2_ENABLED;
	case 20:
		return MSMCOMM_EVENT_SIM_PIN2_DISABLED;
	case 21:
		return MSMCOMM_EVENT_SIM_PIN2_CHANGED;
	case 22:
		return MSMCOMM_EVENT_SIM_PIN2_PERM_BLOCKED;
	case 26:
		return MSMCOMM_EVENT_SIM_REFRESH_RESET;
	case 27:
		return MSMCOMM_EVENT_SIM_REFRESH_INIT;
	case 57:
		return MSMCOMM_EVENT_SIM_REFRESH_INIT_FCN;
	case 61:
		return MSMCOMM_EVENT_SIM_REFRESH_FAILED;
	case 28:
		return MSMCOMM_EVENT_SIM_FDN_ENABLE;
	case 29:
		return MSMCOMM_EVENT_SIM_FDN_DISABLE;
	case 66:
		return MSMCOMM_EVENT_SIM_ILLEGAL;
	case 1:
		return MSMCOMM_EVENT_SIM_REMOVED;
	case 5:
		return MSMCOMM_EVENT_SIM_NO_SIM_EVENT;
	case 6:
		return MSMCOMM_EVENT_SIM_NO_EVENT;
	case 2:
		return MSMCOMM_EVENT_SIM_DRIVER_ERROR;
	case 67:
	case 68:
	case 69:
	case 70:
	case 71:
		return MSMCOMM_EVENT_SIM_INTERNAL_RESET;
	case 24:
		return MSMCOMM_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL;
	case 25:
		return MSMCOMM_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL;
	case 8:
		return MSMCOMM_EVENT_SIM_INIT_COMPLETED_NO_PROV;
	case 4:
		return MSMCOMM_EVENT_SIM_MEMORY_WARNING;
	case 73:
	case 74:
		return MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE;
	case 3:
		return MSMCOMM_EVENT_SIM_CARD_ERROR;
	case 23:
		return MSMCOMM_EVENT_SIM_NO_EVENT;
	case 114:
		return MSMCOMM_EVENT_SIM_GET_PERSO_NW_FAILURE;
	case 124:
		return MSMCOMM_EVENT_SIM_GET_PERSO_NW_BLOCKED;
	case 108:
		return MSMCOMM_EVENT_SIM_REFRESH_APP_RESET;
	case 109:
		return MSMCOMM_EVENT_SIM_REFRESH_3G_SESSION_RESET;
	case 110:
	case 111:
	case 112:
		return MSMCOMM_EVENT_SIM_APP_SELECTED;
	case 134:
	case 135:
	case 136:
	case 137:
		return MSMCOMM_EVENT_SIM_DEFAULT;
	default:
		break;
	}
	
	return MSMCOMM_MESSAGE_INVALID;
}
