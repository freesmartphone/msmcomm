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
    public class ModemChannel : AbstractObject
    {
        private Gee.LinkedList<CommandHandler> q;
        private uint timeoutWatch;
        protected CommandHandler current;
        private int current_event_type;
        private MessageAssembler masm;
        private MessageDisassembler mdis;

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
            uint8[] data;

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

        private bool checkResponseForCommandHandler(Msmcomm.LowLevel.BaseMessage response, CommandHandler bundle)
        {
            bool result = false;

            // Check wether command and response have the same reference id
            result = response.ref_id == bundle.command.ref_id;

#if 0
            // Ugly, ugly hack: As the GET_PHONEBOOK_PROPERTIES response does not
            // has a ref_id field, we disable the check only for this response !!!
            if (current_event_type != Msmcomm.LowLevel.BaseMessageType.RESPONSE_GET_PHONEBOOK_PROPERTIES)
            {
                result = response.ref_id == bundle.command.ref_id;
            }
#endif

            return true;
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

        public async unowned Msmcomm.LowLevel.BaseMessage enqueueAsync( owned Msmcomm.LowLevel.BaseMessage command, int retries = 0, int timeout = 0 )
        {
            command.ref_id = nextValidMessageRefId();
            var handler = new CommandHandler( command, retries );
            handler.callback = enqueueAsync.callback;
            enqueueCommand( handler );
            yield;
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

            logger.debug( messageTypeToString(message.message_type) );

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
    }
}

