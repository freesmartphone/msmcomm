/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
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

using GLib;

namespace Msmcomm
{
    public abstract class BaseCommand
    {
        public ModemChannel channel { get; set; }

        public abstract async void run() throws Msmcomm.Error;

        protected void checkResponse(Msmcomm.Message response) throws Msmcomm.Error
        {
            if (response.result != Msmcomm.ResultType.OK)
            {
                var msg = @"$(messageTypeToString(response.type)) command failed with: $(resultTypeToString(response.result))";
                throw new Msmcomm.Error.FAILED(msg);
            }
        }
    }

    public class ChangeOperationModeCommand : BaseCommand
    {
        public ModemOperationMode mode { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.ChangeOperationMode();

            switch (mode)
            {
                case ModemOperationMode.OFFLINE:
                    cmd.mode = Msmcomm.OperationMode.OFFLINE;
                    break;
                case ModemOperationMode.ONLINE:
                    cmd.mode = Msmcomm.OperationMode.ONLINE;
                    break;
                default:
                    var msg = "Invalid argument supplied for mode parameter for ChangeOperationMode command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class ResetCommand : BaseCommand
    {
        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.ChangeOperationMode();
            cmd.mode = Msmcomm.OperationMode.RESET;

            // NOTE We send the reset command without waiting for it's response
            // as we do not ever get one. The user have to wait for the
            // reset_radio_ind event to notify when the reset is done.
            channel.enqueueSync((owned) cmd);
        }
    }

    public class TestAliveCommand : BaseCommand
    {
        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.TestAlive();
            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class GetImeiCommand : BaseCommand
    {
        public string imei { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetImei();
            unowned Msmcomm.Reply.GetImei response = (Msmcomm.Reply.GetImei) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            imei = response.imei;
        }
    }

    public class GetFirmwareInfoCommand : BaseCommand
    {
        public FirmwareInfo result { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetFirmwareInfo();
            unowned Msmcomm.Reply.GetFirmwareInfo response = (Msmcomm.Reply.GetFirmwareInfo)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            result = FirmwareInfo(response.info, response.hci);
        }
    }

    public class ChargingCommand : BaseCommand
    {
        public ChargerStatusMode mode { get; set; }
        public ChargerStatusVoltage voltage { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.Charging();
            var msg = "";

            switch (mode)
            {
                case ChargerStatusMode.USB:
                    cmd.mode = Msmcomm.ChargingMode.USB;
                    break;
                case ChargerStatusMode.INDUCTIVE:
                    cmd.mode = Msmcomm.ChargingMode.INDUCTIVE;
                    break;
                default:
                    msg = "Invalid argument supplied for mode parameter for Charging command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            switch (voltage)
            {
                case ChargerStatusVoltage.VOLTAGE_250mA:
                    cmd.voltage = Msmcomm.UsbVoltageMode.MODE_250mA;
                    break;
                case ChargerStatusVoltage.VOLTAGE_500mA:
                    cmd.voltage = Msmcomm.UsbVoltageMode.MODE_500mA;
                    break;
                case ChargerStatusVoltage.VOLTAGE_1A:
                    cmd.voltage = Msmcomm.UsbVoltageMode.MODE_1A;
                    break;
                default:
                    msg = "Invalid argument supplied for voltage parameter for Charging command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            unowned Msmcomm.Reply.Charging response = (Msmcomm.Reply.Charging)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class GetChargerStatusCommand : BaseCommand
    {
        // OUT
        public ChargerStatus result;

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetChargerStatus();
            unowned Msmcomm.Reply.ChargerStatus response = (Msmcomm.Reply.ChargerStatus)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            switch (response.mode)
            {
                case Msmcomm.ChargingMode.USB:
                    result.mode = ChargerStatusMode.USB;
                    break;
                case Msmcomm.ChargingMode.INDUCTIVE:
                    result.mode = ChargerStatusMode.INDUCTIVE;
                    break;
                default:
                    result.mode = ChargerStatusMode.UNKNOWN;
                    break;
            }

            switch (response.voltage)
            {
                case Msmcomm.UsbVoltageMode.MODE_250mA:
                    result.voltage = ChargerStatusVoltage.VOLTAGE_250mA;
                    break;
                case Msmcomm.UsbVoltageMode.MODE_500mA:
                    result.voltage = ChargerStatusVoltage.VOLTAGE_500mA;
                    break;
                case Msmcomm.UsbVoltageMode.MODE_1A:
                    result.voltage = ChargerStatusVoltage.VOLTAGE_1A;
                    break;
                default:
                    result.voltage = ChargerStatusVoltage.VOLTAGE_UNKNOWN;;
                    break;
            }
        }
    }

    public class GetPhoneStateInfoCommand : BaseCommand
    {
        public PhoneStateInfo result;

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetPhoneStateInfo();
            // FIXME find the right response!
            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);

            result = PhoneStateInfo(0);
        }
    }

    public class VerifyPinCommand : BaseCommand
    {
        public string pin { get; set; }
        public string pin_type { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.VerifyPin();

            switch (pin_type)
            {
                case "pin1":
                    cmd.pin_type = Msmcomm.SimPinType.PIN_1;
                    break;
                case "pin2":
                    cmd.pin_type = Msmcomm.SimPinType.PIN_2;
                    break;
                default:
                    var msg = "Invalid argument supplied for pin_type parameter for VerifyPin command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            cmd.pin = pin;

            unowned Msmcomm.Reply.GsdiCallback response = (Msmcomm.Reply.GsdiCallback) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public abstract class AbstractCallCommand : BaseCommand
    {
        protected void checkCallId(int call_id) throws Msmcomm.Error
        {
            if (call_id < 0 || call_id > uint8.MAX)
            {
                var msg = "Invalid argument supplied for call_id parameter for EndCall command";
                throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }
        }
    }

    public class EndCallCommand : AbstractCallCommand
    {
        public int call_id { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.EndCall();

            checkCallId(call_id);
            cmd.call_id = (uint8) call_id;

            unowned Msmcomm.Reply.CallCallback response = (Msmcomm.Reply.CallCallback) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class AnswerCallCommand : AbstractCallCommand
    {
        public int call_id { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.AnswerCall();

            checkCallId(call_id);
            cmd.call_id = (uint8) call_id;

            unowned Msmcomm.Reply.CallCallback response = (Msmcomm.Reply.CallCallback) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class OriginateCallCommand : AbstractCallCommand
    {
        public string number { get; set; }
        public bool block { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.OriginateCall();
            cmd.number = number;
            cmd.block = block;

            unowned Msmcomm.Reply.CallCallback response = (Msmcomm.Reply.CallCallback) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class ManageCallsCommand : AbstractCallCommand
    {
        public CallCommandType command_type { get; set; default = CallCommandType.INVALID; }
        public int call_id { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.SupsCall();

            checkCallId(call_id);
            cmd.call_id = (uint8) call_id;

            switch (command_type)
            {
                case CallCommandType.DROP_ALL_OR_SEND_BUSY:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.DROP_ALL_OR_SEND_BUSY;
                    break;
                case CallCommandType.DROP_ALL_AND_ACCEPT_WAITING_OR_HELD:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.DROP_ALL_OR_SEND_BUSY;
                    break;
                case CallCommandType.DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.DROP_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD;
                    break;
                case CallCommandType.HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.HOLD_ALL_AND_ACCEPT_WAITING_OR_HELD;
                    break;
                case CallCommandType.HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.HOLD_SPECIFIC_AND_ACCEPT_WAITING_OR_HELD;
                    break;
                case CallCommandType.ACTIVATE_HELD:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.ACTIVATE_HELD;
                    break;
                case CallCommandType.DROP_SELF_AND_CONNECT_ACTIVE:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.DROP_SELF_AND_CONNECT_ACTIVE;
                    break;
                default:
                    cmd.command_type = Msmcomm.Command.SupsCall.CommandType.INVALID;
                    break;
            }

            unowned Msmcomm.Reply.CallCallback response = (Msmcomm.Reply.CallCallback) (yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class SetSystemTimeCommand : BaseCommand
    {
        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public int hours { get; set; }
        public int minutes { get; set; }
        public int seconds { get; set; }
        public int timezone_offset { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.SetSystemTime();

            cmd.setData(year, month, day, hours, minutes, seconds, timezone_offset);

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class RssiStatusCommand : BaseCommand
    {
        public bool status { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.RssiStatus();

            cmd.status = status;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public abstract class BasePhonebookCommand : BaseCommand
    {

    }

    public class ReadPhonebookCommand : BasePhonebookCommand
    {
        // IN
        public PhonebookBookType book_type { get; set; }
        public uint8 position { get; set; }

        // OUT
        public PhonebookEntry result { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.ReadPhonebook();

            cmd.book_type = convertPhonebookBookType(book_type);
            cmd.position = position;

            unowned Msmcomm.Reply.Phonebook response = (Msmcomm.Reply.Phonebook)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            result = PhonebookEntry(convertPhonebookType(response.book_type),
                                    response.position,
                                    response.number,
                                    response.title,
                                    encodingTypeToString(response.encoding_type));
        }
    }

    public class WritePhonebookCommand : BasePhonebookCommand
    {
        // IN
        public PhonebookBookType book_type { get; set; }
        public string number { get; set; }
        public string title { get; set; }

        // OUT
        public int modify_id { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.WritePhonebook();

            cmd.book_type = convertPhonebookBookType(book_type);
            cmd.number = number;
            cmd.title = title;

            unowned Msmcomm.Reply.Phonebook response = (Msmcomm.Reply.Phonebook)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            modify_id = response.modify_id;
        }
    }

    public class DeletePhonebookCommand : BasePhonebookCommand
    {
        public PhonebookBookType book_type { get; set; }
        public uint8 position { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.DeletePhonebook();

            cmd.book_type = convertPhonebookBookType(book_type);
            cmd.position = position;

            unowned Msmcomm.Reply.Phonebook response = (Msmcomm.Reply.Phonebook)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);
        }
    }

    public class GetPhonebookPropertiesCommand : BasePhonebookCommand
    {
        // IN
        public PhonebookBookType book_type { get; set; }

        // OUT
        public PhonebookProperties result { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetPhonebookProperties();

            cmd.book_type = convertPhonebookBookType(book_type);

            unowned Msmcomm.Reply.GetPhonebookProperties response = (Msmcomm.Reply.GetPhonebookProperties)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            result = PhonebookProperties(response.slot_count,
                                         response.slots_used,
                                         response.max_chars_per_title,
                                         response.max_chars_per_number);
        }
    }

    public class GetNetworkListCommand : BaseCommand
    {
        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetNetworkList();
            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class SetModePreferenceCommand : BaseCommand
    {
        public string mode { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.SetModePreference();

            switch (mode)
            {
                case "auto":
                    cmd.mode = Msmcomm.NetworkMode.AUTOMATIC;
                    break;
                case "gsm":
                    cmd.mode = Msmcomm.NetworkMode.GSM;
                    break;
                case "umts":
                    cmd.mode = Msmcomm.NetworkMode.UMTS;
                    break;
                default:
                    var msg = "Invalid argument supplied for mode parameter for SetModePreference command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class ChangePinCommand : BaseCommand
    {
        public string old_pin { get; set; }
        public string new_pin { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.ChangePin();

            cmd.old_pin = old_pin;
            cmd.new_pin = new_pin;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class EnablePinCommand : BaseCommand
    {
        public string pin { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.EnablePin();

            cmd.pin = pin;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class DisablePinCommand : BaseCommand
    {
        public string pin { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.DisablePin();

             cmd.pin = pin;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class SimInfoCommand : BaseCommand
    {
        // IN
        public string field_type { get; set; }

        // OUT
        public string field_data { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.SimInfo();

            switch (field_type)
            {
                case "imsi":
                    cmd.field_type = Msmcomm.SimInfoFieldType.IMSI;
                    break;
                case "msisdn":
                    cmd.field_type = Msmcomm.SimInfoFieldType.MSISDN;
                    break;
                default:
                    var msg = "Invalid argument supplied for field_type parameter for SimInfo command";
                    throw new Msmcomm.Error.INVALID_ARGUMENTS(msg);
            }

            unowned Msmcomm.Reply.GsdiCallback response = (Msmcomm.Reply.GsdiCallback)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            field_data = response.field_data;
        }
    }

    public class GetAudioModemTuningParamsCommand : BaseCommand
    {
        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetAudioModemTuningParams();
            unowned Msmcomm.Reply.AudioModemTuningParams response = (Msmcomm.Reply.AudioModemTuningParams)(yield channel.enqueueAsync((owned) cmd));
            checkResponse(response);

            // FIXME handle result ...
        }
    }

    public class SetAudioProfileCommand : BaseCommand
    {
        public uint8 class { get; set; }
        public uint8 sub_class { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.SetAudioProfile();

            cmd.class = class;
            cmd.sub_class = sub_class;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class GetAllPinStatusInfoCommand : BaseCommand
    {
        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.GetAllPinStatusInfo();

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }

    public class ReadTemplateCommand : BaseCommand
    {
        public TemplateType template_type { get; set; }

        public override async void run() throws Msmcomm.Error
        {
            var cmd = new Msmcomm.Command.ReadTemplate();
            var tt = Msmcomm.Command.ReadTemplate.TemplateType.INVALID;

            switch (template_type)
            {
                case Msmcomm.TemplateType.SMSC_ADDRESS:
                    tt = Msmcomm.Command.ReadTemplate.TemplateType.SMSC_ADDRESS;
                    break;
                case Msmcomm.TemplateType.EMAIL_ADDRESS:
                    tt = Msmcomm.Command.ReadTemplate.TemplateType.EMAIL_ADDRESS;
                    break;
                default:
                    throw new Msmcomm.Error.INVALID_ARGUMENTS("Invalid arguments supplied for ReadTemplate command");
            }

            cmd.template = tt;

            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }
}

