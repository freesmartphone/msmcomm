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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <fcntl.h>
#include <getopt.h>


#define DEFAULT_SCINIT			"/sys/devices/platform/twl4030_audio/scinit"
#define DEFAULT_SCRUN			"/sys/devices/platform/twl4030_audio/scrun"

void print_help()
{
	printf("help:\n");
	printf(" -l --load-script <filename> load script <filename> into kernel\n");
	printf(" -s --script <name> run script <name>\n");
	printf(" -h --help print this help\n");
}

void load_script(char *script_filename)
{
	int len;
	char buffer[4096];
	int fd = open(DEFAULT_SCINIT, O_WRONLY);
	int script_fd = open(script_filename, O_RDONLY);

	while (1) {
		len = read(script_fd, buffer, 4096);
		if (len > 0) 
			write(fd, buffer, len);
		else if (len < 0)
			perror("read()");
		else if (len == 0)
			break;
	}
		
	close(fd);
}

void run_script(char *script_name)
{
	int fd = open(DEFAULT_SCRUN, O_WRONLY);
	write(fd, script_name, strlen(script_name));
	close(fd);
}


int main(int argc, char *argv[])
{
	opterr = 0;
	int option_index;
	int chr;
	char script_name[255];
	char script_filename[4096];

	script_name[0] = '\0';
	script_filename[0] = '\0';

	struct option opts[] = {
		{ "help", no_argument, 0, 'h' },
	};

	while (1) {
		option_index = 0;
		chr = getopt_long(argc, argv, "s:l:h", opts, &option_index);

		if (chr == -1)
			break;

		switch (chr) {
		case 'l':
			snprintf(script_filename, 4096, "%s", optarg);
			break;
		case 's':
			snprintf(script_name, 255, "%s", optarg);
			break;
		case 'h':
			print_help();
			break;
		default:
			break;
		}
	}

	return 0;
}
