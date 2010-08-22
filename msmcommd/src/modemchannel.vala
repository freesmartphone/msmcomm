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

namespace Msmcomm
{
    public delegate void WaitForUnsolicitedResponseHandlerFunc( Msmcomm.Message urc );

    class WaitForUnsolicitedResponseHandlerFuncWrapper
    {
        public WaitForUnsolicitedResponseHandlerFunc func;
    }

    public class ModemChannel : AbstractObject
    {
        private Gee.LinkedList<CommandHandler> q;
        private uint timeoutWatch;
        protected CommandHandler current;
        private int current_event_type;
        
        public ModemControl modem;
        public static Msmcomm.Context context;
        public uint32 current_index;
        

        //
        // public API
        //
        
        public ModemChannel(ModemControl modem)
        {
            this.modem = modem;
            
            q = new Gee.LinkedList<CommandHandler>();
            current_index = 0;
            context = new Msmcomm.Context();
            modem.registerChannel(this);
        }

        public async bool open()
        {
            context.registerEventHandler( handleMsmcommEvent );
            context.registerWriteHandler( handleMsmcommWriteRequest );
            return true;
        }
        
        //
        // signals
        //
        
        public signal void requestHandleUnsolicitedResponse(Msmcomm.EventType type, Msmcomm.Message message);
        
        //
        // private API
        //
        
        protected bool checkRestartingQueue()
        {
            if ( current == null && q.size > 0 )
            {
                writeNextCommand();
                return true;
            }
            else
            {
                return false;
            }
        }
        
        protected void writeNextCommand()
        {
            current = q.poll_head();
            current.write();
            assert( logger.debug( @"Wrote '$current'. Waiting ($(current.timeout)s) for answer..." ) );
            if ( current.timeout > 0 )
            {
                timeoutWatch = GLib.Timeout.add_seconds( current.timeout, onTimeout );
            }
        }

        protected void resetTimeout()
        {
            if ( timeoutWatch > 0 )
            {
                GLib.Source.remove( timeoutWatch );
            }
        }

        protected bool onTimeout()
        {
            assert( logger.warning( @"Timeout while waiting for an answer to '$current'" ) );
            if ( current.retry > 0 )
            {
                current.retry--;
                assert( logger.debug( @"Retrying '$current', retry counter = $(current.retry)" ) );
                current.write();
                return true; // call me again
            }
            else
            {
                onResponseTimeout( current ); // derived class is responsible for relaunching the command queue
            }
            return false; // don't call me again
        }

        protected void onResponseTimeout( CommandHandler ach )
        {
        }

        protected void enqueueCommand( CommandHandler command )
        {
            q.offer_tail( command );
            Idle.add( checkRestartingQueue );
        }

        protected void reset()
        {
            logger.debug("Reseting command queue ...");
            current = null;
            q.clear();
        }
        
        private void handleMsmcommWriteRequest(uint8[] data)
        {
            modem.send(data, data.length);
        }

        private bool checkResponseForCommandHandler(Msmcomm.Message response, CommandHandler bundle)
        {
            bool result = false;
            
            // Ugly, ugly hack: As the GET_PHONEBOOK_PROPERTIES response does not
            // has a ref_id field, we disable the check for only this response !!!
            if (current_event_type != Msmcomm.ResponseType.GET_PHONEBOOK_PROPERTIES)
            {
                result = response.index == bundle.command.index;
            }
            
            return true;
        }

        private uint32 nextValidMessageIndex()
        {
            if (current_index > uint32.MAX) {
                current_index = 0;
            }
            else {
                current_index++;
            }
            return current_index;
        }

        protected void onSolicitedResponse( CommandHandler bundle, Msmcomm.Message response )
        {
            if ( checkResponseForCommandHandler( response, bundle ) )
            {
                bundle.response = response;
                bundle.callback();
            }
            else
            {
                logger.error( @"got response for current command with wrong ref id ($(response.index), $(bundle.command.index))!" );
            }
        }

        public async unowned Msmcomm.Message enqueueAsync( owned Msmcomm.Message command, int retries = 0, int timeout = 0 )
        {
            command.index = nextValidMessageIndex();
            var handler = new CommandHandler( command, retries );
            handler.callback = enqueueAsync.callback;
            enqueueCommand( handler );
            yield;
            return handler.response;
        }
        
        public void enqueueSync( owned Msmcomm.Message command, int retries = 0 )
        {
            command.index = nextValidMessageIndex();
            var handler = new CommandHandler( command, 0 );
            enqueueCommand( handler );
        }
        
        public async void waitForUnsolicitedResponse( Msmcomm.EventType urc_type, WaitForUnsolicitedResponseHandlerFunc handler )
        {
            // FIXME
        }
        
        public void handleIncommingData(uint8[] data)
        {
            context.processData((void*) data, data.length);
        }

        public void handleMsmcommEvent( int event, Msmcomm.Message message )
        {
            var et = Msmcomm.eventTypeToString( event );
            logger.debug( et );
            
            current_event_type = event;

            if ( message.type == Msmcomm.EventType.RESET_RADIO_IND )
            {
                /* Modem was reseted, we should do the same */
                logger.debug( "Modem was reseted, we should do the same ..." );
                reset();
            }
            
            if ( message.message_type == Msmcomm.MessageType.RESPONSE )
            {
                if (current == null)
                {
                    logger.error("Got response while not expecting one! Maybe out of sync!?");
                    reset();
                    return;
                }
                
                onSolicitedResponse( (CommandHandler)current, message );
                current = null;
                Idle.add( checkRestartingQueue );
            }
            else if ( message.message_type == Msmcomm.MessageType.EVENT )
            {
                requestHandleUnsolicitedResponse((Msmcomm.EventType) event, message);
            }
        }
        
        public override string repr()
        {
            return "<>";
        }
    }
}
