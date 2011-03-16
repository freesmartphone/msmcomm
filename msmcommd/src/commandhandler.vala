/*
 * Copyright (C) 2009-2010 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 */

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public delegate bool CommandHandlerTimeoutFunc(CommandHandler handler);

    /**
     * @class CommandHandler
     **/
    public class CommandHandler
    {
        public unowned BaseMessage command;
        public unowned BaseMessage response;

        public int timeout;
        public int retry;
        public SourceFunc callback;
        public bool timed_out;
        public bool ignore_response;

        private CommandHandlerTimeoutFunc timeout_func;
        private uint timeout_watch;

        public CommandHandler( BaseMessage command, int retries = 0, int timeout = 0, CommandHandlerTimeoutFunc? timeout_func = null )
        {
            this.command = command;
            this.retry = retries;
            this.timeout = timeout;
            this.timed_out = false;
            this.timeout_func = timeout_func;
        }

        private bool onTimeout()
        {
            return timeout_func(this);
        }

        public void startTimeout()
        {
            if ( timeout > 0 )
            {
                timeout_watch = GLib.Timeout.add_seconds( timeout, onTimeout );
            }
        }

        public void resetTimeout()
        {
            if ( timeout_watch > 0 )
            {
                GLib.Source.remove( timeout_watch );
            }
        }

        public string to_string()
        {
            if ( response != null )
            {
                return @"\"$(command.message_type)\" -> $(response.message_type)";
            }
            else
            {
                return @"$(command.message_type)";
            }
        }
    }
}

