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

#include <stdint.h>

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
#define MSMCOMM_MESSAGE_CMD_GET_CHARGER_STATUS					12
#define MSMCOMM_MESSAGE_CMD_CHARGING							13
#define MSMCOMM_MESSAGE_CMD_DIAL_CALL							14

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
#define MSMCOMM_RESPONSE_CHARGER_STATUS							114
#define MSMCOMM_RESPONSE_CHARGING								115

#define MSMCOMM_EVENT_RESET_RADIO_IND							201
#define MSMCOMM_EVENT_CHARGER_STATUS							202
#define MSMCOMM_EVENT_OPERATION_MODE							206
#define MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE						207
#define MSMCOMM_EVENT_POWER_STATE								215
#define MSMCOMM_EVENT_NETWORK_STATE_INFO						217

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
#define MSMCOMM_EVENT_SIM_INSERTED								222
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
 * SUPS / USS events
 */
#define MSMCOMM_EVENT_SUPS_PROCESS_USS							263
#define MSMCOMM_EVENT_SUPS_PROCESS_USS_CONF						264
#define MSMCOMM_EVENT_SUPS_USS_RES								265
#define MSMCOMM_EVENT_SUPS_RELEASE_USS_IND						266
#define MSMCOMM_EVENT_SUPS_USS_NOTIFY_IND						267
#define MSMCOMM_EVENT_SUPS_USS_NOTIFY_RES						268
#define MSMCOMM_EVENT_SUPS_RELEASE								269
#define MSMCOMM_EVENT_SUPS_ABORT								270
#define MSMCOMM_EVENT_SUPS_ERASE								271
#define MSMCOMM_EVENT_SUPS_REGISTER								272
#define MSMCOMM_EVENT_SUPS_REGISTER_CONF						273
#define MSMCOMM_EVENT_SUPS_GET_PASSWORD_IN						274
#define MSMCOMM_EVENT_SUPS_GET_PASSWORD_RES						275
#define MSMCOMM_EVENT_SUPS_INTERROGATE							276
#define MSMCOMM_EVENT_SUPS_INTERROGATE_CONF						277
#define MSMCOMM_EVENT_SUPS_ACTIVATE								278
#define MSMCOMM_EVENT_SUPS_ACTIVATE_CONF						279
#define MSMCOMM_EVENT_SUPS_DEACTIVATE							280
#define MSMCOMM_EVENT_SUPS_DEACTIVATE_CONF						281

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
 * Charging modes
 */
#define MSMCOMM_CHARGING_MODE_USB								0
#define MSMCOMM_CHARGING_MODE_INDUCTIVE							1

/*
 * Charging voltages (only for USB mode)
 */
#define MSMCOMM_CHARGING_VOLTAGE_MODE_250mA						1
#define MSMCOMM_CHARGING_VOLTAGE_MODE_500mA						2
#define MSMCOMM_CHARGING_VOLTAGE_MODE_1A						3

/*
 * Network State Info changed field types
 */
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_INVALID								0
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SID									1
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_NID									2
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PACKET_ZONE							3
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_REGISTRATION_ZONE						4
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASESTATION_P_REV						5
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVICE_DOMAIN						6
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_CONCURRENT_SERVICES_SUPPORTED			7
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_P_REV_IN_USE							8
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVING_STATUS						9
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_SERVICE_CAPABILITY				10
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_MODE							11
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_ROAMING_STATUS						12
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_ID								13
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERICE_INDICATOR						14
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_MOBILITY_MANAGEMENT					15
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_HDR									16
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SIM_CARD_STATUS						17
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PLMN									18
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PS_DATA_SUSPEND_MASK					19
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_UZ									20
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS									21
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASE_STATION_PARAMETERS_CHANGED		22
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FILED_TYPE_ORIGINATION_STATUS					23

/*
 * Some other usefull constants 
 */
#define MSMCOMM_DEFAULT_PLMN_LENGTH 														3

/*
 * Error codes
 */
