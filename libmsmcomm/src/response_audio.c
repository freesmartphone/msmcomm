
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
 * MSMCOMM_RESPONSE_SOUND
 */

unsigned int resp_sound_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1f) && (msg->msg_id == 0x1);
}

void resp_sound_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct sound_resp))
        return;

    msg->payload = data;
    
    if (MESSAGE_CAST(msg, struct sound_resp)->result != 0x0) 
    {
        msg->result = MSMCOMM_RESULT_ERROR;
        
        switch (MESSAGE_CAST(msg, struct sound_resp)->result)
        {
            case 0xb:
                msg->result = MSMCOMM_RESULT_INVALID_AUDIO_PROFILE;
                break;
        }
    }
}

uint32_t resp_sound_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct sound_resp);
}

/*
 * MSMCOMM_RESPONSE_AUDIO_MODEM_TUNING_PARAMS
 */

unsigned int resp_audio_modem_tuning_params_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1f) && (msg->msg_id == 0xb);
}

void resp_audio_modem_tuning_params_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct audio_modem_tuning_params_resp))
        return;

    msg->payload = data;
}

uint32_t resp_audio_modem_tuning_params_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct audio_modem_tuning_params_resp);
}

uint8_t *msmcomm_resp_audio_modem_tuning_params_get_params(struct msmcomm_message *msg, unsigned int *len)
{
    uint8_t *params = (uint8_t*)malloc(sizeof(uint8_t) * MSMCOMM_AUDIO_MODEM_TUNING_PARAMS_LENGTH);    
    memcpy(params, MESSAGE_CAST(msg, struct audio_modem_tuning_params_resp)->params, MSMCOMM_AUDIO_MODEM_TUNING_PARAMS_LENGTH);
    *len = MSMCOMM_AUDIO_MODEM_TUNING_PARAMS_LENGTH;
    return params;
}
