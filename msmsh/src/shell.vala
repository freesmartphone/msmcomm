/**
 * This file is part of msmsh.
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

namespace Msmcomm {

const bool MAINLOOP_CALL_AGAIN = true;
const bool MAINLOOP_DONT_CALL_AGAIN = false;

const int BUFFER_SIZE = 8192;

char[] buffer;

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
public class Shell : Object
//========================================================================//
{
	private unowned GLib.Thread thread;
	private Controller _controller; 
  
	public Shell()
	{
		Readline.initialize();
	}

	public bool setup() 
	{
		try 
		{
			thread = GLib.Thread.create( cmdloop, true );
		}
		catch (GLib.ThreadError e) 
		{
		}

		return false;
	}

	public void* cmdloop()
	{
		Readline.readline_name = "msmsh";
		Readline.terminal_name = Environment.get_variable( "TERM" );

		Readline.History.read( "%s/.msmsh.history".printf( Environment.get_variable( "HOME" ) ) );
		Readline.History.max_entries = 512;

		Readline.completion_entry_function = completion;
		Readline.parse_and_bind( "tab: complete" );

		Readline.completer_word_break_characters = " ";
		Readline.basic_quote_characters = " ";
		Readline.completer_word_break_characters = " ";
		Readline.filename_quote_characters = " ";
        
		_controller = new Controller();

		commands = new Commands(_controller);
        try {
			string path = "%s/.msmsh.startup".printf( Environment.get_variable( "HOME" ) );
			var file = File.new_for_path(path);
			if (file.query_exists(null)) {
				// read content from file and interpert each line (not starting with '#' or empty)
				var inStream = new GLib.DataInputStream(file.read(null));
				string line;
				while((line = inStream.read_line(null, null)) != null) {
					if (!line.has_prefix("#") || line.length != 0) {
						commands.dispatch(line);
					}
				}
			}
		}
		catch (Error err) {
		}

		while ( true ) {
			var line = Readline.readline( "MSMSH> " );
			if ( line == null ) // ctrl-d
				break;
            if ( line == "" )
				continue;

			Readline.History.add( line );
			commands.dispatch( line );
		}
		Idle.add( () => { loop.quit(); return false; } );
		return null;
	}

	~Shell()
	{
		Readline.History.write( "%s/.msmsh.history".printf( Environment.get_variable( "HOME" ) ) );
		Readline.free_line_state();
		Readline.cleanup_after_signal();
	}
}

} // namespace
