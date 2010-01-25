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

const unsigned int resp_descriptors_count = sizeof(resp_descriptors) 
											/ sizeof(struct response_descriptor);

int handle_response_data(struct msmcomm_context *ctx, uint8_t *data, uint32_t len)
{
	int n;
	struct msmcomm_message resp;

	/* we can already report events to our user? */
	if (ctx->event_cb == NULL) 
		return 0;

	/* ensure response len: response should be groupId + msgId + one byte data
	 * as minimum*/
	if (len < 3) 
		return 0;
	
	resp.group_id = data[0];
	resp.msg_id = data[1];

	/* find the right rsp descriptor */
	for (n=0; n<resp_descriptors_count; n++) {
		if (resp_descriptors[n].is_valid == NULL ||
			resp_descriptors[n].handle_data == NULL)
			continue;
		
		if (resp_descriptors[n].is_valid(&resp)) {
			/* let our descriptor handle the left data */
			resp_descriptors[n].handle_data(&resp, data + 2, len - 2);

			/* tell the user about the received event/response */
			ctx->event_cb(ctx, resp_descriptors[n].type, &resp);
		}
	}

	return 1;
}

