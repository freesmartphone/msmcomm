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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_CM_PH
 */

unsigned int resp_cm_ph_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x4) && (msg->msg_id == 0x1);
}

void resp_cm_ph_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct cm_ph_resp))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct cm_ph_resp)->ref_id;

    /* set message result code to the one we got with the response */
    switch (MESSAGE_CAST(msg, struct cm_ph_resp)->result)
    {
        case 0x0:
            msg->result = MSMCOMM_RESULT_OK;
            break;
        case 0x1a:
            msg->result = MSMCOMM_RESULT_ERROR;
            break;
    }
}

uint32_t resp_cm_ph_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_ph_resp);
}

uint8_t msmcomm_resp_cm_ph_get_result(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct cm_ph_resp)->result;
}