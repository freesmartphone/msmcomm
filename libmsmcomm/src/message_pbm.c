
/*
 * (c) 2010 by Simon Busch <morphis@gravedo.de>
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

#include "internal.h"

extern void *talloc_msmc_ctx;

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_READ_PHONEBOOK
 */

void msg_read_phonebook_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x18;
    msg->msg_id = 0x0;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct read_phonebook_msg);
}

uint32_t msg_read_phonebook_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct read_phonebook_msg);
}

void msg_read_phonebook_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_read_phonebook_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct read_phonebook_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

uint8_t book_type_to_magic(msmcomm_phonebook_type_t book_type)
{
   uint8_t magic = 0x0;

    switch (book_type)
    {
        case MSMCOMM_PHONEBOOK_TYPE_MBDN:
            break;
        case MSMCOMM_PHONEBOOK_TYPE_EFECC:
            break;
        case MSMCOMM_PHONEBOOK_TYPE_ADN:
            magic = 0x10;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_SDN:
            magic = 0x8;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_FDN:
            magic = 0x20;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_TEST1:
            magic = 0x48;
            break;
    }

    return magic;
}

void msmcomm_message_read_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type)
{
    MESSAGE_CAST(msg, struct read_phonebook_msg)->book_type = book_type_to_magic(book_type);
}

void msmcomm_message_read_phonebook_set_position(struct msmcomm_message *msg, uint8_t position)
{
    MESSAGE_CAST(msg, struct read_phonebook_msg)->position = position;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_GET_PHONEBOOK_PROPERTIES
 */

void msg_get_phonebook_properties_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x18;
    msg->msg_id = 0x4;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct get_phonebook_properties_msg);
}

uint32_t msg_get_phonebook_properties_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_phonebook_properties_msg);
}

void msg_get_phonebook_properties_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_get_phonebook_properties_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct get_phonebook_properties_msg)->ref_id = msg->ref_id;

    return msg->payload;
}

void msmcomm_message_get_phonebook_properties_set_book_type(struct msmcomm_message *msg,
                                                            msmcomm_phonebook_type_t book_type)
{
    uint8_t value = 0x0;

    switch (book_type)
    {
        case MSMCOMM_PHONEBOOK_TYPE_ALL:
            value = 0x1d;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_MBDN:
            value = 0x10;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_EFECC:
            value = 0x5;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_ADN:
            value = 0x1;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_SDN:
            value = 0xe;
            break;
        case MSMCOMM_PHONEBOOK_TYPE_FDN:
            value = 0x3;
            break;
    }
    
    MESSAGE_CAST(msg, struct get_phonebook_properties_msg)->book_type = value;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_WRITE_PHONEBOOK
 */

void msg_write_phonebook_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x18;
    msg->msg_id = 0x2;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct modify_phonebook_msg);
}

uint32_t msg_write_phonebook_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct modify_phonebook_msg);
}

void msg_write_phonebook_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_write_phonebook_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->ref_id = msg->ref_id;
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->value0 = 0x4;
    return msg->payload;
}

void msmcomm_message_write_phonebook_set_number(struct msmcomm_message *msg, const char *number, unsigned int len)
{
    unsigned int max_len = sizeof(MESSAGE_CAST(msg, struct modify_phonebook_msg)->number) / sizeof(uint8_t);
    if (len > max_len)
        return;
    memcpy(MESSAGE_CAST(msg, struct modify_phonebook_msg)->number, number, len);
}

void msmcomm_message_write_phonebook_set_title(struct msmcomm_message *msg, const char *title, unsigned int len)
{
    unsigned int max_len = sizeof(MESSAGE_CAST(msg, struct modify_phonebook_msg)->title) / sizeof(uint8_t);
    if (len > max_len)
        return;
    memcpy(MESSAGE_CAST(msg, struct modify_phonebook_msg)->title, title, len);
}

void msmcomm_message_write_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type)
{
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->book_type = book_type_to_magic(book_type);
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_DELETE_PHONEBOOK
 */

void msg_delete_phonebook_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x18;
    msg->msg_id = 0x2;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct modify_phonebook_msg);
}

uint32_t msg_delete_phonebook_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct modify_phonebook_msg);
}

void msg_delete_phonebook_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_delete_phonebook_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->ref_id = msg->ref_id;
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->value0 = 0x4;
    
    return msg->payload;
}

void msmcomm_message_delete_phonebook_set_position(struct msmcomm_message *msg, uint8_t position)
{
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->position = position;
}

void msmcomm_message_delete_phonebook_set_book_type(struct msmcomm_message *msg, msmcomm_phonebook_type_t book_type)
{
    MESSAGE_CAST(msg, struct modify_phonebook_msg)->book_type = book_type_to_magic(book_type);
}
