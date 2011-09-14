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

namespace Msmcomm.Daemon
{
    public ChargerMode convertChargerModeForService(MiscBaseChargingMessage.Mode mode)
    {
        ChargerMode result = ChargerMode.USB;

        switch (mode)
        {
            case MiscBaseChargingMessage.Mode.USB:
                result = ChargerMode.USB;
                break;
            case MiscBaseChargingMessage.Mode.INDUCTIVE:
                result = ChargerMode.INDUCTIVE;
                break;
        }

        return result;
    }

    public MiscBaseChargingMessage.Mode convertChargerModeForModem(ChargerMode mode)
    {
        MiscBaseChargingMessage.Mode result = MiscBaseChargingMessage.Mode.USB;

        switch (mode)
        {
            case ChargerMode.USB:
                result = MiscBaseChargingMessage.Mode.USB;
                break;
            case ChargerMode.INDUCTIVE:
                result = MiscBaseChargingMessage.Mode.INDUCTIVE;
                break;
        }

        return result;
    }

    public MiscBaseChargingMessage.Voltage convertVoltageForModem(ChargerVoltage voltage)
    {
        MiscBaseChargingMessage.Voltage result = MiscBaseChargingMessage.Voltage.VOLTAGE_250mA;

        switch (voltage)
        {
            case ChargerVoltage.VOLTAGE_250mA:
                result = MiscBaseChargingMessage.Voltage.VOLTAGE_250mA;
                break;
            case ChargerVoltage.VOLTAGE_500mA:
                result = MiscBaseChargingMessage.Voltage.VOLTAGE_500mA;
                break;
            case ChargerVoltage.VOLTAGE_1000mA:
                result = MiscBaseChargingMessage.Voltage.VOLTAGE_1000mA;
                break;
        }

        return result;
    }

    public ChargerVoltage convertVoltageForService(MiscBaseChargingMessage.Voltage voltage)
    {
        ChargerVoltage result = ChargerVoltage.VOLTAGE_250mA;

        switch (voltage)
        {
            case MiscBaseChargingMessage.Voltage.VOLTAGE_250mA:
                result = ChargerVoltage.VOLTAGE_250mA;
                break;
            case MiscBaseChargingMessage.Voltage.VOLTAGE_500mA:
                result = ChargerVoltage.VOLTAGE_500mA;
                break;
            case MiscBaseChargingMessage.Voltage.VOLTAGE_1000mA:
                result = ChargerVoltage.VOLTAGE_1000mA;
                break;
        }

        return result;
    }

    public TimeSource convertTimeSourceForService(MiscSetDateCommandMessage.TimeSource time_source)
    {
        TimeSource result = TimeSource.MANUAL;

        switch (time_source)
        {
            case MiscSetDateCommandMessage.TimeSource.MANUAL:
                result = TimeSource.MANUAL;
                break;
            case MiscSetDateCommandMessage.TimeSource.NETWORK:
                result = TimeSource.NETWORK;
                break;
        }

        return result;
    }

    public MiscSetDateCommandMessage.TimeSource convertTimeSourceForModem(TimeSource time_source)
    {
        MiscSetDateCommandMessage.TimeSource result = MiscSetDateCommandMessage.TimeSource.MANUAL;

        switch (time_source)
        {
            case TimeSource.MANUAL:
                result = MiscSetDateCommandMessage.TimeSource.MANUAL;
                break;
            case TimeSource.NETWORK:
                result = MiscSetDateCommandMessage.TimeSource.NETWORK;
                break;
        }

        return result;
    }

    public SimPinStatusBaseMessage.PinType convertSimPinTypeForModem(SimPinType pin_type)
    {
        SimPinStatusBaseMessage.PinType result = SimPinStatusBaseMessage.PinType.PIN1;

        switch (pin_type)
        {
            case SimPinType.PIN1:
                result = SimPinStatusBaseMessage.PinType.PIN1;
                break;
            case SimPinType.PIN2:
                result = SimPinStatusBaseMessage.PinType.PIN2;
                break;
        }

        return result;
    }

#if 0
    public LowLevel.SimFieldType convertSimFieldTypeForModem(SimFieldType field_type)
    {
        LowLevel.SimFieldType result = LowLevel.SimFieldType.IMSI;

        switch (field_type)
        {
            case SimFieldType.IMSI:
                result = LowLevel.SimFieldType.IMSI;
                break;
            case SimFieldType.MSISDN:
                result = LowLevel.SimFieldType.MSISDN;
                break;
        }

        return result;
    }

    public SimFieldType convertSimFieldTypeForService(LowLevel.SimFieldType field_type)
    {
        SimFieldType result = SimFieldType.IMSI;

        switch (field_type)
        {
            case LowLevel.SimFieldType.IMSI:
                result = SimFieldType.IMSI;
                break;
            case LowLevel.SimFieldType.MSISDN:
                result = SimFieldType.MSISDN;
                break;
        }

        return result;
    }
#endif

    public CallType convertCallTypeForService(CallBaseMessage.Type call_type)
    {
        CallType result = CallType.DATA;

        switch (call_type)
        {
            case CallBaseMessage.Type.DATA:
                result = CallType.DATA;
                break;
            case CallBaseMessage.Type.AUDIO:
                result = CallType.AUDIO;
                break;
        }

        return result;
    }
}
