
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

unsigned int group_sms_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x17 && SUBSYSTEM_ID(msg) == 0x1);
}

void group_sms_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
}

void group_sms_free(struct msmcomm_message *msg)
{
}

unsigned int group_sms_get_type(struct msmcomm_message *msg)
{

    switch (MSG_ID(msg))
    {
        case 0x0:
            return MSMCOMM_EVENT_SMS_WMS_CFG_GW_READY;
        case 0x2:
            return MSMCOMM_EVENT_SMS_WMS_CFG_EVENT_ROUTES;
        case 0x3:
            return MSMCOMM_EVENT_SMS_WMS_CFG_MEMORY_STATUS;
        case 0x4:
            return MSMCOMM_EVENT_SMS_WMS_CFG_MESSAGE_LIST;
        case 0x6:
            return MSMCOMM_EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF;
        case 0x8:
            /* FIXME seems to have no realy use */
            return MSMCOMM_MESSAGE_NOT_USED;
        case 0x9:
            return MSMCOMM_EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET;
    }

    return MSMCOMM_MESSAGE_INVALID;
}
