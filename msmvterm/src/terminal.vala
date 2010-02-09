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

using GLib;

const bool MAINLOOP_CALL_AGAIN = true;
const bool MAINLOOP_DONT_CALL_AGAIN = false;

const int BUFFER_SIZE = 8192;

char[] buffer;

//========================================================================//
public class Terminal : Object
//========================================================================//
{
    private unowned GLib.Thread thread;
    private Commands commands;

    public Terminal()
    {
        Readline.initialize();
        Readline.readline_name = "msmvterm";
        Readline.terminal_name = Environment.get_variable( "TERM" );

        Readline.History.read( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.History.max_entries = 512;

        buffer = new char[BUFFER_SIZE];

        thread = GLib.Thread.create( cmdloop, true );

        commands = new Commands();
    }

    public bool open()
    {
        return MAINLOOP_DONT_CALL_AGAIN;
    }

    public void* cmdloop()
    {
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

    ~Terminal()
    {
        Readline.History.write( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.free_line_state();
        Readline.cleanup_after_signal();
    }
}
