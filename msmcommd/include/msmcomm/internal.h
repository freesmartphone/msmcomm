/* 
 * (c) 2009 by Simon Busch <morphis@gravedo.de>
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
#ifndef _MSMC_INTERNAL_H_
#define _MSMC_INTERNAL_H_

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <netinet/in.h>

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

#include <arpa/inet.h>

#include <msmcomm/select.h>
#include <msmcomm/timer.h>
#include <msmcomm/talloc.h>

#define DEBUG

#define NEW(type, count) (type*) malloc(sizeof(type) * count)

#define MSMC_DEFAULT_SERIAL_BAUDRATE	B115200
#define MSMC_DEFAULT_SERIAL_PORT		"/dev/modemuart"

#define MSMC_DEFAULT_NETWORK_PORT		3030

#define MSMC_STATE_NULL					0
#define MSMC_STATE_INIT					1
#define MSMC_STATE_ACTIVE				2

#define MSMC_FRAME_TYPE_SYNC			1
#define MSMC_FRAME_TYPE_SYNC_RESP		2
#define MSMC_FRAME_TYPE_CONFIG			3
#define MSMC_FRAME_TYPE_CONFIG_RESP		4
#define MSMC_FRAME_TYPE_ACK				5
#define MSMC_FRAME_TYPE_DATA			6

#define MSMC_SYNC_SENT_INTERVAL			250

#define MSMC_FD_COUNT					2

#define MSMC_FD_SERIAL					0
#define MSMC_FD_NETWORK					1

#define MSMC_MAX_BUFFER_SIZE			4096

#define MSMC_LOG_LEVEL_DEBUG			0
#define MSMC_LOG_LEVEL_ERROR			1
#define MSMC_LOG_LEVEL_INFO				2

#define MSMC_CONTROL_MSG_TYPE_DATA		0
#define MSMC_CONTROL_MSG_TYPE_CMD		1
#define MSMC_CONTROL_MSG_TYPE_RSP		2

#define MSMC_CONTROL_MSG_CMD_RESET_LL	0
#define MSMC_CONTROL_MSG_CMD_SUBSCRIBE	1

#define MSMC_CONTROL_MSG_RSP_RESET_LL_OK	0
#define MSMC_CONTROL_MSG_RSP_DATA_SCHEDULED	1

struct msmc_context
{
	/* Options, flags etc. */
	int					network_port;
	const char			serial_port[30];
	struct bsc_fd		fds[MSMC_FD_COUNT];

	/* HCI LL specific */
	int					state;
	uint8_t		next_expected_seq;
};

typedef void (*msmc_data_handler_cb_t) (struct msmc_context *ctx, const uint8_t *data, uint32_t len);

struct msmc_data_handler
{
	struct llist_head		list;
	msmc_data_handler_cb_t	cb;
};

struct frame
{
	uint8_t adress;
	uint8_t	 type;
	uint8_t	 seq;
	uint8_t	 ack;
	uint8_t	*payload;
	uint32_t	 payload_len;
};

#define MSMC_CONTROL_MESSAGE_HEADER_SIZE		1
#define MSMC_CONTROL_MSG_RSP_SIZE				1
#define MSMC_CONTROL_MESSAGE_LEN(ctrl_msg) (ctrl_msg->payload_len + MSMC_CONTROL_MESSAGE_HEADER_SIZE)

struct control_message
{
	void				*mem_ctx;
	struct llist_head	 list;
	uint8_t				 type;
	struct sockaddr_in	*client;
	uint32_t			 payload_len;
	uint8_t				*payload;
};

struct client_subscription
{
	struct llist_head    list;
	void				*mem_ctx;
	struct sockaddr_in  *client;
};

void log_message(char *file, uint32_t line, uint32_t level, const char *format, ...);
unsigned short crc16_calc(const uint8_t *data, uint32_t len); 
void hexdump(const uint8_t *data, uint32_t len);

#ifdef DEBUG
#define DEBUG_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_DEBUG, fmt, ## args)
#else
#define DEBUG_MSG(fmt, args...)
#endif

#define ERROR_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_ERROR, fmt, ## args)
#define INFO_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_INFO, fmt, ## args)

void init_mem(void);

void encode_frame_data(const uint8_t *data, const uint32_t len, uint32_t *new_len, uint8_t *encdoded_data);
void decode_frame_data(const uint8_t *data, const uint32_t len, uint32_t *new_len, uint8_t *decoed_data);
void init_frame(struct frame *fr, uint32_t type);

int init_llc(struct msmc_context *ctx);
void shutdown_llc(struct msmc_context *ctx);
void register_llc_data_handler(struct msmc_context *ctx, msmc_data_handler_cb_t cb);

int init_control_interface(struct msmc_context *ctx, const char *ifname);
void shutdown_control_interface(struct msmc_context *ctx);

void ctrl_msg_format_data_type(struct control_message *ctrl_msg, uint8_t *data, const
								  uint32_t len, uint8_t copy_data);
void ctrl_msg_format_rsp_type(struct control_message *ctrl_msg, uint8_t rsp_type);
void ctrl_msg_format_cmd_type(struct control_message *ctrl_msg, uint8_t cmd_type);
void send_ctrl_msg(int fd, struct control_message *ctrl_msg);

#endif

