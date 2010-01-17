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

struct msmcomm_context;
struct msmcomm_message;

typedef (*msmcomm_event_handler_cb) (struct msmcomm_context *ctx, int event);

int     msmcomm_init(struct msmcomm_context *ctx);
void    msmcomm_update(struct msmcomm_context *ctx);
int     msmcomm_shutdown(struct msmcomm_context *ctx);
void    msmcomm_register_event_handler(struct msmcomm_context *ctx, msmcomm_event_handler_cb
                                    event_handler);
struct  msmcomm_message* msmcomm_get_next_message(struct msmcomm_message *msg);

struct  msmcomm_message* msmcomm_create_message(struct msmcomm_context *ctx);
void    msmcomm_message_set_type(struct msmcomm_message *msg, int type);
int     msmcomm_message_get_type(struct msmcomm_message *msg);
void    msmcomm_message_set_group_id(struct msmcomm_message *msg, int group_id);
void    msmcomm_message_set_msg_id(struct msmcomm_message *msg, int msg_id);

#endif

