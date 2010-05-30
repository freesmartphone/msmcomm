
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

pid_t _daemon_pid = 0;

int _daemon_launched = 0;

static const char *bin_paths[] = {
    "/usr/bin",
    "/usr/local/bin",
    "/usr/sbin",
    "/usr/local/sbin",
    NULL
};

int msmcomm_launch_daemon(const char *workdir)
{
    int n = 0, fd;

    const char *basepath = NULL;

    char buf[BUF_MAX];

    pid_t pid, sid;

    struct stat st;

    /* we don't support launched the daemon twice */
    if (_daemon_launched)
        return -1;

    /* try to find the msmcommd executable */
    while (1)
    {
        if (!bin_paths[n])
            break;

        snprintf(buf, BUF_MAX, "%s/msmcommd", bin_paths[n]);
        fd = open(buf, O_RDONLY);
        if (fd > 0)
        {
            basepath = bin_paths[n];
            break;
        }

        n++;
    }

    if (!basepath)
        return -1;

    /* fork off a child process to start msmcommd */
    pid = fork();
    if (pid < 0)
        return -1;
    if (pid > 0)
    {
        _daemon_launched = 1;
        /* we are the parent process and have to remember the pid of our child
         * process for later use */
        _daemon_pid = pid;
        return 1;
    }

    umask(0);

    /* aquire a valid sid */
    sid = setsid();
    if (sid < 0)
        exit(1);

    /* create and change to working directory */
    if (stat(workdir, &st) < 0)
        mkdir(workdir, 0770);
    if (chdir(workdir) < 0)
        exit(1);

    /* close unnecessary file descriptors */
    close(fileno(stdin));
    close(fileno(stdout));
    close(fileno(stderr));

    /* launch msmcomm daemon */
    snprintf(buf, BUF_MAX, "%s/msmcommd", basepath);
    if (execvp(buf, NULL) == -1)
        /* something went terrible wrong! */
        exit(1);
}

int msmcomm_is_daemon_running()
{
    /* NOTE: We are only checking if the daemon was launched by ourself! If 
     * anyone else launched the daemon and we don't this will always return 
     * false as result! */
    pid_t sid;

    if (!_daemon_launched)
        return 0;

    /* to check if the process is running we try to get the session id of the
     * process. The getsid() then told us if the process is running or not */
    sid = getsid(_daemon_pid);
    if (sid < 0)
    {
        switch (errno)
        {
            case EPERM:
                break;
            case ESRCH:
                return 0;
        }
    }

    return 1;
}

int msmcomm_shutdown_daemon()
{
    int res;

    if (!_daemon_launched)
        return 0;

    res = kill(_daemon_pid, SIGKILL);
    if (res < 0)
        return 0;

    _daemon_launched = 0;

    return 1;
}
