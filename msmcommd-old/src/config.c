
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


struct config *config_load(const char *filename)
{
    FILE *fp = NULL;

    struct config *cf = NULL;

    ssize_t read = 0;

    char buf[BUF_SIZE], *p;

    char source_path[BUF_SIZE];

    int line = 0, len = 0;

    char *e;

    char *tok;

    fp = fopen(filename, "r");
    if (fp == NULL)
        return NULL;

    cf = (struct config *)malloc(sizeof (struct config));

    cf->source_type = SOURCE_TYPE_NONE;

    buf[BUF_SIZE - 2] = '\0';
    while ((p = fgets(buf, BUF_SIZE, fp)) != NULL)
    {

        line++;

        e = strchr(p, '\n');
        if (e)
        {
            *e = '\0';
        }

        if (buf[BUF_SIZE - 2] != '\0')
        {
            break;
        }

        tok = strsep(&p, " \t");

        if (p == NULL || *tok == '#')
            continue;

        if (strcasecmp(tok, "source_type") == 0)
        {
            char *type = strsep(&p, " \t");

            if (strcasecmp(type, "network") == 0)
            {
                cf->source_type = SOURCE_TYPE_NETWORK;
            }
            else if (strcasecmp(type, "serial") == 0)
            {
                cf->source_type = SOURCE_TYPE_SERIAL;
            }
            else
            {
                fprintf(stderr, "ERROR: unknown source type '%s'\n", type);
                goto error;
            }
        }
        else if (strcasecmp(tok, "source_path") == 0)
        {
            char *path = strsep(&p, " \t");

            strncpy(source_path, path, BUF_SIZE);
        }
        else if (strcasecmp(tok, "relay_addr") == 0)
        {
            char *addr = strsep(&p, " \t");

            tok = strsep(&addr, ":");
            strncpy(cf->relay_addr, addr, strlen(addr));
            strncpy(cf->relay_addr, addr + strlen(tok) + 1, 5);
        }
        else if (strcasecmp(tok, "log_target") == 0)
        {
            char *target = strsep(&p, " \t");

            if (strcasecmp(target, "file") == 0)
                log_change_target(LOG_TARGET_FILE);
            else if (strcasecmp(target, "stderr") == 0)
                log_change_target(LOG_TARGET_STDERR);
        }
        else if (strcasecmp(tok, "log_destination") == 0)
        {
            char *destination = strsep(&p, " \t");

            log_change_destination(destination);
        }
        else
        {
            /* ignore everything else */
            break;
        }
    }

    if (cf->source_type == SOURCE_TYPE_NONE)
    {
        fprintf(stderr, "ERROR: please specify a valid source type!\n");
        goto error;
    }
    else if (cf->source_type == SOURCE_TYPE_SERIAL)
    {
        strncpy(cf->serial_path, source_path, strlen(source_path));
    }
    else if (cf->source_type == SOURCE_TYPE_NETWORK)
    {
        char *p = source_path;

        tok = strsep(&p, ":");
        strncpy(cf->network_addr, source_path, strlen(tok));
        strncpy(cf->network_port, source_path + strlen(tok) + 1, 5);
    }

    fclose(fp);

    return cf;

  error:
    if (fp != NULL)
        fclose(fp);
    if (cf != NULL)
        free(cf);
    return NULL;
}