#define MSMCOMM_ERROR_GROUPID_NOT_SUPPORTED													1
#define MSMCOMM_ERROR_MSGID_NOT_SUPPORTED													2
#define MSMCOMM_ERROR_INVALID_PAYLOAD_LENGTH												3

struct msmcomm_context;
struct msmcomm_message;

typedef void (*msmcomm_event_handler_cb)
	(void *user_data, int event, struct msmcomm_message *message);
typedef void (*msmcomm_write_handler_cb)
	(void *user_data, uint8_t *data, uint32_t len);
typedef int  (*msmcomm_read_handler_cb)
	(void *user_data, uint8_t *data, uint32_t len);
typedef void (*msmcomm_log_handler_cb)
	(void *user_data, char *buffer, unsigned int len);
typedef void (*msmcomm_error_handler_cb)
	(void *user_data, int error, void *data);
typedef void (*msmcomm_network_state_info_changed_field_type_cb)
	(void *user_data, struct msmcomm_message *msg, int type);

struct msmcomm_context
{
	msmcomm_event_handler_cb event_cb;
	msmcomm_write_handler_cb write_cb;
	msmcomm_read_handler_cb read_cb;
	msmcomm_log_handler_cb log_cb;
	msmcomm_error_handler_cb error_cb;

	void *event_data;
	void *write_data;
	void *read_data;
	void *error_data;
	void *log_data;
};

int msmcomm_launch_daemon(const char *workdir, char *argv[], int argc);
int msmcomm_is_daemon_running();
int msmcomm_shutdown_daemon();

int				msmcomm_init
	(struct msmcomm_context *ctx);
int				msmcomm_shutdown
	(struct msmcomm_context *ctx);
int				msmcomm_read_from_modem
	(struct msmcomm_context *ctx);
int				msmcomm_send_message
	(struct msmcomm_context *ctx, struct msmcomm_message *msg);
unsigned int 	msmcomm_check_hci_version
	(unsigned int hci_version);
void			msmcomm_register_event_handler
	(struct msmcomm_context *ctx, msmcomm_event_handler_cb event_handler, void *data);
void			msmcomm_register_write_handler
	(struct msmcomm_context *ctx, msmcomm_write_handler_cb write_handler, void *data);
void			msmcomm_register_read_handler
	(struct msmcomm_context *ctx, msmcomm_read_handler_cb read_handler, void *data);
void			msmcomm_register_error_handler
	(struct msmcomm_context *ctx, msmcomm_error_handler_cb error_handler, void *data);
void			msmcomm_register_log_handler
	(struct msmcomm_context *ctx, msmcomm_log_handler_cb log_handler, void *data);

/**
 * These are common operations which are valid for all kind of messages
 */
struct msmcomm_message* msmcomm_create_message
	(unsigned int type);
struct msmcomm_message* msmcomm_message_make_copy
	(struct msmcomm_message *msg);
uint32_t		msmcomm_message_get_size
	(struct msmcomm_message *msg);
uint32_t		msmcomm_message_get_type
	(struct msmcomm_message *msg);
uint32_t 		msmcomm_message_get_ref_id
	(struct msmcomm_message *msg);
void			msmcomm_message_set_ref_id
	(struct msmcomm_message *msg, uint32_t ref_id);

/**
 * These are message/response/event specific operations which only should be
 * executed on the right message!
 */

/* System messages --------------------------------- */
void msmcomm_message_change_operation_mode_set_operation_mode
	(struct msmcomm_message *msg, uint8_t operation_mode);

void msmcomm_message_charging_set_voltage
	(struct msmcomm_message *msg, unsigned int voltage);

void msmcomm_message_charging_set_mode
	(struct msmcomm_message *msg, unsigned int mode);


/* Call messages ------------------------------------ */
void msmcomm_message_end_call_set_call_number
	(struct msmcomm_message *msg, uint8_t call_nr);

void msmcomm_message_dial_call_set_caller_id
	(struct msmcomm_message *msg, uint8_t *caller_id, uint8_t len);

/* SIM messages ------------------------------------ */
void			msmcomm_message_verify_pin_set_pin
	(struct msmcomm_message *msg, const char* pin);

