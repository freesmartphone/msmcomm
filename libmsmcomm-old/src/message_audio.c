

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
 * MSMCOMM_MESSAGE_TYPE_COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS
 */

void msg_get_audio_modem_tuning_params_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x1e;
    msg->msg_id = 0xb;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct get_audio_modem_tuning_params_msg);
}

uint32_t msg_get_audio_modem_tuning_params_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_audio_modem_tuning_params_msg);
}

void msg_get_audio_modem_tuning_params_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_get_audio_modem_tuning_params_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct get_audio_modem_tuning_params_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

/*
 * MSMCOMM_MESSAGE_TYPE_COMMAND_SET_AUDIO_PROFILE
 */

/* [CMD] tel.setaudioprofile 0 0
 * handleAudioSettingsMessage Audio Profile Class 0 Subclass 0
 * handleAudioSettingsMessage USER TTY FLAG 3
 * handleAudioSettingsMessage !!!!!!!!!DISABLING TTY!!!!!!!!!
 * .305297Z365ff490 +convertTilAudioProfileToHciSoundDevice 
 * .306762Z375ff490 waitForSignal Forever signal=35D85CE0
 * .307830Z365ff490 -convertTilAudioProfileToHciSoundDevice 
 * .309387Z375ff490 +waitForSignal 
 * .310485Z365ff490 setAudioProfile setAudioProfile 0 0
 * PACKET: dir=write fd=11 fn='/dev/modemuart' len=16/0x10
 * frame (type=Data, seq=05, ack=0c)
 * 1e 00 00 3c 00 00 00 00 00 00 00 00 00            ...<.........   
 */

void msg_set_audio_profile_init(struct msmcomm_message *msg)
{
    msg->group_id = 0x1e;
    msg->msg_id = 0x0;

    msg->payload = talloc_zero(talloc_msmc_ctx, struct set_audio_profile_msg);
}

uint32_t msg_set_audio_profile_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct set_audio_profile_msg);
}

void msg_set_audio_profile_free(struct msmcomm_message *msg)
{
    talloc_free(msg->payload);
}

uint8_t *msg_set_audio_profile_prepare_data(struct msmcomm_message *msg)
{
    MESSAGE_CAST(msg, struct set_audio_profile_msg)->ref_id = msg->ref_id;
    return msg->payload;
}

void msmcomm_message_set_audio_profile_set_class(struct msmcomm_message *msg, uint8_t class)
{
    MESSAGE_CAST(msg, struct set_audio_profile_msg)->class = class;
}

void msmcomm_message_set_audio_profile_set_sub_class(struct msmcomm_message *msg, uint8_t sub_class)
{
    MESSAGE_CAST(msg, struct set_audio_profile_msg)->sub_class = sub_class;
}
