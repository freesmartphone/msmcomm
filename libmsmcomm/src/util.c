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

unsigned int network_plmn_to_value(const uint8_t *plmn)
{
    unsigned int value = 0;
    value = (plmn[0] & 0xf) * 10000;
    value += ((plmn[0] & 0xf0) >> 4) * 1000;
    value += (plmn[1] & 0xf) * 100;
    value += (plmn[2] & 0xf) * 10;
    value += ((plmn[2] & 0xf0) >> 4);
    return value;
}

/*
 * Common methods for pin_status_msg types
 */

void _message_pin_status_set_pin(struct msmcomm_message *msg, const char *pin)
{
    int len = strlen(pin);
    unsigned int bytes = 0;
    
    /* A valid pin should be 4 or 8 bytes long */
    if (len >= 4)
    {
        bytes = 4; 
    }
    else if (len >= 8)
    {
        bytes = 8;
    }
    
    memcpy(MESSAGE_CAST(msg, struct pin_status_msg)->pin, pin, bytes);
}

void _message_pin_status_set_pin_type(struct msmcomm_message *msg, msmcomm_sim_pin_type_t pin_type)
{
    unsigned int type = 0x0;
    switch (pin_type) 
    {
        case MSMCOMM_SIM_PIN_1:
            type = 0x0;
            break;
        case MSMCOMM_SIM_PIN_2:
            type = 0x1;
            break;
    }
    MESSAGE_CAST(msg, struct pin_status_msg)->pin_type = type;
}


