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

public MainLoop loop;

public static void SIGINT_handler( int signum )
{
    Posix.signal( signum, null ); // restore original signal handler
    loop.quit();
    Readline.free_line_state();
    Readline.cleanup_after_signal();
}

public int main( string[] args )
{
    loop = new MainLoop( null, false );
    Posix.signal( Posix.SIGINT, SIGINT_handler );

    var terminal = new Terminal();

    Idle.add( terminal.open );
    loop.run();
    stdout.printf( "\nGoodbye.\n" );

    return 0;
}