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
#define MSMCOMM_MESSAGE_CMD_VERIFY_PIN							6
#define MSMCOMM_MESSAGE_CMD_GET_VOICEMAIL_NR					7
#define MSMCOMM_MESSAGE_CMD_GET_LOCATION_PRIV_PREF				8
#define MSMCOMM_MESSAGE_CMD_ANSWER_CALL							9
#define MSMCOMM_MESSAGE_CMD_SET_AUDIO_PROFILE					10
#define MSMCOMM_MESSAGE_CMD_END_CALL							11
#define MSMCOMM_MESSAGE_CMD_GET_CHARGER_STATUS 					12
#define MSMCOMM_MESSAGE_CMD_CHARGE_USB							13

#define MSMCOMM_RESPONSE_TEST_ALIVE								101
#define MSMCOMM_RESPONSE_GET_FIRMWARE_INFO						102
#define MSMCOMM_RESPONSE_GET_IMEI								103
#define MSMCOMM_RESPONSE_PDSM_PD_GET_POS						104
#define MSMCOMM_RESPONSE_PDSM_PD_END_SESSION					105
#define MSMCOMM_RESPONSE_PA_SET_PARAM							106
#define MSMCOMM_RESPONSE_LCS_AGENT_CLIENT_RSP					107
#define MSMCOMM_RESPONSE_XTRA_SET_DATA							108
#define MSMCOMM_RESPONSE_GET_SIM_CAPABILITIES					110
#define MSMCOMM_RESPONSE_GET_VOICEMAIL_NR						111
#define MSMCOMM_RESPONSE_SOUND									112
#define MSMCOMM_RESPONSE_CM_CALL 								113
#define MSMCOMM_RESPONSE_GET_CHARGER_STATUS 					114
#define MSMCOMM_RESPONSE_CHARGE_USB								115

#define MSMCOMM_EVENT_RESET_RADIO_IND							201
#define MSMCOMM_EVENT_CHARGER_STATUS							202
#define MSMCOMM_EVENT_OPERATOR_MODE								206
#define MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE						207
#define MSMCOMM_EVENT_POWER_STATE								215
#define MSMCOMM_EVENT_CM_SS										217

/*
 * GPS events
 */
#define MSMCOMM_EVENT_PDSM_PD_DONE								208
#define MSMCOMM_EVENT_PD_POSITION_DATA							209
#define MSMCOMM_EVENT_PD_PARAMETER_CHANGE						210
#define MSMCOMM_EVENT_PDSM_LCS									211
#define MSMCOMM_EVENT_PDSM_XTRA									212

/*
 * Call events
 */
#define MSMCOMM_EVENT_CALL_STATUS								216
#define MSMCOMM_EVENT_CALL_INCOMMING							218
#define MSMCOMM_EVENT_CALL_ORIGINATION							219
#define MSMCOMM_EVENT_CALL_CONNECT								220
#define MSMCOMM_EVENT_CALL_END									221

/*
 * SIM events
 */
#define MSMCOMM_EVNET_SIM_INSERTED								222
#define MSMCOMM_EVENT_SIM_PIN1_VERIFIED							223
#define MSMCOMM_EVENT_SIM_PIN1_BLOCKED 							224
#define MSMCOMM_EVENT_SIM_PIN1_UNBLOCKED 						225
#define MSMCOMM_EVENT_SIM_PIN1_ENABLED 							226
#define MSMCOMM_EVENT_SIM_PIN1_DISABLED 						227
#define MSMCOMM_EVENT_SIM_PIN1_CHANGED 							228
#define MSMCOMM_EVENT_SIM_PIN1_PERM_BLOCKED 					229
#define MSMCOMM_EVENT_SIM_PIN2_VERIFIED							230
#define MSMCOMM_EVENT_SIM_PIN2_BLOCKED 							231
#define MSMCOMM_EVENT_SIM_PIN2_UNBLOCKED 						232
#define MSMCOMM_EVENT_SIM_PIN2_ENABLED 							233
#define MSMCOMM_EVENT_SIM_PIN2_DISABLED 						234
#define MSMCOMM_EVENT_SIM_PIN2_CHANGED 							235
#define MSMCOMM_EVENT_SIM_PIN2_PERM_BLOCKED 					236
#define MSMCOMM_EVENT_SIM_REFRESH_RESET 						237
#define MSMCOMM_EVENT_SIM_REFRESH_INIT							238
#define MSMCOMM_EVENT_SIM_REFRESH_INIT_FCN						239
#define MSMCOMM_EVENT_SIM_REFRESH_FAILED 						240
#define MSMCOMM_EVENT_SIM_FDN_ENABLE							241
#define MSMCOMM_EVENT_SIM_FDN_DISABLE 							242
#define MSMCOMM_EVENT_SIM_ILLEGAL 								243
#define MSMCOMM_EVENT_SIM_REMOVED 								244
#define MSMCOMM_EVENT_SIM_NO_SIM_EVENT 							245
#define MSMCOMM_EVENT_SIM_NO_SIM 								246
#define MSMCOMM_EVENT_SIM_DRIVER_ERROR 							247
#define MSMCOMM_EVENT_SIM_INTERNAL_RESET 						248
#define MSMCOMM_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL 			249
#define MSMCOMM_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL 		250
#define MSMCOMM_EVENT_SIM_INIT_COMPLETED_NO_PROV 				251
#define MSMCOMM_EVENT_SIM_MEMORY_WARNING 						252
#define MSMCOMM_EVENT_SIM_SIM2_EVENT 							253
#define MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE					254
#define MSMCOMM_EVENT_SIM_CARD_ERROR 							255
#define MSMCOMM_EVENT_SIM_NO_EVENT								256
#define MSMCOMM_EVENT_SIM_GET_PERSO_NW_FAILURE 					257
#define MSMCOMM_EVENT_SIM_GET_PERSO_NW_BLOCKED 					258
#define MSMCOMM_EVENT_SIM_REFRESH_APP_RESET 					259
#define MSMCOMM_EVENT_SIM_REFRESH_3G_SESSION_RESET 				260
#define MSMCOMM_EVENT_SIM_APP_SELECTED 							261
#define MSMCOMM_EVENT_SIM_DEFAULT 								262


