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

static const char log_file[] = "/var/log/msmcommd.log";
static int enable_logging = 1;
static int log_target = -1;
static FILE *log_output = NULL;

const char *log_level_names[] = {
	"DEBUG",
	"ERROR",
	"INFO"
};

void log_change_target(int new_target)
{

	if (log_target == new_target)
		/* do nothing */
		return;

	if (log_target == LOG_TARGET_FILE) {
		fflush(log_output);
		fclose(log_output);
	}

	switch (new_target) {
	case LOG_TARGET_FILE:
		log_output = fopen(log_file, "w+");
		break;
	case LOG_TARGET_STDERR:
		log_output = stderr;
		break;
	}
}

void log_message(char *file, uint32_t line, uint32_t level, const char *format, ...)
{
	va_list ap;
	char timestr[30];
	time_t t;

	va_start(ap, format);
	fprintf(log_output, "[%s]", log_level_names[level]);
	t = time(NULL);
	strftime(&timestr[0], 30, "%F %H:%M:%S", localtime(&t));
	fprintf(log_output, "[%s] ", timestr);
	fprintf(log_output, "<%s:%d> ", file, line);
	vfprintf(log_output, format, ap);
	fprintf(log_output, "\n");
	va_end(ap);
	fflush(log_output);
}
