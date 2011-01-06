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

using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public class StateChangeOperationModeRequestCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x4;
        public static const uint16 MESSAGE_ID = 0x1;

        private ChangeOperationModeMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST, MessageClass.COMMAND);

            _message = ChangeOperationModeMessage();
            set_payload((void*)(&_message), sizeof(ChangeOperationModeMessage));
        }
    }
}
