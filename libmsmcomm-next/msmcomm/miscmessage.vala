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
    public class MiscTestAliveCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0x1;

        private MiscTestAliveMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_TEST_ALIVE, MessageClass.COMMAND);

            _message = MiscTestAliveMessage();
            set_payload(_message.data);

        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class MiscTestAliveResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0x2;

        private MiscTestAliveMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_MISC_TEST_ALIVE, MessageClass.SOLICITED_RESPONSE);

            _message = MiscTestAliveMessage();
            set_payload(_message.data);

        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
        }
    }

    public class MiscGetRadioFirmwareVersionCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0x9;

        private MiscGetRadioFirmwareVersionMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_GET_RADIO_FIRMWARE_VERSION, MessageClass.COMMAND);

            _message = MiscGetRadioFirmwareVersionMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class MiscGetRadioFirmwareVersionResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0xa;

        public uint8 carrier_id;
        public string firmware_version;

        private static const int FWVERSION_STRING_LENGTH = 20;

        private MiscGetRadioFirmwareVersionResponse _message;

        construct 
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_MISC_GET_RADIO_FIRMWARE_VERSION, MessageClass.SOLICITED_RESPONSE);

            _message = MiscGetRadioFirmwareVersionResponse();
            set_payload(_message.data);
        }

        public override void evaluate_data()
        {
            carrier_id = _message.carrier_id;

            string *tmp = GLib.malloc0(FWVERSION_STRING_LENGTH);
            char *dest = (char*) tmp;
            Memory.copy(dest, _message.firmware_version, FWVERSION_STRING_LENGTH);
            firmware_version = (owned) tmp;
        }
    }

    public abstract class MiscBaseChargingMessage : BaseMessage
    {
        public enum Mode
        {
            USB = 1,
            INDUCTIVE = 2,
        }

        public enum Voltage
        {
            VOLTAGE_250mA = 250,
            VOLTAGE_500mA = 500,
            VOLTAGE_1000mA = 1000,
        }

        public Mode mode;
        public Voltage voltage;
    }

    public class MiscGetChargerStatusCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0x15;

        private MiscGetChargerStatusMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_GET_CHARGER_STATUS, MessageClass.COMMAND);

            _message = MiscGetChargerStatusMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class MiscGetChargerStatusResponseMessage : MiscBaseChargingMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0x16;

        private MiscGetChargerStatusMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_GET_CHARGER_STATUS, MessageClass.COMMAND);

            _message = MiscGetChargerStatusMessage();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            mode = (MiscBaseChargingMessage.Mode) _message.mode;
            voltage = (MiscBaseChargingMessage.Voltage) _message.voltage;
            // FIXME check return code for result
        }
    }

    public class MiscSetChargeCommandMessage : MiscBaseChargingMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0x13;

        private MiscSetChargeMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_SET_CHARGE, MessageClass.COMMAND);

            _message = MiscSetChargeMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
            _message.mode = (uint8) mode;
            _message.voltage = (uint16) voltage;
        }
    }

    public class MiscSetChargeResponseMessage : MiscBaseChargingMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0x16;

        private MiscSetChargeMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_MISC_SET_CHARGE, MessageClass.SOLICITED_RESPONSE);

            _message = MiscSetChargeMessage();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            mode = (MiscBaseChargingMessage.Mode) _message.mode;
            voltage = (MiscBaseChargingMessage.Voltage) _message.voltage;
        }
    }

    public class MiscSetDateCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0xe;

        public enum TimeSource 
        {
            AUTO = 1,
            MANUAL = 3,
        }

        public uint8 year;
        public uint8 month;
        public uint8 day;
        public uint8 hour;
        public uint8 minutes;
        public uint8 seconds;
        public uint8 timezone_offset;
        public TimeSource time_source;

        private MiscSetDateMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_SET_DATE, MessageClass.COMMAND);

            _message = MiscSetDateMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;

            _message.year = year;
            _message.month = month;
            _message.day = day;
            _message.hour = hour;
            _message.minutes = minutes;
            _message.seconds = seconds;
            _message.timezone_offset = timezone_offset;
            _message.time_source = (uint8) time_source;
        }
    }

    public class MiscSetDateResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0xf;

        private MiscSetDateResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_MISC_SET_DATE, MessageClass.SOLICITED_RESPONSE);

            _message = MiscSetDateResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;
            // FIXME check return code of the message
        }
    }

    public class MiscGetImeiCommandMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1b;
        public static const uint16 MESSAGE_ID = 0x8;

        private MiscGetImeiMessage _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.COMMAND_MISC_GET_IMEI, MessageClass.COMMAND);

            _message = MiscGetImeiMessage();
            set_payload(_message.data);
        }

        protected override void prepare_data()
        {
            _message.ref_id = ref_id;
        }
    }

    public class MiscGetImeiResponseMessage : BaseMessage
    {
        public static const uint8 GROUP_ID = 0x1c;
        public static const uint16 MESSAGE_ID = 0x9;

        public string imei;

        private static const int IMEI_STRING_LENGTH = 17;
        private MiscGetImeiResponse _message;

        construct
        {
            set_description(GROUP_ID, MESSAGE_ID, MessageType.RESPONSE_MISC_GET_IMEI, MessageClass.SOLICITED_RESPONSE);

            _message = MiscGetImeiResponse();
            set_payload(_message.data);
        }

        protected override void evaluate_data()
        {
            ref_id = _message.ref_id;

            imei = "";
            for(int i=0; i < IMEI_STRING_LENGTH; i++)
            {
                imei += "%i".printf(_message.imei[i]);
            }
        }
    }
}
