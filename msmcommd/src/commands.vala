/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

using GLib;

namespace Msmcomm.Daemon
{
    public abstract class BaseCommand
    {
        public ModemChannel channel { get; set; }

        public abstract async void run() throws Msmcomm.Error;

        protected void checkResponse(Msmcomm.LowLevel.BaseMessage response) throws Msmcomm.Error
        {
            if (response.result != Msmcomm.LowLevel.MessageResultType.RESULT_OK)
            {
                var msg = @"$(LowLevel.messageTypeToString(response.message_type)) command failed with: $(LowLevel.messageResultTypeToString(response.result))";
                throw new Msmcomm.Error.FAILED(msg);
            }
        }
    }
}

