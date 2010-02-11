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
    private Msmcomm.Context context;
    private FsoFramework.Transport transport;

    private string ip;
    private uint port;

    public Terminal( string ip = "127.0.0.1", uint port = 3030 )
    {
        Readline.initialize();

        this.ip = ip;
        this.port = port;

        buffer = new char[BUFFER_SIZE];
    }

    public bool open()
    {
        stdout.printf( @"MSMVTERM: Connecting to $ip:$port...\n" );

        context = new Msmcomm.Context();

        transport = new FsoFramework.SocketTransport( "tcp", ip, port );
        transport.setDelegates( onTransportReadyToRead, onTransportHangup );

        if ( !transport.open() )
        {
            stdout.printf( @"MSMVTERM: [ERR] Can't connect\n" );
            loop.quit();
            return MAINLOOP_DONT_CALL_AGAIN;
        }

        stdout.printf( @"MSMVTERM: ONLINE\n" );
        context.registerEventHandler( onMsmcommGotEvent );
        context.registerReadHandler( onMsmcommShouldRead );
        context.registerWriteHandler( onMsmcommShouldWrite );
        thread = GLib.Thread.create( cmdloop, true );

        return MAINLOOP_DONT_CALL_AGAIN;
    }

    public void* cmdloop()
    {
        Readline.readline_name = "msmvterm";
        Readline.terminal_name = Environment.get_variable( "TERM" );

        Readline.History.read( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.History.max_entries = 512;

        var commands = new Commands( ref context );

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

    public void onTransportReadyToRead( FsoFramework.Transport t )
    {
        var ok = context.readFromModem();
        assert( ok );
    }

    public void onTransportHangup( FsoFramework.Transport t )
    {
        assert_not_reached();
    }

    public void onMsmcommShouldRead( void* data, int len )
    {
        var bread = transport.read( data, len );
    }

    public void onMsmcommShouldWrite( void* data, int len )
    {
        var bwritten = transport.write( data, len );
        assert( bwritten == len );
    }

    public void onMsmcommGotEvent( Msmcomm.EventType event, Msmcomm.Message? message )
    {
        stdout.printf( "[EVENT]\n" );
    }

    ~Terminal()
    {
        if ( transport.isOpen() )
        {
            transport.close();
        }
        Readline.History.write( "%s/.msmvterm.history".printf( Environment.get_variable( "HOME" ) ) );
        Readline.free_line_state();
        Readline.cleanup_after_signal();
    }
}
