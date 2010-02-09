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
 * MSMCOMM_MESSAGE_CMD_ANSWER_CALL
 */
 
/*
 * [CMD] til.answercall 2
 * PACKET: dir=write fd=11 fn='/dev/modemuart' len=14/0xe
 * frame (type=Data, seq=04, ack=09)
 * 00 01 00 3b 00 00 00 02 02 01 00                  ...;.......     
 */
 

void msg_answer_call_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x0;
	msg->msg_id = 0x1;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct answer_call_msg);

	/* FIXME unknown why we have to set these bytes ... */
	MESSAGE_CAST(msg, struct answer_call_msg)->ref_id = 0x3b;
	MESSAGE_CAST(msg, struct answer_call_msg)->host_id = 0x2;
	MESSAGE_CAST(msg, struct answer_call_msg)->call_nr = 0x2;
}

uint32_t msg_answer_call_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct answer_call_msg);
}

void msg_answer_call_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_answer_call_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_CMD_END_CALL
 */

/*
 * [CMD] tel.endcall 2
 * PACKET: dir=write fd=11 fn='/dev/modemuart' len=67/0x43
 * frame (type=Data, seq=06, ack=0e)
 * 00 02 00 3d 00 00 00 01 02 00 00 00 00 00 00 00   ...=............
 * 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
 * 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
 * 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
 */
 
void msg_end_call_init(struct msmcomm_message *msg)
{
	msg->group_id = 0x0;
	msg->msg_id = 0x2;

	msg->payload = talloc_zero(talloc_msmc_ctx, struct end_call_msg);

	MESSAGE_CAST(msg, struct end_call_msg)->ref_id = 0x3d;
	MESSAGE_CAST(msg, struct end_call_msg)->host_id = 0x1;
	MESSAGE_CAST(msg, struct end_call_msg)->call_nr = 0x2;
}

uint32_t msg_end_call_get_size(struct msmcomm_message *msg)
{
	return sizeof(struct end_call_msg);
}

void msg_end_call_free(struct msmcomm_message *msg)
{
	talloc_free(msg->payload);
}

uint8_t* msg_end_call_prepare_data(struct msmcomm_message *msg)
{
	return msg->payload;
}

void msmcomm_message_end_call_set_call_number(struct msmcomm_message *msg, uint8_t call_nr)
{
	MESSAGE_CAST(msg, struct end_call_msg)->call_nr = call_nr;
}

