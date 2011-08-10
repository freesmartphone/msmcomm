/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.PalmPre
{
    public class CommandQueue : Common.AbstractObject
    {
        private Gee.LinkedList<CommandHandler> queue;
        private Gee.ArrayList<CommandHandler> pending;
        private uint32 current_ref_id;
        private Gee.HashMap<uint8,BaseMessageGroup> message_groups;
        private BaseRadioAccess radio_access;

        //
        // private
        //

        private void setup_message_groups()
        {
            message_groups = new Gee.HashMap<uint8,BaseMessageGroup>();

            message_groups[StateResponseMessageGroup.GROUP_ID] = new StateResponseMessageGroup();
            message_groups[StateUnsolicitedResponseMessageGroup.GROUP_ID] = new StateUnsolicitedResponseMessageGroup();
            message_groups[MiscResponseMessageGroup.GROUP_ID] = new MiscResponseMessageGroup();
            message_groups[MiscUnsolicitedResponseMessageGroup.GROUP_ID] = new MiscUnsolicitedResponseMessageGroup();

#if 0
            message_groups[CallResponseMessageGroup.GROUP_ID] = new CallResponseMessageGroup();
            message_groups[CallUnsolicitedResponseMessageGroup.GROUP_ID] = new CallUnsolicitedResponseMessageGroup();
            message_groups[SimResponseMessageGroup.GROUP_ID] = new SimResponseMessageGroup();
            message_groups[SimUnsolicitedResponseMessageGroup.GROUP_ID] = new SimUnsolicitedResponseMessageGroup();
            message_groups[PhonebookResponseMessageGroup.GROUP_ID] = new PhonebookResponseMessageGroup();
            message_groups[PhonebookUnsolicitedResponseMessageGroup.GROUP_ID] = new PhonebookUnsolicitedResponseMessageGroup();
            message_groups[NetworkResponseMessageGroup.GROUP_ID] = new NetworkResponseMessageGroup();
            message_groups[NetworkUrcMessageGroup.GROUP_ID] = new NetworkUrcMessageGroup();
            message_groups[SupsResponseMessageGroup.GROUP_ID] = new SupsResponseMessageGroup();
            message_groups[SupsUnsolicitedResponseMessageGroup.GROUP_ID] = new SupsUnsolicitedResponseMessageGroup();
            message_groups[VoicemailResponseMessageGroup.GROUP_ID] = new VoicemailResponseMessageGroup();
            message_groups[VoicemailUrcMessageGroup.GROUP_ID] = new VoicemailUrcMessageGroup();
            message_groups[SmsResponseMessageGroup.GROUP_ID] = new SmsResponseMessageGroup();
            message_groups[SmsUrcMessageGroup.GROUP_ID] = new SmsUrcMessageGroup();
            message_groups[PdsmResponseMessageGroup.GROUP_ID] = new PdsmResponseMessageGroup();
            message_groups[PdsmUrcMessageGroup.GROUP_ID] = new PdsmUrcMessageGroup();
            message_groups[SoundResponseMessageGroup.GROUP_ID] = new SoundResponseMessageGroup();
            message_groups[SoundUnsolicitedResponseMessageGroup.GROUP_ID] = new SoundUnsolicitedResponseMessageGroup();
#endif
        }

        private uint8 unpack_group_id(uint8[] data)
        {
            assert(data.length >= MESSAGE_HEADER_SIZE);
            return data[0];
        }

        private uint16 unpack_message_id(uint8[] data)
        {
            assert(data.length >= MESSAGE_HEADER_SIZE);
            return (data[1] | (data[2] << 8));
        }

        private BaseMessage? unpack_message(uint8[] data)
        {
            BaseMessage? message = null;

            /* Minimum required size to have a valid message are four bytes */
            if (data.length < MESSAGE_HEADER_SIZE)
            {
                logger.error(@"Got invalid message from remote side!");
                return null;
            }

            /* Extract group and message id from the first three bytes */
            uint8 groupId = unpack_group_id(data);
            uint16 messageId = unpack_message_id(data);

            /* Check for message group and unpack message for byte stream */
            if (message_groups.has_key(groupId))
            {
                var group = message_groups[groupId];
                message = group.unpack_message(messageId, data[3:data.length]);
            }

            return message;
        }

        private uint8[] pack_message(BaseMessage message)
        {
            uint8[] payload;
            uint8[] buffer;

            /* pack message payload and build buffer to contain header and payload */
            payload = message.pack();
            buffer = new uint8[MESSAGE_HEADER_SIZE + payload.length];

            /* set group and message id to buffer */
            buffer[0] = message.group_id;
            buffer[1] = (uint8) (message.message_id & 0x00ff);
            buffer[2] = (uint8) ((message.message_id & 0xff00) >> 8);

            /* copy message payload to buffer */
            Memory.copy(((uint8*) buffer) + 3, payload, payload.length);

            return buffer;
        }

        private void handle_incoming_data(uint8[] data)
        {
            BaseMessage? message = unpack_message(data);

            if (message == null)
            {
                logger.error("Could not unpack incomming message: groupId = %02x, messageId = %02x"
                    .printf(unpack_group_id(data), unpack_message_id(data)));
                return;
            }

            logger.debug(@"$(message.message_type)");

            if (message.message_class == MessageClass.SOLICITED_RESPONSE)
            {
                if (pending.size == 0)
                {
                    logger.error("Got response while not expecting one! Maybe out of sync!?");
                    reset();
                    return;
                }

                var handler = find_pending_with_ref_id(message.ref_id);
                if (handler == null)
                {
                    logger.error( @"Got response but we don't have any corresponding send message (ref_id = $(message.ref_id)) !!!" );
                    return;
                }

                handler.handle_response_message( message );

                // FIXME this needs to be removed after all services uses the new
                // enqueueAsyncNew method for sending messages the modem.
                if ( handler.response_handler_func == null )
                {
                    handle_solicited_response(handler, message);
                }
            }
            else if (message.message_class == MessageClass.UNSOLICITED_RESPONSE)
            {
                handle_specific_unsolicited_response(message);
                unsolicited_response(message); // signal
            }
        }

        protected bool check_restarting_queue()
        {
            if (queue.size > 0)
            {
                write_next_command();
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
        private CommandHandler? find_pending_with_ref_id(uint32 ref_id)
        {
            CommandHandler result = null;
            foreach (var handler in pending)
            {
                if (handler.command.ref_id == ref_id)
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
        protected void write_next_command()
        {
            var command = queue.poll_head();
            write_command(command);

            assert( logger.debug(@"Wrote '$command'. Waiting ($(command.timeout)s) for answer...") );

            command.start_timeout();

            // in some cases it is necessary to not wait for a response message
            if (!command.ignore_response)
            {
                pending.add(command);
            }
        }

        protected void write_command(CommandHandler handler)
        {
            uint8[] data;
            data = pack_message(handler.command);
            radio_access.send(data);
        }

        protected bool handle_timeout(CommandHandler command)
        {
            /* If command got a response while waiting for it, abort here */
            if (pending.size == 0)
                return false;

            logger.warning( @"Timeout while waiting for an answer to '$command'" );
            if ( command.retry > 0 )
            {
                command.retry--;
                assert( logger.debug( @"Retrying '$command', retry counter = $(command.retry)" ) );
                write_command(command);
                return true;
            }
            else
            {
                handle_response_timeout( command );
            }

            return false;
        }

        protected void handle_response_timeout(CommandHandler command)
        {
            command.reset_timeout();

            /* Mark command as timed out and return to enqueueAsync method */
            command.timed_out = true;
            command.callback();
        }

        protected void enqueue_command(CommandHandler command)
        {
            queue.offer_tail( command );
            Idle.add( check_restarting_queue );
        }

        protected void reset()
        {
            assert( logger.debug("Reseting command queue ...") );

#if 0
            // Only reset current to nothing when we are not waiting for any response
            current = current == null ? null : current;
            queue.clear();
#endif
        }

        private bool check_response_for_command_handler(BaseMessage response, CommandHandler bundle)
        {
            // Check wether command and response have the same reference id
            return response.ref_id == bundle.command.ref_id;
        }

        private uint32 next_valid_ref_id()
        {
            if (current_ref_id > uint32.MAX)
                current_ref_id = REFERENCE_ID_INITIAL;

            return ++current_ref_id;
        }

        protected void handle_solicited_response( CommandHandler bundle, BaseMessage response )
        {
            if (bundle.callback != null)
            {
                if (check_response_for_command_handler(response, bundle))
                {
                    bundle.response = response;
                    bundle.callback();
                }
                else
                {
                    logger.error(@"got response for current command with wrong ref id ($(response.ref_id), $(bundle.command.ref_id))!");
                }
            }
            else
            {
                assert( logger.debug("Last issued command does not have a callback so this command was issued as a sync one; ignoring response") );
            }
        }

        /**
         * Some unsolicited response needed to be handled here first before passing them
         * to the connect client handlers
         **/
        private void handle_specific_unsolicited_response(BaseMessage message)
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
                    var command = find_pending_with_ref_id( message.ref_id );
                    if ( command != null )
                    {
                        // we have a command with the same reference; let the command decide
                        // what to do with this urc
                        command.handle_response_message( message );
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
                        if ( message.command_id != COMMAND_ID_INVALID && 
                             cmdh.command.command_id == message.command_id )
                            cmdh.handle_response_message( message );
                        else if ( cmdh.report_all_urcs )
                            cmdh.handle_response_message( message );
                    }
                }
            }
        }

        //
        // signals
        //

        public signal void unsolicited_response(BaseMessage message);

        //
        // public API
        //

        public CommandQueue(RadioAccess radio_access)
        {
            this.radio_access = radio_access;
            this.queue = new Gee.LinkedList<CommandHandler>();
            this.pending = new Gee.ArrayList<CommandHandler>();

            setup_message_groups();

            this.radio_access.incoming_data.connect(handle_incoming_data);
        }

        public async bool enqueue_async( owned BaseMessage command,
                                         bool report_all_urcs,
                                         owned ResponseHandlerFunc response_handler_func,
                                         int retries = 0, int timeout = 0 )
        {
            if (!radio_access.is_active())
            {
                logger.error(@"Tried to send a message but radio access is still not active!");
                return false;
            }

            radio_access.lock();

            command.ref_id = next_valid_ref_id();
            var handler = new CommandHandler(command, retries, timeout, handle_timeout, response_handler_func);
            handler.report_all_urcs = report_all_urcs;
            handler.callback = enqueue_async.callback;
            enqueue_command( handler );
            yield;

            pending.remove(handler);

            radio_access.unlock();

            if (handler.timed_out)
                return false;

            return true;
        }

        public async unowned BaseMessage? enqueue_async_simple(owned BaseMessage command, int retries = 0, int timeout = 0)
        {
            if (!radio_access.is_active())
                return null;

            radio_access.lock();

            command.ref_id = next_valid_ref_id();
            var handler = new CommandHandler(command, retries, timeout, handle_timeout);
            handler.callback = enqueue_async_simple.callback;
            enqueue_command( handler );
            yield;

            pending.remove(handler);
            radio_access.unlock();

            if (handler.timed_out)
                return null;

            return handler.response;
        }

        public bool enqueue_sync(owned BaseMessage command)
        {
            /* Check wether modem is already ready for processing commands */
            if (!radio_access.is_active())
                return false;

            radio_access.lock();

            // create and command and send it out but do not wait for a response
            command.ref_id = next_valid_ref_id();
            var handler = new CommandHandler(command, 0);
            handler.ignore_response = true;
            enqueue_command( handler );

            radio_access.unlock();

            return true;
        }

        public override string repr()
        {
            return @"<>";
        }
    }
}
