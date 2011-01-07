/**
 * This file is part of msmcommd.
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public OperationMode convertOperationModeForService(StateBaseOperationModeMessage.Mode mode)
    {
        OperationMode result = OperationMode.OFFLINE;

        switch (mode)
        {
            case StateBaseOperationModeMessage.Mode.RESET:
                result = OperationMode.RESET;
                break;
            case StateBaseOperationModeMessage.Mode.ONLINE:
                result = OperationMode.ONLINE;
                break;
            case StateBaseOperationModeMessage.Mode.OFFLINE:
                result = OperationMode.OFFLINE;
                break;
        }

        return result;
    }

    public StateBaseOperationModeMessage.Mode convertOperationModeForModem(OperationMode mode)
    {
        StateBaseOperationModeMessage.Mode result = StateBaseOperationModeMessage.Mode.OFFLINE;

        switch (mode)
        {
            case OperationMode.RESET:
                result = StateBaseOperationModeMessage.Mode.RESET;
                break;
            case OperationMode.ONLINE:
                result = StateBaseOperationModeMessage.Mode.ONLINE;
                break;
            case OperationMode.OFFLINE:
                result = StateBaseOperationModeMessage.Mode.OFFLINE;
                break;
        }

        return result;
    }
}
