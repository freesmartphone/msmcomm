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

extern unsigned int resp_cm_ph_is_valid(struct msmcomm_message *msg);
extern void resp_cm_ph_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len);

extern unsigned int event_radio_reset_ind_is_valid(struct msmcomm_message *msg);
extern void event_radio_reset_ind_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len);

struct response_descriptor resp_descriptors[] = {
	{	MSMCOMM_RESPONSE_CM_PH, 
		resp_cm_ph_is_valid, 
		resp_cm_ph_handle_data },
	{	MSMCOMM_EVENT_RESET_RADIO_IND,
		event_radio_reset_ind_is_valid,
		event_radio_reset_ind_handle_data },
};

