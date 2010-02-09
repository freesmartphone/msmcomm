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

    public Commands()
    {
        map = new Gee.HashMap<string,CommandHolder>();
        register( "help", cmd_help, "Show all known commands with their syntax", "help <cmd>", 0 );
        register( "quit", () => { loop.quit(); }, "Quit this program", "quit" );
    }

    private void register( string cmdname, CmdFunc func, string help, string syntax, uint args = 0 )
    {
        MSG( @"(registering command $cmdname)" );
        map[cmdname] = new CommandHolder( func, help, syntax, args );
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

    public void cmd_help( string[] params )
    {
        MSG( "This program supports the following commands:\n" );
        foreach ( var cmd in map.values )
        {
            MSG( @"$(cmd.syntax): $(cmd.help)" );
        }
    }
}
