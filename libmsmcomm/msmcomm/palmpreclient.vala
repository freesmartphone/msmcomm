/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.PalmPre
{
    internal static const int MESSAGE_HEADER_SIZE = 3;

    public abstract class Client : BaseClient
    {
        protected CommandQueue commandqueue
        {
            get { return ((PalmPre.RadioAccess) radio_access).commandqueue; }
        }

        //
        // protected
        //

        protected Client(PalmPre.RadioAccess radio_access)
        {
            base(radio_access);
            radio_access.commandqueue.unsolicited_response.connect(handle_unsolicited_response);
        }

        protected virtual void handle_unsolicited_response(BaseMessage message)
        {
        }
    }
}

