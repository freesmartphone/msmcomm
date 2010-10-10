
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

unsigned int group_sups_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0xb);
}

void group_sups_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
}

void group_sups_free(struct msmcomm_message *msg)
{
}

msmcomm_message_type_t group_sups_get_type(struct msmcomm_message *msg)
{
    switch (msg->msg_id)
    {
        case 12:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_PROCESS_USS;
        case 13:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_PROCESS_USS_CONF;
        case 20:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_USS_RES;
        case 21:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_RELEASE_USS_IND;
        case 17:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_USS_NOTIFY_IND;
        case 18:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_USS_NOTIFY_RES;
        case 14:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_RELEASE;
        case 15:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_ABORT;
        case 2:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_ERASE;
        case 0:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_REGISTER;
        case 1:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_REGISTER_CONF;
        case 22:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_GET_PASSWORD_IN;
        case 23:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_GET_PASSWORD_RES;
        case 8:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_INTERROGATE;
        case 9:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_INTERROGATE_CONF;
        case 4:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_ACTIVATE;
        case 5:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_ACTIVATE_CONF;
        case 6:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_DEACTIVATE;
        case 7:
            return MSMCOMM_MESSAGE_TYPE_RESPONSE_SUPS_DEACTIVATE_CONF;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_INVALID;
}
