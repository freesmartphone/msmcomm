/**
* This file is part of msmcommd.
*
* (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    public class ModemChannel : AbstractObject
    {
        private Gee.LinkedList<CommandHandler> queue;
        private Gee.ArrayList<CommandHandler> pending;
        private MessageAssembler masm;
        private MessageDisassembler mdis;

        public ModemControl modem;
        public uint32 current_ref_id;

        private const uint32 REFERENCE_ID_INITIAL = 1;
        private const uint32 REFERENCE_ID_INVALID = 0;

        //
        // public API
        //

        public ModemChannel(ModemControl modem)
        {
            this.modem = modem;

            masm = new MessageAssembler();
            mdis = new MessageDisassembler();

            queue = new Gee.LinkedList<CommandHandler>();
            pending = new Gee.ArrayList<CommandHandler>();
            current_ref_id = REFERENCE_ID_INITIAL;

            modem.registerChannel(this);
        }

        public async bool open()
        {
            return true;
        }

        //
        // signals
        //

        public signal void requestHandleUnsolicitedResponse(BaseMessage message);

        //
        // private API
        //

        protected bool checkRestartingQueue()
        {
            if ( queue.size > 0 )
            {
                writeNextCommand();
                return true;
            }
            else
            {
                return false;
            }
        }

        /**
         * Find command handler with specified reference id in pending list
         **/
        private CommandHandler? findPendingWithRefId(uint32 ref_id)
        {
            CommandHandler result = null;
            foreach ( var handler in pending )
            {
                if ( handler.command.ref_id == ref_id )
                {
                    result = handler;
                    break;
                }
            }
            return result;
        }

        /**
         * Write next command to modem and add timeout for resending
         **/
        protected void writeNextCommand()
        {
            var command = queue.poll_head();
            writeCommand(command);

            assert( logger.debug( @"Wrote '$command'. Waiting ($(command.timeout)s) for answer..." ) );

            command.startTimeout();

            // in some cases it is necessary to not wait for a response message
            if ( !command.ignore_response )
            {
                pending.add(command);
            }
        }

        protected void writeCommand(CommandHandler handler)
        {
            uint8[] data;
            data = masm.pack_message(handler.command);
            hexdump2(true, data, logger);
            modem.sendData(data);
        }

        protected bool onTimeout(CommandHandler command)
        {
            /* If command got a response while waiting for it, abort here */
            if (pending.size == 0)
                return false;

            assert( logger.warning( @"Timeout while waiting for an answer to '$command'" ) );
            if ( command.retry > 0 )
            {
                command.retry--;
                assert( logger.debug( @"Retrying '$command', retry counter = $(command.retry)" ) );
                writeCommand(command);
                return true;
            }
            else
            {
                onResponseTimeout( command );
            }

            return false;
        }

        protected void onResponseTimeout( CommandHandler command )
        {
            command.resetTimeout();

            /* Mark command as timed out and return to enqueueAsync method */
            command.timed_out = true;
            command.callback();
        }

        protected void enqueueCommand( CommandHandler command )
        {
            queue.offer_tail( command );
            Idle.add( checkRestartingQueue );
        }

        protected void reset()
        {
            logger.debug("Reseting command queue ...");

#if 0
            // Only reset current to nothing when we are not waiting for any response
            current = current == null ? null : current;
            queue.clear();
#endif
        }

        private bool checkResponseForCommandHandler(BaseMessage response, CommandHandler bundle)
        {
            // Check wether command and response have the same reference id
            return response.ref_id == bundle.command.ref_id;
        }

        private uint32 nextValidMessageRefId()
        {
            if (current_ref_id > uint32.MAX) 
            {
                current_ref_id = REFERENCE_ID_INITIAL;
            }
            else 
            {
                current_ref_id++;
            }

            return current_ref_id;
        }

        protected void onSolicitedResponse( CommandHandler bundle, BaseMessage response )
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
                    logger.error( @"got response for current command with wrong ref id ($(response.ref_id), $(bundle.command.ref_id))!" );
                }
            }
            else
            {
                logger.debug("Last issued command does not have a callback so this command was issued as a sync one; ignoring response");
            }
        }

        public async void enqueueAsyncNew( owned BaseMessage command,
                                           bool report_all_urcs,
                                           owned ResponseHandlerFunc response_handler_func,
                                           int retries = 0, int timeout = 0 ) throws Msmcomm.Error
        {
            if (!modem.active)
            {
                throw new Msmcomm.Error.MODEM_INACTIVE( "Modem is not ready for command processing; initialize it first!" );
            }

            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, retries, timeout, onTimeout, response_handler_func );
            handler.report_all_urcs = report_all_urcs;
            handler.callback = enqueueAsyncNew.callback;
            enqueueCommand( handler );
            yield;

            if (handler.timed_out)
            {
                throw new Msmcomm.Error.TIMEOUT( @"Timed out while waiting for a response for command '$(command.message_type)'" );
            }

            pending.remove(handler);

