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

    public Commands( ref Msmcomm.Context context )
    {
        msm = context;
        map = new Gee.HashMap<string,CommandHolder>();

        register( "help", help, "Show all known commands with their syntax" );
        register( "quit", () => { loop.quit(); }, "Quit this program" );
        register( "get_imei", get_imei, "Receive IMEI" );
        register( "get_firmware_info", get_firmware_info, "Get firmware info string" );
        register( "change_operation_mode", change_operation_mode, "Change operation mode", "change_operation_mode <reset|online|offline>", 1 );
        register( "get_phone_state_info", get_phone_state_info, "Query current phone state" );
        register( "test_alive", test_alive, "Test, if the modem is still responding to commands" );
        register( "verify_pin", verify_pin, "Send SIM PIN authentication code", "verify_pin <pin>" );
        register( "get_charger_status", get_charger_status, "Query current charging status" );
        register( "charge_usb", charge_usb, "Set the usb charging mode:\n\tvoltage: 0=250mA, 1=500mA, 2=1A", "charge_usb <voltage>", 1 );
    }

    private void register( string cmdname, CmdFunc func, string help, string? syntax = null, uint args = 0 )
    {
        map[cmdname] = new CommandHolder( func, help, syntax ?? cmdname, args );
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
            MSG( @"$(cmd.syntax): $(cmd.help)" );
        }
    }

    private void get_imei( string[] params )
    {
        ERR( "Not Yet Implemented" );
    }

    private void get_firmware_info( string[] params )
    {
    }

    private void change_operation_mode( string[] params )
    {
    }

    private void get_phone_state_info( string[] params )
    {
    }

    private void test_alive( string[] params )
    {
    }

    private void verify_pin( string[] params )
    {
    }

    private void get_charger_status( string[] params )
    {
    }

    private void charge_usb( string[] params )
    {
    }

}
