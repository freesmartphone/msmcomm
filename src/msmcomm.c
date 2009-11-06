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

#include <msmc.h>

#define MSMC_FRAME_HEADER_SIZE		1

struct frame
{
	char addr;
	char *payload;
};

struct msmc_handle*
msmc_init(void)
	struct msmc_handle *h;
	h = (struct msmc_handle*) malloc(sizeof(msmc_handle));
	h->frame_size = MSMC_DEFAULT_FRAME_SIZE;
	h->read = NULL;
	h->write = NULL;
	h->buffer_used = 0;
	h->next_sequence_nr = 0;
	h->last_sequence_nr = 0;
}

void
msmc_free(struct msmc_handle *handle)
{
	free(handle);
}

int
msmc_shutdown(struct msmc_handle *handle)
{
	if (handle == NULL)
		return;

	handle->state = MSMC_STATE_INVALID;
}

int
msmc_startup(struct msmc_handle *handle)
{
	if (handle == NULL)
		return;

	/* check if we already in active mode */
	if (handle->state == MSMC_STATE_ACTIVE)
		return -1;
}

int 
msmc_link_established(struct msmc_handle *handle)
{
	if (handle == NULL || handle->state != MSMC_STATE_ACTIVE)
		return 0;
	
	return 1;
}

void
msmc_data_available(struct msmc_handle *h)
{
	unsigned int len, pos, start, size;

	if (!handle->read)
		return;
	
	len = (*(h->read))  (handle, h->buffer + h->buffer_used, 
						sizeof(h->buffer) - h->buffer_used);

	if (len <= 0)
		return;

	h->buffer_used += len;
	pos = 0;
	start = 0;

	while (pos < h->buffer_used)
	{
		if (h->buffer[pos] == (char)0x7e)
		{
			/* we found the end of the current frame, now do basic 
			 * frame handling like header handling and crc checking
			 */
			struct frame *f = (struct frame*) malloc(sizeof(struct frame));
			f->payload = (char*) malloc(sizeof(char) * (pos - start));

			memcpy(f, &buffer[start], pos - start);

		}
		p++;
	}
}
