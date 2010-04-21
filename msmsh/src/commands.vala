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

namespace Msmcomm
{

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
    private Gee.HashMap<string,CommandHolder> _map;
    private Controller _controller;

    public Commands(Controller controller)
    {
        _map = new Gee.HashMap<string,CommandHolder>();
        _controller = controller;

        register("help", help, "List all available commands");
        register("load_structures", load_structures, "Load structure definitions from file", "load_structures <path>", 1);
        register("list_structures", list_structures, "List all available structures", "list_structures [domain]");
    }

    private void register( string cmdname, CmdFunc func, string help, string? syntax = null, uint args = 0 )
    {
        _map[cmdname] = new CommandHolder( func, help, syntax ?? cmdname, args );
    }

    public List<string> commandsWithPrefix( string prefix = "" )
    {
        var list = new List<string>();
        foreach ( var name in _map.keys )
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

        var holder = _map[ components[0] ];
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

        holder.func( components[1:components.length] );
    }

    //
    // commands here
    //
    
    private void help( string[] params )
    {
        MSG( "This program supports the following commands:" );
        foreach ( var cmd in _map.values )
        {
            var syntax = cmd.syntax;
            while ( syntax.length < 50 )
                syntax += " ";
            MSG( @"$syntax: $(cmd.help)" );
        }
    }

    private void load_structures(string[] params)
    {
		_controller.onLoadStructureDefinitions(params[0]);
    }

    private void list_structures(string[] params)
    {
		if (params.length > 0) 
			_controller.onListStructuresWithDomain(params[0]);
		else _controller.onListStructures();
    }
}

} // namespace
