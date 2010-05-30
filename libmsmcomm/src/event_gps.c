
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
 * MSMCOMM_EVENT_PDSM_PD_DONE
 */

unsigned int event_pdsm_pd_done_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x23) && (msg->msg_id == 0x1);
}

void event_pdsm_pd_done_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

/*
 * MSMCOMM_EVENT_PD_POSITION_DATA
 */

unsigned int event_pd_position_data_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void event_pd_position_data_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

/*
 * MSMCOMM_EVENT_PD_PARAMTER_CHANGE
 */

unsigned int event_pd_parameter_change_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void event_pd_parameter_change_handle_data(struct msmcomm_message *msg, uint8_t * data,
                                           uint32_t len)
{
    /* FIXME */
}

/*
 * MSMCOMM_EVENT_PDSM_LCS
 */

unsigned int event_pdsm_lcs_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void event_pdsm_lcs_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

/*
 * MSMCOMM_EVENT_PDSM_XTRA
 */

unsigned int event_pdsm_xtra_is_valid(struct msmcomm_message *msg)
{
    //return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
    return 0;
}

void event_pdsm_xtra_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}
