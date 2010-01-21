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

#ifndef INTERNAL_H_
#define INTERNAL_H_

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include <strings.h>
#include <stdarg.h>
#include <getopt.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <arpa/inet.h>

#include "talloc.h"
#include "linuxlist.h"
#include "msmcomm.h"

struct msmcomm_context
{
	msmcomm_event_handler_cb event_cb;
	msmcomm_write_handler_cb write_cb;
};

struct msmcomm_message
{
	uint8_t group_id;
	uint8_t msg_id;
	struct message_descriptor *descriptor;
	void *payload;
};

typedef void (*msmcomm_message_init_t)(struct msmcomm_message *msg);
typedef uint32_t (*msmcomm_message_get_size_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_message_free_t)(struct msmcomm_message *msg);
typedef uint8_t* (*msmcomm_message_prepare_data_t)(struct msmcomm_message *msg);

typedef unsigned int (*msmcomm_response_is_valid_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_response_handle_data_t)(struct msmcomm_message *msg, uint8_t *data, uint32_t len);

struct message_descriptor
{
	unsigned int type;
	msmcomm_message_init_t init;
	msmcomm_message_get_size_t get_size;
	msmcomm_message_free_t free;
    msmcomm_message_prepare_data_t prepare_data;
};

struct response_descriptor
{
    int type;
    msmcomm_response_is_valid_t is_valid;
    msmcomm_response_handle_data_t handle_data;
};

#endif

