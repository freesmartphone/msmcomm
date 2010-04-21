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

#include "internal.h"

#define BUF_MAX			200

static const char * bin_paths[] = {
	"/usr/bin",
	"/usr/local/bin",
	"/usr/sbin",
	"/usr/local/sbin",
	NULL
};

int msmcomm_is_daemon_running() {
	pid_t pid;
	// FIXME
	return 0;
}

int msmcomm_launch_daemon(char *argv[]) {
	int n = 0, fd;
	char *basepath = NULL;
	char buf[BUF_MAX];
	pid_t pid, sid;

	/* try to find the msmcommd executable */
	while (1) {
		if (!bin_paths[n])
			break;
	
		snprintf(buf, BUF_MAX, "%s/msmcommd", bin_paths[n]);
		fd = open(buf, O_RDONLY);
		if (fd > 0) {
			basepath = bin_paths[n];
			break;
		}

		n++;
	}

	/* we have found the right path for msmcommd? */
	if (!basepath)
		return -1;
	
	/* fork off a child process to start msmcommd */
	pid = fork();
	if (pid < 0) 
		return -1;
	if (pid > 0) 
		return 1;

	umask(0);

	/* aquire a valid sid */
	sid = setsid();
	if (sid < 0) 
		exit(1);

	/* create working directory */
	mkdir("/var/run/msmcommd", 0644);
	if (chdir("/var/run/msmcommd") < 0) 
		exit(1);

	/* close unnecessary file descriptors */
	close(fileno(stdin));
	close(fileno(stdout));
	close(fileno(stderr));

	snprintf(buf, BUF_MAX, "%s/msmcommd", basepath);
	if (execvp(buf, argv) == -1)
		/* something went terrible wrong! */
		exit(1);
}

int msmcomm_shutdown_daemon() {
	// FIXME
	return 0;
}

