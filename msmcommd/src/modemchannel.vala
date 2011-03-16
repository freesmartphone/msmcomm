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

using Msmcomm.LowLevel;

namespace Msmcomm.Daemon
{
    internal class WaitForUnsolicitedResponseData
    {
        public GLib.SourceFunc callback;
        public MessageType urc_type;
        public BaseMessage response;
        public uint timeout;
        public SourceFunc? timeout_func;
    }

    public class ModemChannel : AbstractObject
    {
        private Gee.LinkedList<CommandHandler> q;
        private uint timeoutWatch;
        protected CommandHandler current;
        private MessageAssembler masm;
        private MessageDisassembler mdis;
        private GLib.List<WaitForUnsolicitedResponseData> urc_waiters;

        public ModemControl modem;
        public uint32 current_ref_id;

        //
        // public API
        //

        public ModemChannel(ModemControl modem)
        {
            this.modem = modem;

            masm = new MessageAssembler();
            mdis = new MessageDisassembler();

            q = new Gee.LinkedList<CommandHandler>();
            current_ref_id = 0;

            urc_waiters = new GLib.List<WaitForUnsolicitedResponseData>();

            modem.registerChannel(this);

        }

        public async bool open()
        {
            return true;
        }

        //
        // signals
        //

        public signal void requestHandleUnsolicitedResponse(Msmcomm.LowLevel.BaseMessage message);

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

        /**
         * Write next command to modem and add timeout for resending
         **/
        protected void writeNextCommand()
        {
            current = q.poll_head();
            writeCommand(current);

            assert( logger.debug( @"Wrote '$current'. Waiting ($(current.timeout)s) for answer..." ) );
            if ( current.timeout > 0 )
            {
                timeoutWatch = GLib.Timeout.add_seconds( current.timeout, onTimeout );
            }
        }

        protected void writeCommand(CommandHandler handler)
        {
            uint8[] data;
            data = masm.pack_message(handler.command);
            hexdump2(true, data, logger);
            modem.sendData(data);
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
            /* If command got a response while waiting for it, abort here */
            if (current == null)
                return false;

            assert( logger.warning( @"Timeout while waiting for an answer to '$current'" ) );
            if ( current.retry > 0 )
            {
                current.retry--;
                assert( logger.debug( @"Retrying '$current', retry counter = $(current.retry)" ) );
                writeCommand(current);
                return true;
            }
            else
            {
                // derived class is responsible for relaunching the command queue
                onResponseTimeout( current );
            }
            return false;
        }

        protected void onResponseTimeout( CommandHandler ch )
        {
            resetTimeout();

            /* Mark command as timed out and return to enqueueAsync method */
            ch.timed_out = true;
            ch.callback();
        }

        protected void enqueueCommand( CommandHandler command )
        {
            q.offer_tail( command );
            Idle.add( checkRestartingQueue );
        }

        protected void reset()
        {
            logger.debug("Reseting command queue ...");

#if 0
            // Only reset current to nothing when we are not waiting for any response
            current = current == null ? null : current;
            q.clear();
#endif
        }

        private bool checkResponseForCommandHandler(Msmcomm.LowLevel.BaseMessage response, CommandHandler bundle)
        {
            // Check wether command and response have the same reference id
            return response.ref_id == bundle.command.ref_id;
        }

        private uint32 nextValidMessageRefId()
        {
            if (current_ref_id > uint32.MAX) 
            {
                current_ref_id = 0;
            }
            else 
            {
                current_ref_id++;
            }

            return current_ref_id;
        }

        protected void onSolicitedResponse( CommandHandler bundle, Msmcomm.LowLevel.BaseMessage response )
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

        public async unowned Msmcomm.LowLevel.BaseMessage enqueueAsync( owned Msmcomm.LowLevel.BaseMessage command, int retries = 0, int timeout = 0 ) throws Msmcomm.Error
        {
            string msg = "";

            /* Check wether modem is already ready for processing commands */
            if (!modem.active)
            {
                msg = "Modem is not ready for command processing; initialize it first!";
                throw new Msmcomm.Error.MODEM_INACTIVE(msg);
            }

            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, retries, timeout );
            handler.callback = enqueueAsync.callback;
            enqueueCommand( handler );
            yield;

            if (handler.timed_out)
            {
                /* Unset current command handler, otherwise queue hangs */
                current = null;

                msg = @"Timed out while waiting for a response for command '$(command.message_type)'";
                throw new Msmcomm.Error.TIMEOUT(msg);
            }

            return handler.response;
        }

        public void enqueueSync( owned Msmcomm.LowLevel.BaseMessage command, int retries = 0 )
        {
            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, 0 );
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
                if (current == null)
                {
                    logger.error("Got response while not expecting one! Maybe out of sync!?");
                    reset();
                    return;
                }

                onSolicitedResponse((CommandHandler) current, message);
                current = null;
                Idle.add(checkRestartingQueue);
            }
            else if (message.message_class == MessageClass.UNSOLICITED_RESPONSE)
            {
                handleSpecificUnsolicitedResponse(message);
                notifyUnsolicitedResponse(message.message_type, message);
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
        }

        public override string repr()
        {
            return "<>";
        }

        /**
         * Lets wait for a specific unsolicited response to recieve and return it's payload
         * after it finaly recieves.
         **/
        public async BaseMessage waitForUnsolicitedResponse( MessageType type, int timeout = 0, SourceFunc? timeout_func = null )
        {
            logger.debug( @"Create an new urc waiter with type = $(type)" );

            // Create waiter and yield until urc occurs
            var data = new WaitForUnsolicitedResponseData();
            data.urc_type = type;
            data.callback = waitForUnsolicitedResponse.callback;
            data.timeout_func = timeout_func;
            urc_waiters.append( data );

            // if user specified a timeout for the wait we add it here and return to the
            // caller when the timeout occured
            if ( timeout > 0 )
            {
                data.timeout = Timeout.add_seconds( timeout, () => {
                    urc_waiters.remove( data );

                    if ( data.timeout_func != null )
                    {
                        data.timeout_func();
                    }

                    data.callback();
                    return false;
                } );
            }

            yield;

            // Urc occured so we can return the recieved message structure to the caller who
            // has now not longer to wait for the urc
            urc_waiters.remove( data );
            return data.response;
        }

        /**
         * Notify the occurence of a unsolicted response to the modem agent which informs all
         * registered clients for this type of message.
         **/
        public async void notifyUnsolicitedResponse( MessageType type, BaseMessage response )
        {
            logger.debug( @"Awake all waiters for urc type $(type)" );
            var waiters = retriveUrcWaiters( type );

            // awake all waiters for the notified urc type and supply them the message payload
            foreach (var waiter in waiters )
            {
                // check wether this waiter has a timeout
                if ( waiter.timeout > 0 )
                {
                    Source.remove( waiter.timeout );
                    waiter.timeout = 0;
                }

                urc_waiters.remove( waiter );
                waiter.response = response;
                waiter.callback();
            }
        }

        private GLib.List<WaitForUnsolicitedResponseData> retriveUrcWaiters( MessageType type )
        {
            var result = new GLib.List<WaitForUnsolicitedResponseData>();

            foreach ( var waiter in urc_waiters )
            {
                if ( waiter.urc_type == type )
                {
                    result.append( waiter );
                }
            }

            return result;
        }
    }
}
