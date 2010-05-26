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
#include <fcntl.h>

#include <assert.h>

#include <arpa/inet.h>

#include <msmcomm/select.h>
#include <msmcomm/timer.h>
#include <msmcomm/talloc.h>
#include <msmcomm/hsuart.h>
#include <msmcomm/buffer.h>

#define DEBUG

#define BUF_SIZE 256

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

#define MSMC_FRAME_FLAG_RESEND			(1 << 4)

#define MSMC_SYNC_SENT_INTERVAL_MS		0
#define MSMC_SYNC_SENT_INTERVAL_SEC	 	1

#define MSMC_FD_COUNT					2

#define MSMC_FD_SERIAL					0
#define MSMC_FD_NETWORK					1

#define MSMC_MAX_BUFFER_SIZE			4096

#define MSMC_LOG_LEVEL_DEBUG			0
#define MSMC_LOG_LEVEL_ERROR			1
#define MSMC_LOG_LEVEL_INFO				2

#define MSMC_LLC_WINDOW_SIZE			8
#define MSMC_LLC_MAX_SEQUENCE_NR		0xf

struct msmc_context
{
	/* Options, flags etc. */
	char				network_port[5];
	char	    		serial_port[BUF_SIZE];
	char				network_addr[BUF_SIZE];
	char				relay_addr[BUF_SIZE];
	char 				relay_port[5];
	struct bsc_fd		fds[MSMC_FD_COUNT];

	struct buffer		*rx_buf;
	unsigned int		rx_buf_size;

	/* HCI LL specific */
	int					state;
	uint8_t				window_size;
	uint8_t				next_seq;
	uint8_t				next_ack;
	uint8_t				expected_seq;
	uint8_t				last_ack;
};

typedef void (*msmc_data_handler_cb_t) (struct msmc_context *ctx, const uint8_t *data, uint32_t len);

struct msmc_data_handler
{
	struct llist_head		list;
	msmc_data_handler_cb_t	cb;
};

struct tx_item
{
	struct llist_head list;
	struct frame *frame;
	unsigned int attempts;
};

struct frame
{
	struct llist_head list;
	uint8_t address;
	uint8_t	 type;
	uint8_t unknown;
	uint8_t	 seq;
	uint8_t	 ack;
	uint8_t	*payload;
	uint32_t	 payload_len;
};

struct relay_connection
{
	struct llist_head list;
	struct sockaddr addr;
	uint32_t in_count;
	uint32_t out_count;
	struct bsc_fd bfd;
	struct msmc_context *ctx;
};

#define LOGL_DEBUG 		1
#define LOGL_ERROR 		2
#define LOGL_INFO 		3

#define LOG_TARGET_STDERR 	0
#define LOG_TARGET_FILE		1

void log_change_target(int new_target);
void log_target_close();
void log_change_destination(char *destination);
void log_message(char *file, uint32_t line, uint32_t level, const char *format, ...);
unsigned short crc16_calc(const uint8_t *data, uint32_t len); 
void hexdump(uint8_t *data, uint32_t len);

#ifdef DEBUG
#define DEBUG_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_DEBUG, fmt, ## args)
#else
#define DEBUG_MSG(fmt, args...)
#endif

#define ERROR_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_ERROR, fmt, ## args)
#define INFO_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_INFO, fmt, ## args)

void init_talloc(void);
void init_talloc_late(void);

void init_frame(struct frame *fr, uint32_t type);
void encode_frame(struct frame *fr);
void decode_frame(struct frame *fr);

int init_llc(struct msmc_context *ctx);
void shutdown_llc(struct msmc_context *ctx);
void register_llc_data_handler(struct msmc_context *ctx, msmc_data_handler_cb_t cb);
void schedule_llc_data(struct msmc_context *ctx, const uint8_t *data, uint32_t len);

int init_relay_interface(struct msmc_context *ctx);
void shutdown_relay_interface(struct msmc_context *ctx);

enum source_type {
	SOURCE_TYPE_NONE,
	SOURCE_TYPE_NETWORK,
	SOURCE_TYPE_SERIAL,
};

struct config 
{
	enum source_type source_type;
	char serial_path[BUF_SIZE];
	char network_addr[BUF_SIZE];
	char network_port[5];
	char relay_addr[BUF_SIZE];
	char relay_port[5];
	int log_target;
	char log_destination[BUF_SIZE];
};

struct config *config_load(const char *filename);

#endif

