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

using GLib;
using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    internal string messageTypeNickName(MessageType message_type, string prefix_to_remove = "")
    {
        var enum_class = (EnumClass) typeof(MessageType).class_ref();
        var enum_value = enum_class.get_value(message_type);
        var result = enum_value.value_nick.replace("unsolicited-response-", "");

        if (prefix_to_remove.length > 0 && 
            prefix_to_remove.length < result.length &&
            result.has_prefix(prefix_to_remove))
        {
            result = result.substring(prefix_to_remove.length);
        }

        return result;
    }
} // namespace Msmcomm
