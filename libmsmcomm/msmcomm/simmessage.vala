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
    public enum SimFileType
    {
        IMSI = 0x401,
        MSISDN = 0x419,
    }

    public enum SimPinStatus
    {
        PIN_REQUIRED,
        PUK_REQUIRED,
        PIN_VERIFIED,
        BAD_PIN,
    }

    public abstract class SimPinStatusBaseMessage : BaseMessage
    {
        public enum PinType
        {
            PIN1 = 0,
            PIN2 = 1,
        }

        public PinType pin_type;
        public string pin;

        private SimPinStatusMessage _message;

        construct
        {
            _message = SimPinStatusMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.pin_type = (uint8) pin_type;

            /* FIXME we currently support only pin's of length 4 */
            Memory.copy(_message.pin, pin.data, 4);
        }
    }

    public class SimVerfiyPinCommandMessage : SimPinStatusBaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0xe;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_VERIFY_PIN, MessageClass.COMMAND);
        }
    }

    public class SimChangePinCommandMessage : SimPinStatusBaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0xf;

        private SimChangePinMessage _message;

        public string old_pin;
        public string new_pin;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_CHANGE_PIN, MessageClass.COMMAND);

            _message = SimChangePinMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            Memory.copy(_message.old_pin, old_pin.data, 4);
            Memory.copy(_message.new_pin, new_pin.data, 4);
        }
    }

    public class SimEnablePinCommandMessage : SimPinStatusBaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x12;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_ENABLE_PIN, MessageClass.COMMAND);
        }
    }

    public class SimDisablePinCommandMessage : SimPinStatusBaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x11;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_DISABLE_PIN, MessageClass.COMMAND);
        }
    }

    public class SimGetSimCapabilitiesCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x2;

        private SimGetSimCapabilitiesMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_GET_SIM_CAPABILITIES, MessageClass.COMMAND);

             _message = SimGetSimCapabilitiesMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class SimGetAllPinStatusInfoCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x1a;

        private SimGetAllPinStatusInfoMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_GET_ALL_PIN_STATUS_INFO, MessageClass.COMMAND);

             _message = SimGetAllPinStatusInfoMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class SimReadCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x3;

        private SimReadMessage _message;

        public SimFileType field_type;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_READ, MessageClass.COMMAND);

            _message = SimReadMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.field_type = (uint16) field_type;
        }
    }

    public class SimGetCallForwardInfoCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0xf;
        public static const uint16 MESSAGE_ID = 0x21;

        private SimGetCallForwardInfoMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_SIM_GET_CALL_FORWARD_INFO, MessageClass.COMMAND);

            _message = SimGetCallForwardInfoMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class SimReturnResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x10;
        public static const uint16 MESSAGE_ID = 0x0;

        private SimReturnResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SIM_RETURN, MessageClass.SOLICITED_RESPONSE);

            _message = SimReturnResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;

            if (_message.rc == 0x101)
            {
                result = MessageResultType.ERROR_UNKNOWN;
            }
        }
    }

    public class SimCallbackResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x10;
        public static const uint16 MESSAGE_ID = 0x1;

        private SimCallbackResponse _message;

        public enum ResponseType
        {
            GET_PIN_STATUS = 0x3f,
            GET_FDN_STATUS = 0xe,
            VERIFY_PIN = 0x8,
            SIM_READ = 0x1
        }

        public ResponseType response_type;

        /* response_type == ResponseType.GET_PIN_STATUS */
        public uint num_pins;
        public uint pin_attempts_remaining;
        public uint puk_attempts_remaining;

        /* response_type == ResponseType.GET_FDN_STATUS */
        public uint usim;

        /* response_type == ResponseType.VERIFY_PIN */
        public SimPinStatus pin_status;

        /* response_type == ResponseType.SIM_READ */
        public SimFileType simfile_type;
        public string simfile_data;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_SIM_CALLBACK, MessageClass.SOLICITED_RESPONSE);

            _message = SimCallbackResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            switch ( _message.rc )
            {
                case 0x0:
                    result = MessageResultType.RESULT_OK;
                    break;
                case 0x5:
                    result = MessageResultType.ERROR_BAD_PIN;
                    break;
                default:
                    theLogger.error( @"Found unhandled sim result type: 0x%02x".printf( _message.rc ) );
                    break;
            }


            ref_id = _message.ref_id;
            simfile_data = "";

            switch ( _message.response_type )
            {
                case ResponseType.GET_PIN_STATUS:
                    num_pins = _message.sim_pin_status_resp.pin_count;
                    break;

                case ResponseType.GET_FDN_STATUS:
                    usim = _message.sim_get_fdn_status_resp.usim;
                    break;

                case ResponseType.VERIFY_PIN:
                    if ( _message.sim_verify_pin_resp.sw1 == 0x90 &&
                         _message.sim_verify_pin_resp.sw2 == 0x0 )
                    {
                        pin_status = SimPinStatus.PIN_VERIFIED;
                    }
                    else if ( _message.sim_verify_pin_resp.sw1 == 0x98 &&
                              _message.sim_verify_pin_resp.sw2 == 0x4 )
                    {
                        pin_status = SimPinStatus.BAD_PIN;
                    }
                    break;

                case ResponseType.SIM_READ:
                    var file_type = (SimFileType) _message.sim_read_resp.file_type;

                    switch ( file_type )
                    {
                        case SimFileType.IMSI:
                            var sb = new StringBuilder();

                            if ( _message.sim_read_resp.file_data_len == 0 )
                            {
                                theLogger.error( @"Detected sim file type with data = NULL; file_type = $(file_type)" );
                                break;
                            }

                            // two IMSI bytes are packed into one byte, we make here two
                            // bytes out of it!
                            sb.append("%i".printf(_message.sim_read_resp.file_data[0] >> 4));
                            for (var n = 1; n < _message.sim_read_resp.file_data.length; n++)
                            {
                                sb.append("%i".printf(_message.sim_read_resp.file_data[n] & 0xf));
                                sb.append("%i".printf((_message.sim_read_resp.file_data[n] & 0xf0) >> 4));
                            }

                            simfile_data = sb.str;
                            break;
                        default:
                            theLogger.error( "Found unknown sim file type: 0x%02x".printf( _message.sim_read_resp.file_type ) );
                            break;
                    }
                    break;

                default:
                    theLogger.error( "Found unknown sim callback response type: 0x%02x".printf(_message.response_type ) );
                    break;
            }
        }
    }

    public class SimUnsolicitedResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x11;

        construct
        {
            message_class = MessageClass.UNSOLICITED_RESPONSE;
            set_payload(new uint8[0]);
        }
    }

}

