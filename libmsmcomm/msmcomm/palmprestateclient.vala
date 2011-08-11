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
    public class StateClient : Client
    {
        //
        // protected
        //

        protected override void handle_unsolicited_response(Message message)
        {
        }

        //
        // public API
        //

        public StateClient(RadioAccess radio_access)
        {
            base(radio_access);
        }

        public async bool set_preferred_technology(StateTechnology technology)
        {
            bool result = false;

            var message = new StateSysSelPrefCommandMessage();
            message.technology = technology;
            result = yield commandqueue.enqueue_async(message, false, (response) => {
                if (response.message_type == MessageType.RESPONSE_STATE_CALLBACK)
                {
                    result = (response.result == MessageResult.OK);
                    return true;
                }
                return false;
            });

            return result;
        }

        public async bool set_operation_mode(StateMode mode)
        {
            bool result = false;
            var message = new StateChangeOperationModeCommandMessage();

            message.mode = mode;
            result = yield commandqueue.enqueue_async(message, false, (response) => {
                if (response.message_type == MessageType.RESPONSE_STATE_CALLBACK)
                {
                    result = (response.result == MessageResult.OK);
                    return true;
                }
                return false;
            });

            return result;
        }
    }
}
