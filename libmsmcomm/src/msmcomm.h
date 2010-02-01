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

#ifndef MSMCOMM_H_
#define MSMCOMM_H_

#define MSMCOMM_MESSAGE_INVALID									0
#define MSMCOMM_MESSAGE_CMD_CHANGE_OPERATION_MODE				1
#define MSMCOMM_MESSAGE_CMD_GET_IMEI							2
#define MSMCOMM_MESSAGE_CMD_GET_FIRMWARE_INFO					3
#define MSMCOMM_MESSAGE_CMD_TEST_ALIVE							4
#define MSMCOMM_MESSAGE_CMD_GET_PHONE_STATE_INFO				5

#define MSMCOMM_RESPONSE_TEST_ALIVE								101
#define MSMCOMM_RESPONSE_GET_FIRMWARE_INFO						102
#define MSMCOMM_RESPONSE_GET_IMEI								103

#define MSMCOMM_RESPONSE_PDSM_PD_GET_POS						104
#define MSMCOMM_RESPONSE_PDSM_PD_END_SESSION					105
#define MSMCOMM_RESPONSE_PA_SET_PARAM							106
#define MSMCOMM_RESPONSE_LCS_AGENT_CLIENT_RSP					107
#define MSMCOMM_RESPONSE_XTRA_SET_DATA							108


#define MSMCOMM_EVENT_RESET_RADIO_IND							201
#define MSMCOMM_EVENT_CHARGER_STATUS							202
#define MSMCOMM_EVENT_SIM_INSERTED								203
#define MSMCOMM_EVENT_PIN1_ENABLED								204
#define MSMCOMM_EVENT_PIN2_ENABLED								205
#define MSMCOMM_EVENT_OPERATOR_MODE								206
#define MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE						207

#define MSMCOMM_EVENT_PDSM_PD_DONE								208
#define MSMCOMM_EVENT_PD_POSITION_DATA							209
#define MSMCOMM_EVENT_PD_PARAMETER_CHANGE						210
#define MSMCOMM_EVENT_PDSM_LCS									211
#define MSMCOMM_EVENT_PDSM_XTRA									212

#define MSMCOMM_OPERATOR_MODE_RESET								0
#define MSMCOMM_OPERATOR_MODE_ONLINE							1
#define MSMCOMM_OPERATOR_MODE_OFFLINE							2
#define MSMCOMM_OPERATOR_MODE_PWROFF							3
#define MSMCOMM_OPERATOR_MODE_LPM								4
#define MSMCOMM_OPERATOR_MODE_LPM_DEFAULT						5

struct msmcomm_context;
struct msmcomm_message;

typedef void (*msmcomm_event_handler_cb) (struct msmcomm_context *ctx, int event, struct msmcomm_message *message);
typedef void (*msmcomm_write_handler_cb) (struct msmcomm_context *ctx, uint8_t *data, uint32_t len);

struct msmcomm_context
{
	msmcomm_event_handler_cb event_cb;
	msmcomm_write_handler_cb write_cb;
};

int			msmcomm_init(struct msmcomm_context *ctx);
int			msmcomm_shutdown(struct msmcomm_context *ctx);
int			msmcomm_read_from_modem(struct msmcomm_context *ctx, int fd);
int			msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg);
void		msmcomm_register_event_handler(struct msmcomm_context *ctx, msmcomm_event_handler_cb event_handler);
void		msmcomm_register_write_handler(struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler);

struct		msmcomm_message* msmcomm_create_message(struct msmcomm_context *ctx, unsigned int type);
uint32_t	msmcomm_message_get_size(struct msmcomm_message *msg);
uint32_t	msmcomm_message_get_type(struct msmcomm_message *msg);

void		msmcomm_message_change_operation_mode_set_operator_mode(struct msmcomm_message *msg, uint8_t operator_mode);
void		msmcomm_message_get_firmware_info_get_info(struct msmcomm_message *msg, char *buffer, int len);

#endif

