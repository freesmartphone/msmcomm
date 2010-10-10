
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
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_PDSM_PD_GET_POS
 */

unsigned int resp_pdsm_pd_get_pos_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void resp_pdsm_pd_get_pos_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

uint32_t resp_pdsm_pd_get_pos_get_size(struct msmcomm_message *msg)
{
    return 0;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_PDSM_PD_END_SESSION
 */

unsigned int resp_pdsm_pd_end_session_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void resp_pdsm_pd_end_session_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

uint32_t resp_pdsm_pd_end_session_pos_get_size(struct msmcomm_message *msg)
{
    return 0;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_PA_SET_PARAM
 */

unsigned int resp_pa_set_param_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void resp_pa_set_param_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

uint32_t resp_pa_set_param_get_size(struct msmcomm_message *msg)
{
    return 0;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_LCS_AGENT_CLIENT_RSP
 */

unsigned int resp_lcs_agent_client_rsp_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void resp_lcs_agent_client_rsp_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                           uint32_t len)
{
    /* FIXME */
}

uint32_t resp_lcs_agent_client_rsp_get_size(struct msmcomm_message *msg)
{
    return 0;
}

/*
 * MSMCOMM_MESSAGE_TYPE_RESPONSE_XTRA_SET_DATA
 */

unsigned int resp_xtra_set_data_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void resp_xtra_set_data_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

uint32_t resp_xtra_set_data_get_size(struct msmcomm_message *msg)
{
    return 0;
}
