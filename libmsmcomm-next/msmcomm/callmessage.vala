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
    public class CallOriginationMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x0;
        public static const uint16 MESSAGE_ID = 0x0;

        private CmCallOriginationMessage _message;

        public string number;
        public bool suppress_own_number;

        public CallOriginationMessage()
        {
            base(GROUP_ID, MESSAGE_ID);

            number = "";
            suppress_own_number = false;

            _message = CmCallOriginationMessage();
            setPayload((void*)(&_message), sizeof(CmCallOriginationMessage));

            /* Some unknown values which have to bet set */
            _message.value0 = 0x4;
            _message.value1 = 0x1;
        }
        
        protected override void prepareData()
        {
            _message.ref_id = ref_id;
            Memory.copy(_message.caller_id, number.data, number.length);
            _message.caller_id_len = (uint8) number.length;
            _message.block = suppress_own_number ? 1 : 0;
        }
    }
}
