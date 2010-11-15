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

typedef enum
{
    DESCRIPTOR_TYPE_INVALID,
    DESCRIPTOR_TYPE_MESSAGE,
    DESCRIPTOR_TYPE_RESPONSE,
    DESCRIPTOR_TYPE_GROUP,
    DESCRIPTOR_TYPE_EVENT,
} descriptor_type_t;

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
void _message_pin_status_set_pin(struct msmcomm_message *msg, const char *pin);
void _message_pin_status_set_pin_type(struct msmcomm_message *msg, msmcomm_sim_pin_type_t pin_type);


/*
 * Some helpful macros
 */

#define LOG_MESSAGE(message, args, ...) \
{ \
    char buffer[4096]; \
    snprintf(buffer, 4096, fmt, ## args); \
    ctx->log_cb(ctx->log_data, buffer, 4096); \
}

#define DEBUG(msg, ...)
#define INFO(msg, ...)

#define MESSAGE_CAST(message, type) ((type*)message->payload)
#define ARRAY_SIZE(array, type) ((unsigned int)(sizeof(array) / sizeof(type)))

/*
 * Everything you need to defines messages/response/events and register them 
 * to the system
 */

#define DEFINE_MESSAGE_TYPE(name) \
    extern void msg_##name##_init(struct msmcomm_message *msg); \
    extern uint32_t msg_##name##_get_size(struct msmcomm_message *msg); \
    extern void msg_##name##_free(struct msmcomm_message *msg); \
    extern uint8_t* msg_##name##_prepare_data(struct msmcomm_message *msg);

#define DEFINE_RESPONSE_TYPE(name) \
    extern unsigned int resp_##name##_is_valid(struct msmcomm_message *msg); \
    extern void resp_##name##_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len); \
    extern uint32_t resp_##name##_get_size(struct msmcomm_message *msg);

#define DEFINE_EVENT_TYPE(name) \
    extern unsigned int event_##name##_is_valid(struct msmcomm_message *msg); \
    extern void event_##name##_handle_data(struct msmcomm_message *msg, uint8_t *data, uint32_t len); \
    extern uint32_t event_##name##_get_size(struct msmcomm_message *msg);

#define DEFINE_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(name) \
    DEFINE_EVENT_TYPE(name) \
    extern unsigned int event_##name##_get_type(struct msmcomm_message *msg);

#define REGISTER_MESSAGE_TYPE(type, name) \
{   type, \
    DESCRIPTOR_TYPE_MESSAGE, \
    MSMCOMM_MESSAGE_CLASS_COMMAND, \
    0, \
    msg_##name##_get_size, \
    msg_##name##_init, \
    msg_##name##_free, \
    msg_##name##_prepare_data, \
    NULL, NULL, NULL }

#define REGISTER_EVENT_TYPE(type, name, has_submsg_id) \
{   type, \
    DESCRIPTOR_TYPE_EVENT, \
    MSMCOMM_MESSAGE_CLASS_EVENT, \
    has_submsg_id, \
    event_##name##_get_size, \
    NULL, NULL, NULL, \
    event_##name##_handle_data, \
    event_##name##_is_valid, \
    NULL }

#define REGISTER_EVENT_TYPE_WITHOUT_EXPLICIT_TYPE(name, has_submsg_id) \
{   MSMCOMM_MESSAGE_TYPE_INVALID, \
    DESCRIPTOR_TYPE_EVENT, \
    MSMCOMM_MESSAGE_CLASS_EVENT, \
    has_submsg_id, \
    NULL, NULL, NULL, NULL, \
    event_##name##_handle_data, \
    event_##name##_is_valid, \
    event_##name##_get_type }

#define REGISTER_RESPONSE_TYPE(type, name, has_submsg_id) \
{   type, \
    DESCRIPTOR_TYPE_RESPONSE, \
    MSMCOMM_MESSAGE_CLASS_RESPONSE, \
    has_submsg_id, \
    resp_##name##_get_size, \
    NULL, NULL, NULL, \
    resp_##name##_handle_data, \
    resp_##name##_is_valid, \
    NULL }

/*
 * Helpful macros to check subsystem/group/msg id's
 */

#define SUBSYSTEM_ID(msg) (msg->msg_id & 0xff)
#define GROUP_ID(msg) (msg->group_id)
#define MSG_ID(msg) ((msg->msg_id & 0xff00) >> 8)

/*
 * subsystem, group and message id definition 
 */

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_CALL						0x00
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_CALL						0x01
#define MSMCOMM_MESSAGE_GROUP_EVENT_CALL						0x02

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_CM_PH						0x03
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_CM_PH					0x04
#define MSMCOMM_MESSAGE_GROUP_EVENT_CM_PH						0x05

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_CM_SS						0x06
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_CM_SS					0x07
#define MSMCOMM_MESSAGR_GROUP_EVENT_CM_SS						0x08

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_CM_SUPS					0x09
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_CM_SUPS					0x0a
#define MSMCOMM_MESSAGE_GROUP_EVENT_CM_SUPS						0x0b

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_CM_INBAND					0x0c
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_CM_INBAND				0x0d
#define MSMCOMM_MESSAGE_GROUP_EVENT_CM_INBAND					0x0e

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_GSDI						0x0f
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_GSDI						0x10
#define MSMCOMM_MESSAGE_GROUP_EVENT_GSDI						0x11

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_GSTK						0x12
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_GSTK						0x13
#define MSMCOMM_MESSAGE_GROUP_EVENT_GSTK						0x14

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_WMS						0x15
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_WMS						0x16
#define MSMCOMM_MESSAGE_GROUP_EVENT_WMS							0x17

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_PBM						0x18
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_PBM						0x19
#define MSMCOMM_MESSAGE_GROUP_EVENT_PBM							0x1a

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_MISC						0x1b
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_MISC						0x1c
#define MSMCOMM_MESSAGE_GROUP_EVENT_MISC						0x1d

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_SOUND						0x1e
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_SOUND					0x1f

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_PDSM						0x21
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_PDSM						0x22
#define MSMCOMM_MESSAGE_GROUP_EVENT_PDSM						0x23

#define MSMCOMM_MESSAGE_GROUP_MESSAGE_VMI						0x27
#define MSMCOMM_MESSAGE_GROUP_RESPONSE_VMI						0x28
#define MSMCOMM_MESSSAGE_GROUP_EVENT_VMI						0x29

#endif

