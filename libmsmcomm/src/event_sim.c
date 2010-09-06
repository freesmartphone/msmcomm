
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
 * MSMCOMM_EVENT_PHONEBOOK_READY
 */

unsigned int event_phonebook_ready_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1a && msg->msg_id == 0x6);
}

void event_phonebook_ready_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct phonebook_ready_event))
        return;

    msg->payload = data;
}

uint32_t event_phonebook_ready_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct phonebook_ready_event);
}

unsigned int msmcomm_event_phonebook_ready_get_book_type(struct msmcomm_message *msg)
{
    unsigned int type = MSMCOMM_PHONEBOOK_TYPE_NONE;

    switch (MESSAGE_CAST(msg, struct phonebook_ready_event)->book_type)
    {
        case 0x1:
            type = MSMCOMM_PHONEBOOK_TYPE_ADN;
            break;
        case 0x3:
            type = MSMCOMM_PHONEBOOK_TYPE_FDN;
            break;
        case 0x5:
            type = MSMCOMM_PHONEBOOK_TYPE_EFECC;
            break;
        case 0xe:
            type = MSMCOMM_PHONEBOOK_TYPE_SDN;
            break;
        case 0x10:
            type = MSMCOMM_PHONEBOOK_TYPE_MBDN;
            break;
        case 0x1d:
            type = MSMCOMM_PHONEBOOK_TYPE_ALL;
            break;
    }

    return type;
}

/*
 * MSMCOMM_EVENT_PHONEBOOK_MODIFIED
 */

unsigned int magic_to_book_type(uint8_t magic)
{
    switch (magic)
    {
        case 0x10:
            return MSMCOMM_PHONEBOOK_TYPE_ADN;
        case 0x8:
            return MSMCOMM_PHONEBOOK_TYPE_SDN;
        case 0x20:
            return MSMCOMM_PHONEBOOK_TYPE_FDN;
        case 0x48:
            return MSMCOMM_PHONEBOOK_TYPE_TEST1;
    }

    return MSMCOMM_PHONEBOOK_TYPE_NONE;
}

unsigned int event_phonebook_modified_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1a && msg->msg_id == 0xa);
}

void event_phonebook_modified_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct phonebook_modified_event))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct phonebook_modified_event)->ref_id;
}

uint32_t event_phonebook_modified_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct phonebook_modified_event);
}

uint8_t msmcomm_event_phonebook_modified_get_book_type(struct msmcomm_message *msg)
{
    return magic_to_book_type(MESSAGE_CAST(msg, struct phonebook_modified_event)->book_type);
}

uint8_t msmcomm_event_phonebook_modified_get_position(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct phonebook_modified_event)->position;
}

/*
 * SIM status events
 */

unsigned int event_sim_status_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x11);
}

void event_sim_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
}

void event_sim_status_free(struct msmcomm_message *msg)
{
}

unsigned int event_sim_status_get_type(struct msmcomm_message *msg)
{
    /* Ignore all events from second sim card */
    if ((msg->msg_id >= 30 && msg->msg_id <= 56) || msg->msg_id == 58 || msg->msg_id == 60)
        return MSMCOMM_EVENT_SIM_SIM2_EVENT;

    /* some events about real reset failure */
    if ((msg->msg_id >= 75 && msg->msg_id <= 107) || msg->msg_id == 72)
        return MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE;

    switch (msg->msg_id)
    {
        case 0:
            return MSMCOMM_EVENT_SIM_INSERTED;
        case 9:
            return MSMCOMM_EVENT_SIM_PIN1_VERIFIED;
        case 10:
            return MSMCOMM_EVENT_SIM_PIN1_BLOCKED;
        case 11:
            return MSMCOMM_EVENT_SIM_PIN1_UNBLOCKED;
        case 12:
            return MSMCOMM_EVENT_SIM_PIN1_ENABLED;
        case 13:
            return MSMCOMM_EVENT_SIM_PIN1_DISABLED;
        case 14:
            return MSMCOMM_EVENT_SIM_PIN1_CHANGED;
        case 15:
            return MSMCOMM_EVENT_SIM_PIN1_PERM_BLOCKED;
        case 16:
            return MSMCOMM_EVENT_SIM_PIN2_VERIFIED;
        case 17:
            return MSMCOMM_EVENT_SIM_PIN2_BLOCKED;
        case 18:
            return MSMCOMM_EVENT_SIM_PIN2_UNBLOCKED;
        case 19:
            return MSMCOMM_EVENT_SIM_PIN2_ENABLED;
        case 20:
            return MSMCOMM_EVENT_SIM_PIN2_DISABLED;
        case 21:
            return MSMCOMM_EVENT_SIM_PIN2_CHANGED;
        case 22:
            return MSMCOMM_EVENT_SIM_PIN2_PERM_BLOCKED;
        case 26:
            return MSMCOMM_EVENT_SIM_REFRESH_RESET;
        case 27:
            return MSMCOMM_EVENT_SIM_REFRESH_INIT;
        case 57:
            return MSMCOMM_EVENT_SIM_REFRESH_INIT_FCN;
        case 61:
            return MSMCOMM_EVENT_SIM_REFRESH_FAILED;
        case 28:
            return MSMCOMM_EVENT_SIM_FDN_ENABLE;
        case 29:
            return MSMCOMM_EVENT_SIM_FDN_DISABLE;
        case 66:
            return MSMCOMM_EVENT_SIM_ILLEGAL;
        case 1:
            return MSMCOMM_EVENT_SIM_REMOVED;
        case 5:
            return MSMCOMM_EVENT_SIM_NO_SIM_EVENT;
        case 6:
            return MSMCOMM_EVENT_SIM_NO_EVENT;
        case 2:
            return MSMCOMM_EVENT_SIM_DRIVER_ERROR;
        case 67:
        case 68:
        case 69:
        case 70:
        case 71:
            return MSMCOMM_EVENT_SIM_INTERNAL_RESET;
        case 24:
            return MSMCOMM_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL;
        case 25:
            return MSMCOMM_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL;
        case 8:
            return MSMCOMM_EVENT_SIM_INIT_COMPLETED_NO_PROV;
        case 4:
            return MSMCOMM_EVENT_SIM_MEMORY_WARNING;
        case 73:
        case 74:
            return MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE;
        case 3:
            return MSMCOMM_EVENT_SIM_CARD_ERROR;
        case 23:
            return MSMCOMM_EVENT_SIM_NO_EVENT;
        case 114:
            return MSMCOMM_EVENT_SIM_GET_PERSO_NW_FAILURE;
        case 124:
            return MSMCOMM_EVENT_SIM_GET_PERSO_NW_BLOCKED;
        case 108:
            return MSMCOMM_EVENT_SIM_REFRESH_APP_RESET;
        case 109:
            return MSMCOMM_EVENT_SIM_REFRESH_3G_SESSION_RESET;
        case 110:
        case 111:
        case 112:
            return MSMCOMM_EVENT_SIM_APP_SELECTED;
        case 134:
        case 135:
        case 136:
        case 137:
        case 138:
            return MSMCOMM_EVENT_SIM_DEFAULT;
        default:
            break;
    }

    return MSMCOMM_MESSAGE_INVALID;
}

