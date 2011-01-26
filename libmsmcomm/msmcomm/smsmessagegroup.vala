/* 
 * File Name: 
 * Creation Date: 
 * Last Modified: 
 *
 * Authored by Frederik 'playya' Sdun <Frederik.Sdun@googlemail.com>
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
    public static const uint8 GROUP_ID = 0x15;

    public class WmsResponseMessageGroup : BaseMessageGroup
    {
        public WmsResponseMessageGroup()
        {
            base(GROUP_ID);
            
            message_types[WmsReturnResponseMessage.MESSAGE_ID] = typeof(WmsReturnResponseMessage);
            message_types[WmsCallbackResponseMessage.MESSAGE_ID] = typeof(WmsCallbackResponseMessage);
        }
    }
}
