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

using FsoFramework;
using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public class SimService : BaseService, Msmcomm.Sim
    {
        public SimService(ModemControl modem)
        {
            base(modem);
        }

        public override bool handleUnsolicitedResponse(BaseMessage message)
        {
            var handled = false;
            var urc_service_name = messageTypeNickName(message.message_type, "sim-");
            var sim_message = message as SimUnsolicitedResponseMessage;

            if (sim_message != null)
            {
                sim_status(urc_service_name);
                handled = true;
            }

            return handled;
        }

        protected override string repr()
        {
            return "";
        }

        public async void verify_pin(SimPinType pin_type, string pin) throws GLib.Error, Msmcomm.Error, Msmcomm.SimError
        {
            var message = new SimVerfiyPinCommandMessage();
            message.pin_type = convertSimPinTypeForModem(pin_type);
            message.pin = pin;

            var response = yield channel.enqueueAsync(message);

            if ( response.result == Msmcomm.LowLevel.MessageResult.ERROR_BAD_PIN )
            {
                throw new Msmcomm.SimError.BAD_PIN( "The pin send to sim card is invalid!" );
            }

            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }
        }

        public async void change_pin(string old_pin, string new_pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimChangePinCommandMessage();
            message.old_pin = old_pin;
            message.new_pin = new_pin;

            var response = (yield channel.enqueueAsync(message));
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }
        }

        public async void enable_pin(string pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimEnablePinCommandMessage();
            message.pin = pin;

            var response = (yield channel.enqueueAsync(message));
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }
        }

        public async void disable_pin(string pin) throws GLib.Error, Msmcomm.Error
        {
            var message = new SimDisablePinCommandMessage();
            message.pin = pin;

            var response = (yield channel.enqueueAsync(message));
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }

        }

        public async SimCapabilitiesInfo get_sim_capabilities() throws GLib.Error, Msmcomm.Error
        {
            var message = new SimGetSimCapabilitiesCommandMessage();

            var response = (yield channel.enqueueAsync(message));
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }


            return SimCapabilitiesInfo();
        }

        public async void get_all_pin_status_info() throws GLib.Error, Msmcomm.Error
        {
            var message = new SimGetAllPinStatusInfoCommandMessage();

            var response = (yield channel.enqueueAsync(message));
            checkResponse(response);

            switch ( response.message_type )
            {
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_RETURN:
                    logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                    break;
                case Msmcomm.LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                    break;
                default:
                    throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
            }
        }

        public async SimFieldInfo read_field(SimFieldType field_type) throws GLib.Error, Msmcomm.Error
        {
            var info = SimFieldInfo();
            info.type = field_type;

            var message = new SimReadCommandMessage();
            message.field_type = StringHandling.convertEnum<SimFieldType,Msmcomm.LowLevel.SimFileType>(field_type);

            yield channel.enqueueAsyncNew(message, false, (response) => {
                switch ( response.message_type )
                {
                    case LowLevel.MessageType.RESPONSE_SIM_CALLBACK:
                        var cbresp = response as SimCallbackResponseMessage;
                        info.type = StringHandling.convertEnum<Msmcomm.LowLevel.SimFileType,SimFieldType>(cbresp.simfile_type);
                        info.data = cbresp.simfile_data;
                        break;
                    case LowLevel.MessageType.RESPONSE_SIM_RETURN:
                        logger.info( @"Got $(response.message_type) response message for $(message.message_type) command; we don't know why!" );
                        break;
                    default:
                        throw new Msmcomm.Error.INTERNAL_ERROR( @"Got unexpected response for $(message.message_type): $(response.message_type)" );
                }

                return true;
            });

            return info;
        }

        public async void get_call_forward_info() throws GLib.Error, Msmcomm.Error
        {
            var message = new SimGetCallForwardInfoCommandMessage();
            var response = yield channel.enqueueAsync(message);
            checkResponse(response);
        }
    }
}
