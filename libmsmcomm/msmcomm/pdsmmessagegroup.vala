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
    public class PdsmResponseMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x22;

        public PdsmResponseMessageGroup()
        {
            base(PdsmResponseMessageGroup.GROUP_ID);

            message_types[Pdsm.Response.PaSetParam.MESSAGE_ID] = typeof(Pdsm.Response.PaSetParam);
            message_types[Pdsm.Response.PdGetPosition.MESSAGE_ID] = typeof(Pdsm.Response.PdGetPosition);
        }
    }

    public class PdsmUrcMessageGroup : BaseMessageGroup
    {
        public static const uint8 GROUP_ID = 0x23;

        public PdsmUrcMessageGroup()
        {
            base(PdsmUrcMessageGroup.GROUP_ID);

            message_types[Pdsm.Urc.Pd.MESSAGE_ID] = typeof(Pdsm.Urc.Pd);
            message_types[Pdsm.Urc.Xtra.MESSAGE_ID] = typeof(Pdsm.Urc.Xtra);
        }
    }
}