/*
 * Operation modes
 */
#define MSMCOMM_OPERATION_MODE_RESET							0
#define MSMCOMM_OPERATION_MODE_ONLINE							1
#define MSMCOMM_OPERATION_MODE_OFFLINE							2
#define MSMCOMM_OPERATION_MODE_PWROFF							3
#define MSMCOMM_OPERATION_MODE_LPM								4
#define MSMCOMM_OPERATION_MODE_LPM_DEFAULT						5

/*
 * USB charging modes
 */
#define MSMCOMM_CHARGE_USB_MODE_250mA							1
#define MSMCOMM_CHARGE_USB_MODE_500mA	 						2
#define MSMCOMM_CHARGE_USB_MODE_1A								3

struct msmcomm_context;
struct msmcomm_message;

typedef void (*msmcomm_event_handler_cb) (struct msmcomm_context *ctx, int event, struct msmcomm_message *message);
typedef void (*msmcomm_write_handler_cb) (struct msmcomm_context *ctx, uint8_t *data, uint32_t len);

struct msmcomm_context
{
	msmcomm_event_handler_cb event_cb;
	msmcomm_write_handler_cb write_cb;
};

int				msmcomm_init
	(struct msmcomm_context *ctx);
int				msmcomm_shutdown
	(struct msmcomm_context *ctx);
int				msmcomm_read_from_modem
	(struct msmcomm_context *ctx, int fd);
int				msmcomm_send_message
	(struct msmcomm_context *ctx, struct msmcomm_message *msg);
unsigned int 	msmcomm_check_hci_version
	(unsigned int hci_version);
void			msmcomm_register_event_handler
	(struct msmcomm_context *ctx, msmcomm_event_handler_cb event_handler);
void			msmcomm_register_write_handler
	(struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler);

/**
 * These are common operations which are valid for all kind of messages
 */
struct			msmcomm_message* msmcomm_create_message
	(struct msmcomm_context *ctx, unsigned int type);
uint32_t		msmcomm_message_get_size
	(struct msmcomm_message *msg);
uint32_t		msmcomm_message_get_type
	(struct msmcomm_message *msg);
uint8_t 		msmcomm_message_get_ref_id
	(struct msmcomm_message *msg);

/**
 * These are message/response/event specific operations which only should be
 * executed on the right message!
 */
void			msmcomm_message_change_operation_mode_set_operation_mode
	(struct msmcomm_message *msg, uint8_t operation_mode);
void			msmcomm_message_verify_pin_set_pin
	(struct msmcomm_message *msg, uint8_t *pin, int len);
void 			msmcomm_message_charge_usb_set_mode
	(struct msmcomm_message *msg, unsigned int mode);
void msmcomm_message_end_call_set_call_number
	(struct msmcomm_message *msg, uint8_t call_nr);

void			msmcomm_resp_get_firmware_info_get_info
	(struct msmcomm_message *msg, char *buffer, int len);
uint8_t 		msmcomm_resp_get_firmware_info_get_hci_versioni
	(struct msmcomm_message *msg);
void 			msmcomm_resp_get_imei_get_imei
	(struct msmcomm_message *msg, uint8_t *buffer);
unsigned int 	msmcomm_resp_charge_usb_get_voltage
	(struct msmcomm_message *msg);

uint8_t 		msmcomm_event_power_state_get_state
	(struct msmcomm_message *msg);
void 			msmcomm_event_call_status_get_number
	(struct msmcomm_message *msg, uint8_t *buffer, unsigned int len);
unsigned int 	msmcomm_event_charger_status_get_voltage
	(struct msmcomm_message *msg);

#endif

