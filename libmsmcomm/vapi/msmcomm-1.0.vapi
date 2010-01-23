/* 
 * (c) 2009 by Simon Busch <morphis@gravedo.de>
 * All Rights Reserved
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

 [CCode (cheader_filename = "msmcomm/msmcomm.h")]
 namespace msmcomm
 {
    [CCode (cprefix = "MSMCOMM_MESSAGE")]
    enum MessageType
    {
        INVALID,
        CHANGE_OPERATION_MODE,
        GET_IMEI,
        GET_FIRMWARE_INFO,
        TEST_ALIVE,
    }

    [CCode (cprefix = "MSMCOMM_RESPONSE_")]
    enum ResponseType
    {
        INVALID,
        CM_PH,
    }

    [CCode (cprefix = "MSMCOMM_EVENT_")]
    enum EventType
    {
        INVALID,
        RESET_RADIO_IND,
    }

    [CCode (cprefix = "MSMCOMM_OPERATOR_MODE_")]
    enum OperatorMode
    {
        RESET,
        ONLINE,
        OFFLINE,
    }

    [CCode (cname = "msmcomm_event_handler_cb")]
    public static delegate EventHandlerCallback(Context context, EventType event);
    [CCode (cname = "msmcomm_write_handler_cb")]
    public static delegate WriteHandlerCallback(Context context, void *data, int len);
    
    [CCode (cname = "struct msmcomm_message", free_function = "msmcomm_free_message")]
    [Compact]
    public class Message
    {
       [CCode (cname = "msmcomm_create_message")]
       public Message(Context? context, MessageType type);

       [CCode (cname = "msmcomm_get_size")]
       public int getSize();

       [CCode (cname = "msmcomm_get_type")]
       public MessageType getType();
    }

    [CCode (cname = "struct msmcomm_message", free_function = "msmcomm_free_message")]
    [Compact]
    public class ChangerOperationModeMessage : Message
    {
        public ChangerOperationModeMessage(Context? context)
            : base(context, MessageType.CHANGE_OPERATION_MODE)
        {
        }

        [CCode (cname = "msmcomm_message_change_operation_mode_set_operator_mode")]
        public void setOperatorMode(OperatorMode oprtMode);
    }

    [CCode (cname = "struct msmcomm_context", free_function = "msmcomm_shutdown")]
    [Compact]
    public class Context
    {
        [CCode (cname = "msmcomm_init")]
        public Context();

        [CCode (cname = "msmcomm_read_from_modem")]
        public bool readFromModem(int fd);

        [CCode (cname = "msmcomm_send_message")]
        public void sendMessage(Message message);

        [CCode (cname = "msmcomm_register_event_handler")]
        public void registerEventHandler(EventHandlerCallback eventHandlerCallback)

        [CCode (cname = "msmcomm_register_write_handler")]
        public void registerWriteHandler(WriteHandlerCallback writeHandlerCallback);
    }
 }

