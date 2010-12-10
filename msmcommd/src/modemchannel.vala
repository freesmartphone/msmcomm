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

namespace Msmcomm.Daemon
{
    public class ModemChannel : AbstractObject
    {
        private Gee.LinkedList<CommandHandler> q;
        private uint timeoutWatch;
        protected CommandHandler current;
        private int current_event_type;

        public ModemControl modem;
        public static Msmcomm.LowLevel.Context context;
        public uint32 current_index;

        //
        // public API
        //

        public ModemChannel(ModemControl modem)
        {
            this.modem = modem;

            q = new Gee.LinkedList<CommandHandler>();
            current_index = 0;
            context = new Msmcomm.LowLevel.Context();
            modem.registerChannel(this);
        }

        public async bool open()
        {
            context.registerResponseHandler( handleMsmcommEvent );
            context.registerWriteHandler( handleMsmcommWriteRequest );
            return true;
        }

        //
        // signals
        //

        public signal void requestHandleUnsolicitedResponse(Msmcomm.LowLevel.MessageType type, 
                                                            Msmcomm.LowLevel.Message message);

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

        private bool checkResponseForCommandHandler(Msmcomm.LowLevel.Message response, CommandHandler bundle)
        {
            logger.debug("+checkResponseForCommandHandler");
            bool result = false;

            // Ugly, ugly hack: As the GET_PHONEBOOK_PROPERTIES response does not
            // has a ref_id field, we disable the check only for this response !!!
            if (current_event_type != Msmcomm.LowLevel.MessageType.RESPONSE_GET_PHONEBOOK_PROPERTIES)
            {
                result = response.index == bundle.command.index;
            }

            logger.debug("-checkResponseForCommandHandler");
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

        protected void onSolicitedResponse( CommandHandler bundle, Msmcomm.LowLevel.Message response )
        {
            if ( bundle.callback != null )
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
            else
            {
                logger.debug("Last issued command does not have a callback so this command was issued as a sync one; ignoring response");
            }
        }

        public async unowned Msmcomm.LowLevel.Message enqueueAsync( owned Msmcomm.LowLevel.Message command, int retries = 0, int timeout = 0 )
        {
            command.index = nextValidMessageIndex();
            var handler = new CommandHandler( command, retries );
            handler.callback = enqueueAsync.callback;
            enqueueCommand( handler );
            yield;
            return handler.response;
        }

        public void enqueueSync( owned Msmcomm.LowLevel.Message command, int retries = 0 )
        {
            command.index = nextValidMessageIndex();
            var handler = new CommandHandler( command, 0 );
            enqueueCommand( handler );
        }

        public void handleIncommingData(uint8[] data)
        {
            context.processData((void*) data, data.length);
        }

        public void handleMsmcommEvent( Msmcomm.LowLevel.MessageType event, Msmcomm.LowLevel.Message message )
        {
            var et = Msmcomm.LowLevel.messageTypeToString( event );
            logger.debug( et );

            current_event_type = event;

            if ( message.type == Msmcomm.LowLevel.MessageType.EVENT_RESET_RADIO_IND )
            {
                /* Modem was reseted, we should do the same */
                logger.debug( "Modem was reseted, we should do the same ..." );
                reset();
            }

            if ( message.class == Msmcomm.LowLevel.MessageClass.RESPONSE )
            {
                if (current == null)
                {
                    logger.error("Got response while not expecting one! Maybe out of sync!?");
                    reset();
                    return;
                }

                onSolicitedResponse( (CommandHandler) current, message );
                current = null;
                Idle.add( checkRestartingQueue );
            }
            else if ( message.class == Msmcomm.LowLevel.MessageClass.EVENT )
            {
                requestHandleUnsolicitedResponse(event, message);
            }
        }

        public override string repr()
        {
            return "<>";
        }
    }
}

