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

typedef enum
{
    DESCRIPTOR_TYPE_INVALID,
    DESCRIPTOR_TYPE_MESSAGE,
    DESCRIPTOR_TYPE_RESPONSE,
    DESCRIPTOR_TYPE_GROUP,
    DESCRIPTOR_TYPE_EVENT,
} descriptor_type_t;

#define SUBSYSTEM_ID(msg) (msg->msg_id & 0xff)
#define MSG_ID(msg) ((msg->msg_id & 0xff00) >> 8)

struct msmcomm_context
{
    msmcomm_response_handler_cb resp_cb;
    msmcomm_write_handler_cb write_cb;
    msmcomm_read_handler_cb read_cb;
    msmcomm_log_handler_cb log_cb;
    msmcomm_error_handler_cb error_cb;

    void *resp_data;
    void *write_data;
    void *read_data;
    void *error_data;
    void *log_data;
};

struct msmcomm_message
{
    uint8_t group_id;
    uint16_t msg_id;
    uint8_t submsg_id;
    uint32_t ref_id;
    descriptor_type_t descriptor_type;
    msmcomm_message_class_t class;
    msmcomm_message_type_t type;
    struct descriptor *descriptor;
    void *payload;
    msmcomm_result_t result;
};

typedef void (*msmcomm_message_init_t)(struct msmcomm_message *msg);
typedef uint32_t (*msmcomm_message_get_size_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_message_free_t)(struct msmcomm_message *msg);
typedef uint8_t* (*msmcomm_message_prepare_data_t)(struct msmcomm_message *msg);
typedef unsigned int (*msmcomm_response_is_valid_t)(struct msmcomm_message *msg);
typedef void (*msmcomm_response_handle_data_t)(struct msmcomm_message *msg, uint8_t *data, uint32_t len);
typedef void (*msmcomm_response_free_t)(struct msmcomm_message *msg);
typedef msmcomm_message_type_t (*msmcomm_group_get_type_t)(struct msmcomm_message *msg);

struct descriptor
{
    msmcomm_message_type_t message_type;
    descriptor_type_t type;
    msmcomm_message_class_t class_type;
    
    unsigned int has_submsg_id;

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
void report_error(struct msmcomm_context *ctx, msmcomm_error_t error, void *data);
uint16_t crc16_calc(const uint8_t *data, uint32_t len);
unsigned int network_plmn_to_value(const uint8_t *plmn);


/*
 * Some helpful macros
 */
 
 
#define MESSAGE_TYPE(name) \
    extern void msg_##name##_init(struct msmcomm_message *msg); \
    extern uint32_t msg_##name##_get_size(struct msmcomm_message *msg); \
    extern void msg_##name##_free(struct msmcomm_message *msg); \
    extern uint8_t* msg_##name##_prepare_data(struct msmcomm_message *msg);

#define MESSAGE_DATA(type, name) \
    {   type, \
        DESCRIPTOR_TYPE_MESSAGE, \
        MSMCOMM_MESSAGE_CLASS_COMMAND, \
        0, \
        msg_##name##_get_size, \
        msg_##name##_init, \
        msg_##name##_free, \
        msg_##name##_prepare_data, \
        NULL, NULL, NULL }

#define NEW_TYPE(type, name) \
    extern unsigned int type##_##name##_is_valid(struct msmcomm_message *msg); \
    extern void type##_##name##_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len); \
    extern uint32_t type##_##name##_get_size(struct msmcomm_message *msg);

#define RESPONSE_TYPE(name) NEW_TYPE(resp, name)
#define EVENT_TYPE(name) NEW_TYPE(event, name)

#define EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(name) \
    NEW_TYPE(event, name) \
    extern unsigned int event_##name##_get_type(struct msmcomm_message *msg);

#define TYPE_DATA(type, subtype, class, descriptor_type, name, has_submsg_id) \
{   subtype, \
    descriptor_type, \
    class, \
    has_submsg_id, \
    type##_##name##_get_size, \
    NULL, NULL, NULL, \
    type##_##name##_handle_data, \
    type##_##name##_is_valid, \
    NULL \
}
        
#define EVENT_DATA(type, name, has_submsg_id) \
    TYPE_DATA(event, \
              type, \
              MSMCOMM_MESSAGE_CLASS_EVENT, \
              DESCRIPTOR_TYPE_EVENT, \
              name, \
              has_submsg_id)

#define EVENT_DATA_WITHOUT_EXPLICIT_TYPE(name, has_submsg_id) \
{   MSMCOMM_MESSAGE_TYPE_INVALID, \
    DESCRIPTOR_TYPE_EVENT, \
    MSMCOMM_MESSAGE_CLASS_EVENT, \
    has_submsg_id, \
    NULL, NULL, NULL, NULL, \
    event_##name##_handle_data, \
    event_##name##_is_valid, \
    event_##name##_get_type }

#define RESPONSE_DATA(type, name, has_submsg_id) \
    TYPE_DATA(resp, \
              type, \
              MSMCOMM_MESSAGE_CLASS_RESPONSE, \
              DESCRIPTOR_TYPE_RESPONSE, \
              name, \
              has_submsg_id)

#endif

