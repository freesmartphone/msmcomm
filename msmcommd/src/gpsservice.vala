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

using Msmcomm.LowLevel;
using FsoFramework.StringHandling;

namespace Msmcomm.Daemon
{
    public class GpsService : BaseService, Msmcomm.GPS
    {
        public GpsService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            bool handled = false;

            switch (message.message_type)
            {
                case MessageType.UNSOLICITED_RESPONSE_PDSM_PD:
                    var pd_message = message as LowLevel.Pdsm.Urc.Pd;
                    assert(pd_message != null);

                    switch (pd_message.response_type)
                    {
                        case LowLevel.Pdsm.Urc.Pd.ResponseType.FIX_DATA:
                            var fix_info = Msmcomm.GpsFixInfo();
                            fix_info.timestamp = pd_message.timestamp;
                            fix_info.latitude = pd_message.latitude;
                            fix_info.longitude = pd_message.longitude;
                            fix_info.velocity = pd_message.velocity;

                            pd_fix_data(fix_info);

                            break;
                        case LowLevel.Pdsm.Urc.Pd.ResponseType.SESSION_DONE:
                            pd_session_done();
                            break;
                        default:
                            break;
                    }
                    handled = true;
                    break;

                case MessageType.UNSOLICITED_RESPONSE_PDSM_XTRA:
                    var xtra_message = message as LowLevel.Pdsm.Urc.Xtra;
                    assert(xtra_message != null);

                    switch (xtra_message.response_type)
                    {
                        case LowLevel.Pdsm.Urc.Xtra.ResponseType.XTRA_STATUS:
                            xtra_status();
                            break;
                        case LowLevel.Pdsm.Urc.Xtra.ResponseType.XTRA_DOWNLOAD_REQ:
                            xtra_download_request();
                            break;
                        case LowLevel.Pdsm.Urc.Xtra.ResponseType.XTRA:
                            xtra_info(xtra_message.xtra_data);
                            break;
                        default:
                            break;
                    }

                    handled = true;
                    break;

                default:
                    break;
            }

            return handled;
        }



        public async void pd_get_position(Msmcomm.GpsMode mode, uint8 accuracy ) throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.Pdsm.Command.PdGetPosition();
            message.mode = convertEnum<Msmcomm.GpsMode,LowLevel.Pdsm.Command.PdGetPosition.Mode>(mode);
            message.accuracy = accuracy;

            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.RESPONSE_PDSM_PD_GET_POSITION:
                        finished = true;
                        break;
                }

                return finished;
            });
        }

        public async void pa_set_param() throws Msmcomm.Error, GLib.Error
        {
            var message = new LowLevel.Pdsm.Command.PaSetParam();
            yield channel.enqueueAsyncNew(message, true, (response) => {
                bool finished = false;

                switch (response.message_type)
                {
                    case LowLevel.MessageType.RESPONSE_PDSM_PA_SET_PARAM:
                        finished = true;
                        break;
                }

                return finished;
            });
        }

        public override string repr()
        {
            return "<>";
        }
    }
}

