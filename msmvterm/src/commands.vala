/**
 * This file is part of msmvterm.
 *
 * (C) 2009-2010 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
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

public delegate void CmdFunc( string[] params );

public class CommandHolder
{
    public CmdFunc func;
    public string syntax;
    public string help;
    public uint args;

    public CommandHolder( CmdFunc func, string help, string syntax, uint args )
    {
        this.func = func;
        this.help = help;
        this.syntax = syntax;
        this.args = args;
    }
}

public static void ERR( string msg )
{
    stdout.printf( @"[ERR] $msg\n" );
}

public static void MSG( string msg )
{
    stdout.printf( @"$msg\n" );
}

public class Commands
{
    private Gee.HashMap<string,CommandHolder> map;
    private unowned Msmcomm.Context msm;
    private uint8 ref_id_counter;

    public Commands( ref Msmcomm.Context context )
    {
        msm = context;
        map = new Gee.HashMap<string,CommandHolder>();

        ref_id_counter = 0;

        register( "help", help, "Show all known commands with their syntax" );
        register( "quit", () => { loop.quit(); }, "Quit this program" );
        register( "get_imei", get_imei, "Receive IMEI" );
        register( "get_firmware_info", get_firmware_info, "Get firmware info string" );
        register( "change_operation_mode", change_operation_mode, "Change operation mode", "change_operation_mode <reset|online|offline>", 1 );
        register( "get_phone_state_info", get_phone_state_info, "Query current phone state" );
        register( "test_alive", test_alive, "Test, if the modem is still responding to commands" );
        register( "verify_pin", verify_pin, "Send SIM PIN authentication code", "verify_pin <pin1|pin2> <pin>", 2 );
        register( "get_charger_status", get_charger_status, "Query current charging status" );
        register( "charging", charging, "Set charging mode:\n\tmode: usb, inductive\n\tvoltage: 250mA, 500mA, 1A (warning!)", "charging <usb|inductive> <250|500|1000>", 2 );
        register( "dial_call", dial_call, "Dial out", "dial <number>", 1 );
        register( "answer_call", answer_call, "Answer an incomming call", "answer_call <call_nr>", 1 );
        register( "end_call", end_call, "End an active call", "end_call <call_nr>", 1 );
        register( "set_system_time", set_system_time, "Set system time for modem","set_system_time <year> <month> <day> <hour> <minutes> <seconds> <timezone_offset>", 7 );
		register( "rssi_status", rssi_status, "Enable/disable rssi status updates", "rssi_status <0|1>", 1 );
		register( "read_phonebook", read_phonebook, "Read entries from phonebook (stored on the SIM card)", "read_phonebook <mbdn|efecc|adn|fdn|spn> <position>", 2 );
		register( "write_phonebook", write_phonebook, "Write an entry to the phonebook (stored on the SIM card)", "write_phonebook <mbdn|efecc|adn|fdn|spn> \"<title>\" \"<number>\"", 3 );
        register( "delete_phonebook", delete_phonebook, "Deletes an entry from the phonebook (stored on the SIM card)", "delete_phonebook <mbdn|efecc|adn|fdn|spn> <position>", 2 );
        register( "get_networklist", get_networklist, "Request a list with all available networks");
		register( "set_mode_preference", set_mode_preference, "Set the prefered mode for the network (Automatic, GSM, UMTS)", "set_mode_preference <auto|gsm|umts>", 1 );
		register( "get_phonebook_properties", get_phonebook_properties, "Get the properties of a phonebook type", "get_phonebook_properties <mbdn|efecc|adn|fdn|spn>", 1 );
        register( "change_pin", change_pin, "Change the pin of your SIM card", "change_pin <old pin> <new pin>", 2 );
        register( "pin_status", pin_status, "Enable/Disable pin authentication", "pin_status <0|1> <pin>", 2 );
        register( "sim_info", sim_info, "Gather information from the SIM card", "sim_info <imsi|msisdn>", 1 );
    }

    private uint8 nextValidRefId()
    {
        ref_id_counter += 1;
        return ref_id_counter;
    }

    private void register( string cmdname, CmdFunc func, string help, string? syntax = null, uint args = 0 )
    {
        map[cmdname] = new CommandHolder( func, help, syntax ?? cmdname, args );
    }

    public List<string> commandsWithPrefix( string prefix = "" )
    {
        var list = new List<string>();
        foreach ( var name in map.keys )
        {
            if ( name.has_prefix( prefix ) )
            {
                list.append( name );
            }
        }
        return list;
    }

    public void dispatch( string line )
    {
        var components = line.split( " " );

        var holder = map[ components[0] ];
        if ( holder == null )
        {
            ERR( @"Command $(components[0]) unknown. Use help to see a list of commands" );
            return;
        }

        if ( components.length-1 < holder.args )
        {
            ERR( @"Command $(components[0]) needs at minimum $(holder.args) arguments" );
            return;
        }

        holder.func( components[1:components.length-2] );
    }

    //
    // commands here
    //

    private void help( string[] params )
    {
        MSG( "This program supports the following commands:\n" );
        foreach ( var cmd in map.values )
        {
            var syntax = cmd.syntax;
            while ( syntax.length < 50 )
                syntax += " ";
            MSG( @"$syntax: $(cmd.help)" );
        }
    }

    private void get_imei( string[] params )
    {
        var msg = new Msmcomm.Command.GetImei();
        msg.index = nextValidRefId();
        msm.sendMessage( msg );
    }

    private void get_firmware_info( string[] params )
    {
        var msg = new Msmcomm.Command.GetFirmwareInfo();
        msg.index = nextValidRefId();
        msm.sendMessage( msg );
    }

    private void change_operation_mode( string[] params )
    {
        var msg = new Msmcomm.Command.ChangeOperationMode();
        msg.index = nextValidRefId();

        switch ( params[0] )
        {
            case "reset":
                msg.setOperationMode( Msmcomm.OperationMode.RESET );
                break;
            case "online":
                msg.setOperationMode( Msmcomm.OperationMode.ONLINE );
                break;
            case "offline":
                msg.setOperationMode( Msmcomm.OperationMode.OFFLINE );
                break;
            default:
                ERR( @"Unknown operation mode $(params[0])" );
                return;
        }
        msm.sendMessage( msg );
    }

    private void get_phone_state_info( string[] params )
    {
        //var msg = new Msmcomm.Command.GetPhoneStateInfo();
        //msg.sendMessage( msg );
        ERR( "Not Yet Implemented" );
    }

    private void test_alive( string[] params )
    {
        var msg = new Msmcomm.Command.TestAlive();
        msg.index = nextValidRefId();
        msm.sendMessage( msg );
    }

    private void verify_pin( string[] params )
    {
        var msg = new Msmcomm.Command.VerifyPin();
        msg.index = nextValidRefId();
        
        switch ( params[0] )
        {
            case "pin1":
                msg.pin_type = Msmcomm.SimPinType.PIN_1;
                break;
            case "pin2":
                msg.pin_type = Msmcomm.SimPinType.PIN_2;
                break;
            default:
                ERR( @"Unknown pin type $(params[0])" );
                return;
        }
        msg.pin = params[1];
        msm.sendMessage( msg );
    }

    private void get_charger_status( string[] params )
    {
        var msg = new Msmcomm.Command.GetChargerStatus();
        msg.index = nextValidRefId();
        msm.sendMessage( msg );
    }

    private void charging( string[] params )
    {
        var msg = new Msmcomm.Command.Charging();
        msg.index = nextValidRefId();

        switch ( params[0] )
        {
            case "usb":
                msg.mode = Msmcomm.ChargingMode.USB;
                switch ( params[1] )
                {
                    case "250":
                        msg.voltage = Msmcomm.UsbVoltageMode.MODE_250mA;
                        break;
                    case "500":
                        msg.voltage = Msmcomm.UsbVoltageMode.MODE_500mA;
                        break;
                    case "1000":
                        msg.voltage = Msmcomm.UsbVoltageMode.MODE_1A;
                        break;
                    default:
                        ERR( @"Unknown voltage $(params[1])" );
                        return;
                }
                break;
            case "inductive":
                msg.mode = Msmcomm.ChargingMode.INDUCTIVE;
                break;
            default:
                ERR( @"Unknown charging mode $(params[0])" );
                return;
        }

        msm.sendMessage( msg );
    }

    private void dial_call( string[] params )
    {
        var msg = new Msmcomm.Command.DialCall();
        msg.index = nextValidRefId();
        msg.setCallerId(params[0]);
        msm.sendMessage ( msg );
    }

    private void answer_call( string[] params )
    {
        var msg = new Msmcomm.Command.AnswerCall();
        msg.index = nextValidRefId();
    
        msg.call_id = (uint8)params[0].to_int();
        
        msm.sendMessage(msg);
    }

    private void end_call( string[] params )
    {
        var msg = new Msmcomm.Command.EndCall();
        msg.index = nextValidRefId();
        var id = params[0].to_int();
        if ( id < 0 || id > 10 )
        {
            ERR( @"Invalid call index $(params[0]), must be 0 <= x <= 10 )" );
            return;
        }
        msg.call_id = (uint8)id;
        msm.sendMessage(msg);
    }

    private void set_system_time( string[] params )
    {
        var msg = new Msmcomm.Command.SetSystemTime();
        msg.index = nextValidRefId();
        msg.setData(params[0].to_int(), params[1].to_int(), params[2].to_int(), params[3].to_int(), params[4].to_int(), params[5].to_int(), params[6].to_int());
        msm.sendMessage(msg);
    }

    private void rssi_status( string[] params )
    {
		var msg = new Msmcomm.Command.RssiStatus();
		msg.index = nextValidRefId();

		int value = params[0].to_int();
		if (value > 0) msg.status = true;
		else msg.status = false;

		msm.sendMessage(msg);
	}
    
    private Msmcomm.PhonebookType stringToPhonebookType( string str )
    {
        Msmcomm.PhonebookType result = Msmcomm.PhonebookType.NONE;
        switch ( str )
        {
            case "mbdn":
                result = Msmcomm.PhonebookType.MBDN;
                break;
			case "efecc":
                result = Msmcomm.PhonebookType.EFECC;
                break;
			case "adn":
                result = Msmcomm.PhonebookType.ADN;
                break;
			case "fdn":
                result = Msmcomm.PhonebookType.FDN;
                break;
			case "sdn":
                result = Msmcomm.PhonebookType.SDN;
                break;
			case "all":
				result = Msmcomm.PhonebookType.ALL;
                break;
            default:
                ERR( @"Unknown phonebook type $(str)" );
                break;
        }
        
        return result;
    }

	private void read_phonebook( string[] params )
	{
		var msg = new Msmcomm.Command.ReadPhonebook();
		msg.index = nextValidRefId();
        msg.book_type = stringToPhonebookType( params[0] );
		msg.position = (uint8)params[1].to_int();
		msm.sendMessage(msg);
	}

	private void get_networklist( string[] params )
	{
		var msg = new Msmcomm.Command.GetNetworkList();
		msg.index = nextValidRefId();
		msm.sendMessage(msg);
	} 

	private void set_mode_preference( string[] params )
    {
        var msg = new Msmcomm.Command.SetModePreference();
        msg.index = nextValidRefId();

        switch ( params[0] )
        {
            case "auto":
                msg.mode = Msmcomm.NetworkMode.AUTOMATIC;
                break;
            case "gsm":
                msg.mode = Msmcomm.NetworkMode.GSM;
                break;
            case "umts":
                msg.mode = Msmcomm.NetworkMode.UMTS;
                break;
            default:
                ERR( @"Unknown network mode $(params[0])" );
                return;
        }
        
        msm.sendMessage( msg );
    }

    private void get_phonebook_properties( string[] params )
    {
		var msg = new Msmcomm.Command.GetPhonebookProperties();
        msg.index = nextValidRefId();
        msg.book_type = stringToPhonebookType( params[0] );

        msm.sendMessage( msg );
	}
    
    private void write_phonebook( string[] params )
	{
		var msg = new Msmcomm.Command.WritePhonebook();
		msg.index = nextValidRefId();
        msg.book_type = stringToPhonebookType( params[0] );
		msg.title = params[1].substring( 1, params[1].length - 2 );
        msg.number = params[2].substring( 1, params[2].length - 2 );
		msm.sendMessage(msg);
	}
    
    private void delete_phonebook( string[] params )
	{
		var msg = new Msmcomm.Command.DeletePhonebook();
		msg.index = nextValidRefId();
        msg.book_type = stringToPhonebookType( params[0] );
		msg.position = (uint8)params[1].to_int();
		msm.sendMessage(msg);
	}
    
    private void change_pin( string[] params )
    {
        var msg = new Msmcomm.Command.ChangePin();
        msg.index = nextValidRefId();
        msg.old_pin = params[0];
        msg.new_pin = params[1];
        msm.sendMessage(msg);
    }
    
    private void pin_status( string[] params )
    {
        switch ( params[0] )
        {
            case "0":
                var msg = new Msmcomm.Command.DisablePin();
                msg.index = nextValidRefId();
                msg.pin = params[1];
                msm.sendMessage(msg);
                break;
            case "1":
                var msg = new Msmcomm.Command.EnablePin();
                msg.index = nextValidRefId();
                msg.pin = params[1];
                msm.sendMessage(msg);
                break;
            default:
                ERR( @"Set known pin_status 0 or 1 and not '$(params[0])'" );
                return;
        }
    }
    
    private void sim_info( string[] params )
    {
        var msg = new Msmcomm.Command.SimInfo();
        msg.index = nextValidRefId();
        
        switch (params[0])
        {
            case "imsi":
                msg.field_type = Msmcomm.SimInfoFieldType.IMSI;
                break;
            case "msisdn":
                msg.field_type = Msmcomm.SimInfoFieldType.MSISDN;
                break;
        }
        
        msm.sendMessage(msg);
    }
}
