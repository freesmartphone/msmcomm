/* 
 * (c) 2011 Frederik 'playya' Sdun <Frederik.Sdun@googlemail.com>
 *          Simon Busch <morphis@gravedo.de>
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
 */

using GLib;

namespace Msmcomm.LowLevel
{

    public class SmsResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x16;

        public SmsResponseMessageGroup()
        {
            base(SmsResponseMessageGroup.GROUP_ID);
            message_types[Sms.Response.Return.MESSAGE_ID] = typeof(Sms.Response.Return);
            message_types[Sms.Response.Callback.MESSAGE_ID] = typeof(Sms.Response.Callback);
        }
    }

    public class SmsUrcMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x17;

        public SmsUrcMessageGroup()
        {
            base(SmsUrcMessageGroup.GROUP_ID);
            message_types[Sms.Urc.MsgGroup.MESSAGE_ID] = typeof(Sms.Urc.MsgGroup);
        }
    }

}
