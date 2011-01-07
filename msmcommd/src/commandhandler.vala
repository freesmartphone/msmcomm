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

namespace Msmcomm.Daemon
{
    /**
     * @class CommandHandler
     **/
    public class CommandHandler
    {
        public unowned Msmcomm.LowLevel.BaseMessage command;
        public unowned Msmcomm.LowLevel.BaseMessage response;
        
        public uint timeout;
        public uint retry;
        public SourceFunc callback;

        public CommandHandler( Msmcomm.LowLevel.BaseMessage command, int retries )
        {
            this.command = command;
            this.retry = retries;
        }

        public string to_string()
        {
            if ( response != null )
            {
                return "\"%s\" -> %s".printf( Msmcomm.LowLevel.messageTypeToString( command.message_type ), 
                                              Msmcomm.LowLevel.messageTypeToString( response.message_type ) );
            }
            else
            {
                return Msmcomm.LowLevel.messageTypeToString( command.message_type );
            }
        }
    }
}

