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
#ifndef MSMC_H_
#define MSMC_H_

#ifdef __cplusplus
extern "C" {
#endif		

#define MSMC_STATE_INVALID			0
#define MSMC_STATE_ACTIVE			1
#define MSMC_STATE_CONNECTING		2
#define MSMC_STATE_CONNECTED		3

#define MSMC_DEFAULT_FRAME_SIZE		31
#define MSMC_MAX_WINDOW_SIZE		8
#define MSMC_BUFFER_SIZE			4096

typedef int (*msmc_write_function) (struct msmc_handle *handle, void *data, unsigned int len);
typedef int (*msmc_read_function)  (struct msmc_handle *handle, void *data, unsigned int len);

struct msmc_handle 
{
	unsigned int state;
	unsigned int frame_size;
	unsigned int buffer_used;
	char buffer[MSMC_BUFFER_SIZE];
	unsigned int next_sequence_nr;
	unsigned int last_sequence_nr;
	
	/* some callback functions to do read and write */
	msmc_read_function read;
	msmc_data_available write;
};

void msmc_init(struct msmc_handle *handle);
void msmc_free(struct msmc_handle *handle);
void msmc_shutdown(struct msmc_handle *handle);
int msmc_link_established(struct msmc_handle *handle);
void msmc_startup(struct msmc_handle *handle);
void msmc_data_available(struct msmc_handle *handle);

#ifdef __cplusplus
};
#endif

#endif