/* System responses -------------------------------- */
char*			msmcomm_resp_get_firmware_info_get_info
	(struct msmcomm_message *msg);

uint8_t 		msmcomm_resp_get_firmware_info_get_hci_version
	(struct msmcomm_message *msg);

char* 			msmcomm_resp_get_imei_get_imei
	(struct msmcomm_message *msg);

unsigned int 	msmcomm_resp_charging_get_voltage
	(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charging_get_mode
	(struct msmcomm_message *msg);

unsigned int 	msmcomm_resp_charger_status_get_voltage
	(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charger_status_get_mode
	(struct msmcomm_message *msg);

/* Call responses ---------------------------------- */
uint16_t msmcomm_resp_cm_call_get_error_code(struct msmcomm_message *msg);
uint16_t msmcomm_resp_cm_call_get_cmd(struct msmcomm_message *msg);


/* System events ----------------------------------- */
uint8_t 		msmcomm_event_power_state_get_state
	(struct msmcomm_message *msg);
unsigned int 	msmcomm_event_charger_status_get_voltage
	(struct msmcomm_message *msg);

/* Call events ------------------------------------- */
char* msmcomm_event_call_status_get_caller_id(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_reject_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_reject_value(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_call_id(struct msmcomm_message *msg);

/* Network events ---------------------------------- */
uint32_t msmcomm_event_network_state_info_get_change_field
	(struct msmcomm_message *msg);

uint8_t msmcomm_event_network_state_info_get_new_value
	(struct msmcomm_message *msg);

uint8_t* msmcomm_event_network_state_info_get_plmn
	(struct msmcomm_message *msg);

char* msmcomm_event_network_state_info_get_operator_name
	(struct msmcomm_message *msg);

uint16_t msmcomm_event_network_state_info_get_rssi
	(struct msmcomm_message *msg);

uint16_t msmcomm_event_network_state_info_get_ecio
	(struct msmcomm_message *msg);

void msmcomm_event_network_state_info_trace_changes
	(struct msmcomm_message *msg, msmcomm_network_state_info_changed_field_type_cb type_handler, void *user_data);

uint8_t msmcomm_event_network_state_info_get_service_domain
	(struct msmcomm_message *msg);

uint8_t msmcomm_event_network_state_info_get_service_capability
	(struct msmcomm_message *msg);

uint8_t msmcomm_event_network_state_info_get_gprs_attached
	(struct msmcomm_message *msg);

uint16_t msmcomm_event_network_state_info_get_roam
	(struct msmcomm_message *msg);

/* 
 * Frame handling
 */
struct msmcomm_frame;
struct msmcomm_frame * msmcomm_frame_new();
void msmcomm_frame_free(struct msmcomm_frame *fr);
struct msmcomm_frame * msmcomm_frame_new_from_buffer(uint8_t *buffer, uint32_t length);
void msmcomm_frame_set_payload(struct msmcomm_frame *fr, uint8_t *payload, uint32_t length);
void msmcomm_frame_set_address(struct msmcomm_frame *fr, uint8_t addr);
void msmcomm_frame_set_type(struct msmcomm_frame *fr, uint8_t type);
void msmcomm_frame_set_sequence_nr(struct msmcomm_frame *fr, uint8_t seq);
void msmcomm_frame_set_acknowledge_nr(struct msmcomm_frame *fr, uint8_t ack);
uint8_t msmcomm_frame_get_address(struct msmcomm_frame *fr);
uint8_t msmcomm_frame_get_type(struct msmcomm_frame *fr);
uint8_t msmcomm_frame_get_sequence_nr(struct msmcomm_frame *fr);
uint8_t msmcomm_frame_get_acknowledge_nr(struct msmcomm_frame *fr);
uint32_t msmcomm_frame_get_payload_length(struct msmcomm_frame *fr);
uint8_t* msmcomm_frame_get_payload(struct msmcomm_frame *fr, int *length);
uint8_t msmcomm_frame_is_valid(struct msmcomm_frame *fr);
void msmcomm_frame_encode(struct msmcomm_frame *fr);
void msmcomm_frame_decode(struct msmcomm_frame *fr);

#endif

