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

#ifndef MSMCOMM_H_
#define MSMCOMM_H_

#define MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE				1
#define MSMCOMM_MESSAGE_CMD_GET_IMEI							2
#define MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO					3
#define MSMCOMM_MESSAGE_CMD_TEST_ALIVE							4

struct msmcomm_context;
struct msmcomm_message;

typedef (*msmcomm_event_handler_cb) (struct msmcomm_context *ctx, int event);
typedef (*msmcomm_write_handler_cb) (struct msmcomm_context *ctx, uint8_t *data, uint32_t len);

int			msmcomm_init(struct msmcomm_context *ctx);
int			msmcomm_shutdown(struct msmcomm_context *ctx);
int			msmcomm_read_from_modem(struct msmcomm_context *ctx, int fd);
int			msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg);
void		msmcomm_register_event_handler(struct msmcomm_context *ctx, msmcomm_event_handler_cb event_handler);
void		msmcomm_register_write_handler(struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler);

struct		msmcomm_message* msmcomm_create_message(struct msmcomm_context *ctx, unsigned int type);
uint32_t	msmcomm_message_get_size(struct msmcomm_message *msg);

void		msmcomm_message_change_operation_mode_set_operator_mode(struct msmcomm_message *msg, uint8_t operator_mode);

#endif

