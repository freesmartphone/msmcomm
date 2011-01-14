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

#include <internal.h>

#define TEST \
	fprintf(stdout, "TEST %s\n", __FUNCTION__);

#define PASSED \
	fprintf(stdout, "\033[1;32m"); \
	fprintf(stdout, "PASSED!"); \
	fprintf(stdout, "\033[0;m\n");

#define COMPARE(result, op, value) \
	if (!((result) op (value))) {\
		fprintf(stderr, "\033[1;31m"); \
		fprintf(stderr, "FAILED! Compare failed. Was 0x%x should be 0x%x in %s:%d", result, value, __FILE__, \
				__LINE__); \
		fprintf(stderr, "\033[0;m\n"); \
		exit(-1); \
	}
	
	
int test_copy_message()
{
	TEST;
	
	struct msmcomm_message *msg0 = 
		msmcomm_create_message(MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE);
	msmcomm_message_change_operation_mode_set_operation_mode(msg0, MSMCOMM_OPERATION_MODE_OFFLINE);
	
	msmcomm_message_set_ref_id(msg0, 0x42);
	
	struct msmcomm_message *msg1 = msmcomm_message_make_copy(msg0);
	
	COMPARE(msg0, !=, msg1);
	COMPARE(msg0->ref_id, ==, msg1->ref_id);
	COMPARE(sizeof(msg0->payload), ==, sizeof(msg1->payload));
	COMPARE(msg0->group_id, ==, msg1->group_id);
	COMPARE(msg0->msg_id, ==, msg1->msg_id);
	COMPARE(msg0->payload, !=, msg1->payload);
	COMPARE(((struct change_operation_mode_msg*)msg0->payload)->operation_mode,
			==,
			((struct change_operation_mode_msg*)msg1->payload)->operation_mode);
	COMPARE(msmcomm_message_get_type(msg1), ==,
			MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE);
	COMPARE(msmcomm_message_get_type(msg0), ==,
			MSMCOMM_MESSAGE_TYPE_COMMAND_CHANGE_OPERATION_MODE);
	
	PASSED;
}

int main(int argc, char *argv[])
{
	test_copy_message();
	
	return 0;
}
