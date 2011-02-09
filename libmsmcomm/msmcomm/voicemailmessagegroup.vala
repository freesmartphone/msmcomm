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
    public class VoicemailResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x28;

        public VoicemailResponseMessageGroup()
        {
            base(VoicemailResponseMessageGroup.GROUP_ID);

            message_types[VoicemailReturnResponseMessage.MESSAGE_ID] = typeof(VoicemailReturnResponseMessage);
        }
    }

    public class VoicemailUrcMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x29;

        public VoicemailUrcMessageGroup()
        {
            base(VoicemailUrcMessageGroup.GROUP_ID);

            message_types[VoicemailUrcMessage.MESSAGE_ID] = typeof(VoicemailUrcMessage);
        }
    }
}
