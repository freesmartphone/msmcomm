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
#include <string.h>
#include <assert.h>

#include "talloc.h"
#include "linuxlist.h"
#include "msmcomm.h"
#include "structures.h"

#define LOG_MESSAGE(message, args, ...) \
{ \
	char buffer[4096]; \
	snprintf(buffer, 4096, fmt, ## args); \
	ctx->log_cb(ctx->log_data, buffer, 4096); \
}

#define DEBUG(msg, ...)
#define INFO(msg, ...)

#define MESSAGE_CAST(message, type) ((type*)message->payload)

#define DESCRIPTOR_TYPE_INVALID		0
#define DESCRIPTOR_TYPE_MESSAGE		1
#define DESCRIPTOR_TYPE_RESPONSE	2
#define DESCRIPTOR_TYPE_GROUP		3
#define DESCRIPTOR_TYPE_EVENT 		4

#define SUBSYSTEM_ID(msg) ((msg->msg_id & 0xf0) >> 8)
#define MSG_ID(msg) (msg->msg_id & 0xf)

struct msmcomm_context
{
    msmcomm_event_handler_cb event_cb;
    msmcomm_write_handler_cb write_cb;
    msmcomm_read_handler_cb read_cb;
    msmcomm_log_handler_cb log_cb;
    msmcomm_error_handler_cb error_cb;

    void *event_data;
    void *write_data;
    void *read_data;
    void *error_data;
    void *log_data;
};

struct msmcomm_message
{
	uint8_t group_id;
	uint16_t msg_id;
	uint32_t ref_id;
	uint32_t descriptor_type;
	struct descriptor *descriptor;
	void *payload;
	unsigned int result;
};

typedef void (*msmcomm_message_init_t)(struct msmcomm_message *msg);
typedef uint32_t (*msmcomm_message_get_size_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_message_free_t)(struct msmcomm_message *msg);
typedef uint8_t* (*msmcomm_message_prepare_data_t)(struct msmcomm_message *msg);
typedef unsigned int (*msmcomm_response_is_valid_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_response_handle_data_t)(struct msmcomm_message *msg, uint8_t *data, uint32_t len);
typedef void (*msmcomm_response_free_t)(struct msmcomm_message *msg);
typedef unsigned int (*msmcomm_group_get_type_t)(struct msmcomm_message *msg);

struct descriptor
{
	unsigned int type;

	/* all descriptors */
	msmcomm_message_get_size_t get_size;

	/* message descriptor */
	msmcomm_message_init_t init;
	msmcomm_message_free_t free;	
    msmcomm_message_prepare_data_t prepare_data;
   
	/* group and response descriptor */
    msmcomm_response_handle_data_t handle_data;
	msmcomm_response_is_valid_t is_valid;
    
    /* group descriptor */
    msmcomm_group_get_type_t get_type;
};

int handle_response_data(struct msmcomm_context *ctx, uint8_t *data, uint32_t len);
void report_error(struct msmcomm_context *ctx, int error, void *data);

uint16_t crc16_calc(const uint8_t *data, uint32_t len);

unsigned int network_plmn_to_value(const uint8_t *plmn);


#endif

