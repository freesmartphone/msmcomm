/**
 * This file is part of msmvterm.
 *
 * (C) 2009-2011 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *               Simon Busch <morphis@gravedo.de>
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

const bool MAINLOOP_CALL_AGAIN = true;
const bool MAINLOOP_DONT_CALL_AGAIN = false;

public static Commands commands;
public static List<string> completions;

public static string? completion( string prefix, int state )
{
    if ( state == 0 )
    {
        var parts = Readline.line_buffer.split( " " );
        if ( parts.length > 1 )
        {
            completions = null;
            return null;
        }
        completions = commands.commandsWithPrefix( prefix );
    }
    return completions.nth_data( state );
}

//========================================================================//
public class Terminal : Object
//========================================================================//
{
    private unowned GLib.Thread thread;

    public Terminal( )
    {
        Readline.initialize();
    }

    public bool open()
    {
        ModemAgent.instance().ready.connect(onModemAgentReady);
        return MAINLOOP_DONT_CALL_AGAIN;
    }

    public void onModemAgentReady()
    {
        thread = GLib.Thread.create<void*>( cmdloop, true );
    }

    public void* cmdloop()
    {
        Readline.readline_name = "msmvterm";
        Readline.terminal_name = Environment.get_variable( "TERM" );

        Readline.History.read( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.History.max_entries = 512;

        Readline.completion_entry_function = completion;
        Readline.parse_and_bind( "tab: complete" );

        Readline.completer_word_break_characters = " ";
        Readline.basic_quote_characters = " ";
        Readline.completer_word_break_characters = " ";
        Readline.filename_quote_characters = " ";

        commands = new Commands( );

        while ( true )
        {
            var line = Readline.readline( "MSMVTERM> " );
            if ( line == null ) // ctrl-d
            {
                break;
            }
            if ( line == "" )
            {
                continue;
            }

            Readline.History.add( line );
            commands.dispatch( line );
        }
        Idle.add( () => { loop.quit(); return false; } );
        return null;
    }

    //
    // callbacks
    //

    ~Terminal()
    {
        Readline.History.write( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.free_line_state();
        Readline.cleanup_after_signal();
    }
}
