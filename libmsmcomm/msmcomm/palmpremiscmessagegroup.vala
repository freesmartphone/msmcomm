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
    public class MiscResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x1c;

        public MiscResponseMessageGroup()
        {
            base(MiscResponseMessageGroup.GROUP_ID);

            message_types[MiscTestAliveResponseMessage.MESSAGE_ID] = typeof(MiscTestAliveResponseMessage);
            message_types[MiscGetRadioFirmwareVersionResponseMessage.MESSAGE_ID] = typeof(MiscGetRadioFirmwareVersionResponseMessage);
            message_types[MiscGetChargerStatusResponseMessage.MESSAGE_ID] = typeof(MiscGetChargerStatusResponseMessage);
            message_types[MiscSetChargeResponseMessage.MESSAGE_ID] = typeof(MiscSetChargeResponseMessage);
            message_types[MiscSetDateResponseMessage.MESSAGE_ID] = typeof(MiscSetDateResponseMessage);
            message_types[MiscGetImeiResponseMessage.MESSAGE_ID] = typeof(MiscGetImeiResponseMessage);
            message_types[MiscGetHomeNetworkNameResponseMessage.MESSAGE_ID] = typeof(MiscGetHomeNetworkNameResponseMessage);
            message_types[MiscGetCellIdResponseMessage.MESSAGE_ID] = typeof(MiscGetCellIdResponseMessage);
        }
    }

    public class MiscUnsolicitedResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x1d;

        public MiscUnsolicitedResponseMessageGroup()
        {
            base(MiscUnsolicitedResponseMessageGroup.GROUP_ID);

            message_types[MiscRadioResetIndUnsolicitedRespMessage.MESSAGE_ID] = typeof(MiscRadioResetIndUnsolicitedRespMessage);
            message_types[MiscChargerStatusUnsolicitedRespMessage.MESSAGE_ID] = typeof(MiscChargerStatusUnsolicitedRespMessage);
        }
    }
}
