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

using FsoFramework;
using Msmcomm.LowLevel.Structures;

namespace Msmcomm.LowLevel
{
    public class Pdsm.PaSetParamMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x21;
        public static const uint16 MESSAGE_ID = 0x2;

        private PdsmPaSetParmMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_PDSM_PA_SET_PARAM, MessageClass.COMMAND);

            _message = PdsmPaSetParmMessage();
            set_payload(_message.data);

        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class Pdsm.PaSetParamResponse : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x22;
        public static const uint16 MESSAGE_ID = 0x2;

        private PdsmPaSetParmResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_PDSM_PA_SET_PARAM, MessageClass.SOLICITED_RESPONSE);

            _message = PdsmPaSetParmResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
        }
    }
}