#if DEBUG
            debug( @"pending.size = $(pending.size)" );
#endif

            if (handler.error != null)
            {
                throw handler.error;
            }
        }

        public async unowned BaseMessage enqueueAsync( owned BaseMessage command, int retries = 0, int timeout = 0 ) throws Msmcomm.Error
        {
            if (!modem.active)
            {
                throw new Msmcomm.Error.MODEM_INACTIVE( "Modem is not ready for command processing; initialize it first!" );
            }

            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, retries, timeout, onTimeout );
            handler.callback = enqueueAsync.callback;
            enqueueCommand( handler );
            yield;

            if (handler.timed_out)
            {
                throw new Msmcomm.Error.TIMEOUT( @"Timed out while waiting for a response for command '$(command.message_type)'" );
            }

            pending.remove(handler);

#if DEBUG
            debug( @"pending.size = $(pending.size)" );
#endif
            return handler.response;
        }

        public void enqueueSync( owned BaseMessage command ) throws Msmcomm.Error
        {
            /* Check wether modem is already ready for processing commands */
            if (!modem.active)
            {
                throw new Msmcomm.Error.MODEM_INACTIVE( "Modem is not ready for command processing; initialize it first!" );
            }

            // create and command and send it out but do not wait for a response
            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, 0 );
            handler.ignore_response = true;
            enqueueCommand( handler );
        }

        /**
         * Process incomming data stream for new messages and forward them to the
         * connected client handlers
         **/
        public void handleIncommingData(uint8[] data)
        {
            BaseMessage? message = mdis.unpack_message(data);

            if (message == null)
            {
                logger.error("Could not unpack incomming message: groupId = %02x, messageId = %02x".printf(
                        mdis.unpack_group_id(data), mdis.unpack_message_id(data)));
                return;
            }

            logger.debug( message.message_type.to_string() );

            if (message.message_class == MessageClass.SOLICITED_RESPONSE)
            {
                if (pending.size == 0)
                {
                    logger.error("Got response while not expecting one! Maybe out of sync!?");
                    reset();
                    return;
                }

                var handler = findPendingWithRefId( message.ref_id );
                if ( handler == null )
                {
                    logger.error( "Got response but we don't have any corresponding send message (ref_id = $(message.ref_id)) !!!" );
                    return;
                }

                handler.handleResponseMessage( message );

                // FIXME this needs to be removed after all services uses the new
                // enqueueAsyncNew method for sending messages the modem.
                if ( handler.response_handler_func == null )
                {
                    onSolicitedResponse(handler, message);
                }

                // Idle.add(checkRestartingQueue);
            }
            else if (message.message_class == MessageClass.UNSOLICITED_RESPONSE)
            {
                handleSpecificUnsolicitedResponse(message);
                requestHandleUnsolicitedResponse(message);
            }
        }

        /**
         * Some unsolicited response needed to be handled here first before passing them
         * to the connect client handlers
         **/
        private void handleSpecificUnsolicitedResponse(BaseMessage message)
        {
            if (message.message_type == MessageType.UNSOLICITED_RESPONSE_MISC_RADIO_RESET_IND)
            {
                logger.debug("Modem was reseted, we should do the same ...");
                reset();
            }
            else
            {
                if ( message.ref_id != REFERENCE_ID_INVALID )
                {
                    // check if we have some message with the reference id of this urc
                    var command = findPendingWithRefId( message.ref_id );
                    if ( command != null )
                    {
                        // we have a command with the same reference; let the command decide
                        // what to do with this urc
                        command.handleResponseMessage( message );
                    }
                }

                // check if we have some commands with the command id set in the urc
                // waiting
                if ( pending.size > 0 )
                {
                    foreach ( var cmdh in pending )
                    {
                        // check if we have some commands with the command id set in the urc
                        // waiting
                        if ( cmdh.command.command_id == message.command_id )
                        {
                            cmdh.handleResponseMessage( message );
                        }
                        else if ( cmdh.report_all_urcs )
                        {
                            cmdh.handleResponseMessage( message );
                        }
                    }
                }
            }
        }

        public override string repr()
        {
            return "<>";
        }
    }
}
