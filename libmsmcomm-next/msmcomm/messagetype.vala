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

namespace Msmcomm.LowLevel
{
    public enum MessageType
    {
        INVALID,
        COMMAND_CALL_ORIGINATION,
        COMMAND_CALL_ANSWER,
        COMMAND_CALL_END,
        COMMAND_CALL_SUPS,

        COMMAND_STATE_CHANGE_OPERATION_MODE_REQUEST,

        RESPONSE_CALL_CALLBACK,
        RESPONSE_CALL_RETURN,
    }

    public string messageTypeToString(MessageType type)
    {
        string result = "UNKNOWN";

        switch (type)
        {
            case MessageType.INVALID:
                result = "INVALID";
                break;
            case MessageType.COMMAND_CALL_ORIGINATION:
                result = "COMMAND_CALL_ORIGINATION";
                break;
            case MessageType.COMMAND_CALL_ANSWER:
                result = "COMMAND_CALL_ANSWER";
                break;
            case MessageType.COMMAND_CALL_END:
                result = "COMMAND_CALL_END";
                break;
            case MessageType.COMMAND_CALL_SUPS:
                result = "COMMAND_CALL_SUPS";
                break;
            case MessageType.RESPONSE_CALL_CALLBACK:
                result = "RESPONSE_CALL_CALLBACK";
                break;
            case MessageType.RESPONSE_CALL_RETURN:
                result = "RESPONSE_CALL_RETURN";
                break;
        }

        return result;
    }
}

