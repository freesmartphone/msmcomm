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

#define DEBUG

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

struct msmc_context
{
	/* Options, flags etc. */
	int network_port;
	const char serial_port[30];

	struct bsc_fd fds[MSMC_FD_COUNT];

	struct llist_head *in_buffer;
	struct llist_head *out_buffer;

	/* HCI LL specific */
	int state;
	unsigned char next_expected_seq;
};

struct frame
{
	unsigned char adress;
	unsigned char type;
	unsigned char seq;
	unsigned char ack;
	unsigned char *payload;
	unsigned int payload_len;
};

struct msmc_control_message
{
	unsigned char	type;
	unsigned int	payload_len;
	unsigned char	*payload;
};

void log_message(char *file, int line, int level, const char *format, ...);
unsigned short crc16_calc(const unsigned char *data, int len); 
void hexdump(const unsigned char *data, int len);

#ifdef DEBUG
#define DEBUG_MSG(fmt, args...) log_message(__FILE__, __LINE__, MSMC_LOG_LEVEL_DEBUG, fmt, ## args)
#else
#define DEBUG_MSG(fmt, args...)
#endif

unsigned char* msmc_frame_decode(unsigned char *data, unsigned int len, unsigned int *new_len);
void msmc_frame_create(struct frame *fr, unsigned int type);

#endif

