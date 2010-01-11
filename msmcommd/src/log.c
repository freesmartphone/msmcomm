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

const char *log_level_color[] = {
	"\033[1;31m",
	"\033[1;32m",
	"\033[1;33m",
};


void log_message(char *file, uint32_t line, uint32_t level, const char *format, ...)
{
	va_list ap;
	FILE *outfd = stderr;

	va_start(ap, format);

	/* color */
	fprintf(outfd, "%s", log_level_color[level]);

	char timestr[30];
	time_t t;
	t = time(NULL);
	strftime(&timestr[0], 30, "%F %H:%M:%S", localtime(&t));
	fprintf(outfd, "[%s] ", timestr);

	fprintf(outfd, "<%s:%d> ", file, line);
	vfprintf(outfd, format, ap);
	fprintf(outfd, "\033[0;m");
	fprintf(outfd, "\n");

	va_end(ap);
	fflush(outfd);
}
