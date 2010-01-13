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

#include <msmcomm/internal.h>

#define TEST(name) \
	fprintf(stdout, "TEST %s [%s]\n", __FUNCTION__, name);

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

extern void *talloc_llc_ctx;

static void test_encode_frame_data(void)
{
	struct frame fr;
	fr.payload = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * 4);
	fr.payload[0] = 0x7e;
	fr.payload[1] = 0x7d;
	fr.payload[2] = 0x7f;
	fr.payload[3] = 0xac;
	fr.payload_len = 4;

	/* do encoding of frame data */
	encode_frame(&fr);

	/* check if encoding is correct */
	TEST("output length");
	COMPARE(fr.payload_len, ==, 6);
	PASSED;

	TEST("output data");
	COMPARE(fr.payload[0], ==, 0x7d);
	COMPARE(fr.payload[1], ==, 0x5e);
	COMPARE(fr.payload[2], ==, 0x7d);
	COMPARE(fr.payload[3], ==, 0x5d);
	COMPARE(fr.payload[4], ==, 0x7f);
	COMPARE(fr.payload[5], ==, 0xac);
	PASSED;

	talloc_free(fr.payload);
}

static void test_decode_frame_data(void)
{
	struct frame fr;
	fr.payload = talloc_size(talloc_llc_ctx, sizeof(uint8_t) * 5);
	fr.payload[0] = 0x7d;
	fr.payload[1] = 0x5e;
	fr.payload[2] = 0x13;
	fr.payload[3] = 0x7d;
	fr.payload[4] = 0x5d;
	fr.payload_len = 5;

	/* do decoding of frame data */
	decode_frame(&fr);

	TEST("output length");
	COMPARE(fr.payload_len, ==, 3);
	PASSED;

	TEST("output data");
	COMPARE(fr.payload[0], ==, 0x7e);
	COMPARE(fr.payload[1], ==, 0x13);
	COMPARE(fr.payload[2], ==, 0x7d);
	PASSED;

	talloc_free(fr.payload);
}

static void test_memleaks(void)
{
	TEST("memory leaks");
	talloc_report(NULL, stderr);
}

int main(int argc, char **argv)
{
	talloc_enable_leak_report();
	init_talloc();

	test_encode_frame_data();
	test_decode_frame_data();

	test_memleaks();
}

