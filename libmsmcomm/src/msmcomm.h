
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

#define MSMCOMM_MESSAGE_TYPE_NONE                                   0
#define MSMCOMM_MESSAGE_TYPE_COMMAND                                1
#define MSMCOMM_MESSAGE_TYPE_RESPONSE                               2
#define MSMCOMM_MESSAGE_TYPE_EVENT                                  3

#define MSMCOMM_MESSAGE_INVALID                                     0
#define MSMCOMM_MESSAGE_NOT_USED                                    1

#define MSMCOMM_COMMAND_CHANGE_OPERATION_MODE                       10
#define MSMCOMM_COMMAND_GET_IMEI                                    12
#define MSMCOMM_COMMAND_GET_FIRMWARE_INFO                           13
#define MSMCOMM_COMMAND_TEST_ALIVE                                  14
#define MSMCOMM_COMMAND_GET_PHONE_STATE_INFO                        15
#define MSMCOMM_COMMAND_VERIFY_PIN                                  16
#define MSMCOMM_COMMAND_GET_VOICEMAIL_NR                            17
#define MSMCOMM_COMMAND_GET_LOCATION_PRIV_PREF                      18
#define MSMCOMM_COMMAND_ANSWER_CALL                                 19
#define MSMCOMM_COMMAND_SET_AUDIO_PROFILE                           20
#define MSMCOMM_COMMAND_END_CALL                                    21
#define MSMCOMM_COMMAND_GET_CHARGER_STATUS                          22
#define MSMCOMM_COMMAND_CHARGING                                    23
#define MSMCOMM_COMMAND_DIAL_CALL                                   24
#define MSMCOMM_COMMAND_SET_SYSTEM_TIME                             25
#define MSMCOMM_COMMAND_RSSI_STATUS                                 26
#define MSMCOMM_COMMAND_READ_PHONEBOOK                              27
#define MSMCOMM_COMMAND_GET_NETWORKLIST                             28
#define MSMCOMM_COMMAND_SET_MODE_PREFERENCE                         29
#define MSMCOMM_COMMAND_GET_PHONEBOOK_PROPERTIES                    30
#define MSMCOMM_COMMAND_WRITE_PHONEBOOK                             31
#define MSMCOMM_COMMAND_DELETE_PHONEBOOK                            32
#define MSMCOMM_COMMAND_CHANGE_PIN                                  33
#define MSMCOMM_COMMAND_ENABLE_PIN                                  34
#define MSMCOMM_COMMAND_DISABLE_PIN                                 35
#define MSMCOMM_COMMAND_SIM_INFO                                    36
#define MSMCOMM_COMMAND_GET_AUDIO_MODEM_TUNING_PARAMS               37
#define MSMCOMM_COMMAND_SMS_ACKNOWLDEGE_INCOMMING_MESSAGE           38

#define MSMCOMM_RESPONSE_TEST_ALIVE                                 101
#define MSMCOMM_RESPONSE_GET_FIRMWARE_INFO                          102
#define MSMCOMM_RESPONSE_GET_IMEI                                   103
#define MSMCOMM_RESPONSE_PDSM_PD_GET_POS                            104
#define MSMCOMM_RESPONSE_PDSM_PD_END_SESSION                        105
#define MSMCOMM_RESPONSE_PA_SET_PARAM                               106
#define MSMCOMM_RESPONSE_LCS_AGENT_CLIENT_RSP                       107
#define MSMCOMM_RESPONSE_XTRA_SET_DATA                              108
#define MSMCOMM_RESPONSE_SIM                                        110
#define MSMCOMM_RESPONSE_GET_VOICEMAIL_NR                           111
#define MSMCOMM_RESPONSE_SOUND                                      112
#define MSMCOMM_RESPONSE_CM_CALL                                    113
#define MSMCOMM_RESPONSE_CHARGER_STATUS                             114
#define MSMCOMM_RESPONSE_CHARGING                                   115
#define MSMCOMM_RESPONSE_CM_PH                                      116
#define MSMCOMM_RESPONSE_SET_SYSTEM_TIME                            117
#define MSMCOMM_RESPONSE_RSSI_STATUS                                118
#define MSMCOMM_RESPONSE_PHONEBOOK                                  119
#define MSMCOMM_RESPONSE_GET_PHONEBOOK_PROPERTIES                   120
#define MSMCOMM_RESPONSE_AUDIO_MODEM_TUNING_PARAMS                  121

#define MSMCOMM_EVENT_RESET_RADIO_IND                               201
#define MSMCOMM_EVENT_CHARGER_STATUS                                202
#define MSMCOMM_EVENT_OPERATION_MODE                                 206
#define MSMCOMM_EVENT_CM_PH_INFO_AVAILABLE                          207
#define MSMCOMM_EVENT_NETWORK_STATE_INFO                            217

/*
 * GPS events
 */
#define MSMCOMM_EVENT_PDSM_PD_DONE                                  208
#define MSMCOMM_EVENT_PD_POSITION_DATA                              209
#define MSMCOMM_EVENT_PD_PARAMETER_CHANGE                           210
#define MSMCOMM_EVENT_PDSM_LCS                                      211
#define MSMCOMM_EVENT_PDSM_XTRA                                     212

/*
 * Call events
 */
#define MSMCOMM_EVENT_CALL_STATUS                                   216
#define MSMCOMM_EVENT_CALL_INCOMMING                                218
#define MSMCOMM_EVENT_CALL_ORIGINATION                              219
#define MSMCOMM_EVENT_CALL_CONNECT                                  220
#define MSMCOMM_EVENT_CALL_END                                      221

/*
 * SIM events
 */
#define MSMCOMM_EVENT_SIM_INSERTED                                  222
#define MSMCOMM_EVENT_SIM_PIN1_VERIFIED                             223
#define MSMCOMM_EVENT_SIM_PIN1_BLOCKED                              224
#define MSMCOMM_EVENT_SIM_PIN1_UNBLOCKED                            225
#define MSMCOMM_EVENT_SIM_PIN1_ENABLED                              226
#define MSMCOMM_EVENT_SIM_PIN1_DISABLED                             227
#define MSMCOMM_EVENT_SIM_PIN1_CHANGED                              228
#define MSMCOMM_EVENT_SIM_PIN1_PERM_BLOCKED                         229
#define MSMCOMM_EVENT_SIM_PIN2_VERIFIED                             230
#define MSMCOMM_EVENT_SIM_PIN2_BLOCKED                              231
#define MSMCOMM_EVENT_SIM_PIN2_UNBLOCKED                            232
#define MSMCOMM_EVENT_SIM_PIN2_ENABLED                              233
#define MSMCOMM_EVENT_SIM_PIN2_DISABLED                             234
#define MSMCOMM_EVENT_SIM_PIN2_CHANGED                              235
#define MSMCOMM_EVENT_SIM_PIN2_PERM_BLOCKED                         236
#define MSMCOMM_EVENT_SIM_REFRESH_RESET                             237
#define MSMCOMM_EVENT_SIM_REFRESH_INIT                              238
#define MSMCOMM_EVENT_SIM_REFRESH_INIT_FCN                          239
#define MSMCOMM_EVENT_SIM_REFRESH_FAILED                            240
#define MSMCOMM_EVENT_SIM_FDN_ENABLE                                241
#define MSMCOMM_EVENT_SIM_FDN_DISABLE                               242
#define MSMCOMM_EVENT_SIM_ILLEGAL                                   243
#define MSMCOMM_EVENT_SIM_REMOVED                                   244
#define MSMCOMM_EVENT_SIM_NO_SIM_EVENT                              245
#define MSMCOMM_EVENT_SIM_NO_SIM                                    246
#define MSMCOMM_EVENT_SIM_DRIVER_ERROR                              247
#define MSMCOMM_EVENT_SIM_INTERNAL_RESET                            248
#define MSMCOMM_EVENT_SIM_OK_FOR_TERMINAL_PROFILE_DL                249
#define MSMCOMM_EVENT_SIM_NOT_OK_FOR_TERMINAL_PROFILE_DL            250
#define MSMCOMM_EVENT_SIM_INIT_COMPLETED_NO_PROV                    251
#define MSMCOMM_EVENT_SIM_MEMORY_WARNING                            252
#define MSMCOMM_EVENT_SIM_SIM2_EVENT                                253
#define MSMCOMM_EVENT_SIM_REAL_RESET_FAILURE                        254
#define MSMCOMM_EVENT_SIM_CARD_ERROR                                255
#define MSMCOMM_EVENT_SIM_NO_EVENT                                  256
#define MSMCOMM_EVENT_SIM_GET_PERSO_NW_FAILURE                      257
#define MSMCOMM_EVENT_SIM_GET_PERSO_NW_BLOCKED                      258
#define MSMCOMM_EVENT_SIM_REFRESH_APP_RESET                         259
#define MSMCOMM_EVENT_SIM_REFRESH_3G_SESSION_RESET                  260
#define MSMCOMM_EVENT_SIM_APP_SELECTED                              261
#define MSMCOMM_EVENT_SIM_DEFAULT                                   262

/*
 * SUPS / USS events
 */
#define MSMCOMM_EVENT_SUPS_PROCESS_USS                              263
#define MSMCOMM_EVENT_SUPS_PROCESS_USS_CONF                         264
#define MSMCOMM_EVENT_SUPS_USS_RES                                  265
#define MSMCOMM_EVENT_SUPS_RELEASE_USS_IND                          266
#define MSMCOMM_EVENT_SUPS_USS_NOTIFY_IND                           267
#define MSMCOMM_EVENT_SUPS_USS_NOTIFY_RES                           268
#define MSMCOMM_EVENT_SUPS_RELEASE                                  269
#define MSMCOMM_EVENT_SUPS_ABORT                                    270
#define MSMCOMM_EVENT_SUPS_ERASE                                    271
#define MSMCOMM_EVENT_SUPS_REGISTER                                 272
#define MSMCOMM_EVENT_SUPS_REGISTER_CONF                            273
#define MSMCOMM_EVENT_SUPS_GET_PASSWORD_IN                          274
#define MSMCOMM_EVENT_SUPS_GET_PASSWORD_RES                         275
#define MSMCOMM_EVENT_SUPS_INTERROGATE                              276
#define MSMCOMM_EVENT_SUPS_INTERROGATE_CONF                         277
#define MSMCOMM_EVENT_SUPS_ACTIVATE                                 278
#define MSMCOMM_EVENT_SUPS_ACTIVATE_CONF                            279
#define MSMCOMM_EVENT_SUPS_DEACTIVATE                               280
#define MSMCOMM_EVENT_SUPS_DEACTIVATE_CONF                          281

/*
 * SMS Events
 */
#define MSMCOMM_EVENT_SMS_WMS_CFG_MESSAGE_LIST                      282
#define MSMCOMM_EVENT_SMS_WMS_CFG_GW_DOMAIN_PREF                    283
#define MSMCOMM_EVENT_SMS_WMS_CFG_EVENT_ROUTES                      284
#define MSMCOMM_EVENT_SMS_WMS_CFG_MEMORY_STATUS                     285
#define MSMCOMM_EVENT_SMS_WMS_CFG_MEMORY_STATUS_SET                 286
#define MSMCOMM_EVENT_SMS_WMS_CFG_GW_READY                          287

#define MSMCOMM_EVENT_SMS_WMS_READ_TEMPLATE                         288

#define MSMCOMM_EVENT_GET_NETWORKLIST                               289

/*
 * Phonebook events
 */
#define MSMCOMM_EVENT_PHONEBOOK_READY                               290
#define MSMCOMM_EVENT_PHONEBOOK_MODIFIED                            291

#define MSMCOMM_EVENT_CM_PH                                         292
#define MSMCOMM_EVENT_SMS_RECEIVED_MESSAGE                          291

/*
 * Phonebook types
 */

#define MSMCOMM_PHONEBOOK_TYPE_NONE                                 0
#define MSMCOMM_PHONEBOOK_TYPE_ADN                                  1
#define MSMCOMM_PHONEBOOK_TYPE_FDN                                  2
#define MSMCOMM_PHONEBOOK_TYPE_SDN                                  3
#define MSMCOMM_PHONEBOOK_TYPE_EFECC                                4
#define MSMCOMM_PHONEBOOK_TYPE_MBDN                                 5
#define MSMCOMM_PHONEBOOK_TYPE_MBN                                  6
#define MSMCOMM_PHONEBOOK_TYPE_ALL                                  7
#define MSMCOMM_PHONEBOOK_TYPE_TEST1                                8

/*
 * Operation modes
 */
#define MSMCOMM_OPERATION_MODE_RESET                                0
#define MSMCOMM_OPERATION_MODE_ONLINE                               1
#define MSMCOMM_OPERATION_MODE_OFFLINE                              2
#define MSMCOMM_OPERATION_MODE_PWROFF                               3
#define MSMCOMM_OPERATION_MODE_LPM                                  4
#define MSMCOMM_OPERATION_MODE_LPM_DEFAULT                          5

/*
 * Charging modes
 */
#define MSMCOMM_CHARGING_MODE_USB                                   0
#define MSMCOMM_CHARGING_MODE_INDUCTIVE                             1

/*
 * Charging voltages (only for USB mode)
 */
#define MSMCOMM_CHARGING_VOLTAGE_MODE_250mA                         1
#define MSMCOMM_CHARGING_VOLTAGE_MODE_500mA                         2
#define MSMCOMM_CHARGING_VOLTAGE_MODE_1A                            3

/*
 * Network State Info changed field types
 */
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_INVALID                               0
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SID                                   1
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_NID                                   2
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PACKET_ZONE                           3
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_REGISTRATION_ZONE                     4
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASESTATION_P_REV                     5
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVICE_DOMAIN                        6
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_CONCURRENT_SERVICES_SUPPORTED         7
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_P_REV_IN_USE                          8
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERVING_STATUS                        9
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_SERVICE_CAPABILITY             10
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_MODE                           11
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_ROAMING_STATUS                        12
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SYSTEM_ID                             13
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SERICE_INDICATOR                      14
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_MOBILITY_MANAGEMENT                   15
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_HDR                                   16
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_SIM_CARD_STATUS                       17
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PLMN                                  18
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_PS_DATA_SUSPEND_MASK                  19
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_UZ                                    20
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BCMS                                  21
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FIELD_TYPE_BASE_STATION_PARAMETERS_CHANGED       22
#define MSMCOMM_NETWORK_STATE_INFO_CHANGED_FILED_TYPE_ORIGINATION_STATUS                    23

/*
 * Some other usefull constants 
 */
#define MSMCOMM_DEFAULT_PLMN_LENGTH                                 3

/*
 * Error codes
 */
#define MSMCOMM_ERROR_GROUPID_NOT_SUPPORTED                         1
#define MSMCOMM_ERROR_MSGID_NOT_SUPPORTED                           2
#define MSMCOMM_ERROR_INVALID_PAYLOAD_LENGTH                        3

/*
 * Message result codes
 */
#define MSMCOMM_RESULT_NONE                                         1
#define MSMCOMM_RESULT_OK                                           2

/* NOTE: Every result code >= MSMCOMM_RESULT_ERROR should be an error! */
#define MSMCOMM_RESULT_ERROR                                        10
#define MSMCOMM_RESULT_READ_SIMBOOK_INVALID_RECORD_ID               11
#define MSMCOMM_RESULT_SIM_BAD_STATE                                12
#define MSMCOMM_RESULT_BAD_CALL_ID                                  13
#define MSMCOMM_RESULT_INVALID_AUDIO_PROFILE                        14

/*
 * Encoding types
 */
#define MSMCOMM_ENCODING_TYPE_NONE                                  1
#define MSMCOMM_ENCODING_TYPE_ASCII                                 2
#define MSMCOMM_ENCODING_TYPE_BUCS2                                 3

/*
 * Network modes
 */
#define MSMCOMM_NETWORK_MODE_AUTOMATIC                              1
#define MSMCOMM_NETWORK_MODE_GSM                                    2
#define MSMCOMM_NETWORK_MODE_UMTS                                   3

/*
 * Call types
 */
#define MSMCOMM_CALL_TYPE_NONE                                      0
#define MSMCOMM_CALL_TYPE_DATA                                      1
#define MSMCOMM_CALL_TYPE_AUDIO                                     2

/*
 * SIM Pin Types
 */
#define MSMCOMM_SIM_PIN_NONE                                        0
#define MSMCOMM_SIM_PIN_1                                           1
#define MSMCOMM_SIM_PIN_2                                           2

/*
 * SIM Field Types
 */
#define MSMCOMM_SIM_INFO_FIELD_TYPE_NONE                            0
#define MSMCOMM_SIM_INFO_FIELD_TYPE_IMSI                            1
#define MSMCOMM_SIM_INFO_FIELD_TYPE_MSISDN                          2

/*
 * Some constants
 */
#define MSMCOMM_MAX_IMSI_LENGTH                                     15
#define MSMCOMM_AUDIO_MODEM_TUNING_PARAMS_LENGTH                    16

struct msmcomm_context;

struct msmcomm_message;

typedef void (*msmcomm_event_handler_cb)
    (void *user_data, int event, struct msmcomm_message * message);
typedef void (*msmcomm_write_handler_cb)
    (void *user_data, uint8_t * data, uint32_t len);
typedef int (*msmcomm_read_handler_cb) 
    (void *user_data, uint8_t * data, uint32_t len);
typedef void (*msmcomm_log_handler_cb)
    (void *user_data, char *buffer, unsigned int len);
typedef void (*msmcomm_error_handler_cb) 
    (void *user_data, int error, void *data);
typedef void (*msmcomm_network_state_info_changed_field_type_cb) 
    (void *user_data, struct msmcomm_message * msg, int type);

int msmcomm_launch_daemon(const char *workdir);

int msmcomm_is_daemon_running();

int msmcomm_shutdown_daemon();

int msmcomm_init(struct msmcomm_context *ctx);

int msmcomm_shutdown(struct msmcomm_context *ctx);

int msmcomm_read_from_modem(struct msmcomm_context *ctx);

int msmcomm_send_message(struct msmcomm_context *ctx, struct msmcomm_message *msg);

unsigned int msmcomm_check_hci_version(unsigned int hci_version);

void msmcomm_register_event_handler(struct msmcomm_context *ctx, 
                                    msmcomm_event_handler_cb event_handler, 
                                    void *data);
void msmcomm_register_write_handler(struct msmcomm_context *ctx, 
                                    msmcomm_write_handler_cb write_handler, 
                                    void *data);
void msmcomm_register_read_handler(struct msmcomm_context *ctx, 
                                   msmcomm_read_handler_cb read_handler, 
                                   void *data);
void msmcomm_register_error_handler(struct msmcomm_context *ctx, 
                                    msmcomm_error_handler_cb error_handler, 
                                    void *data);
void msmcomm_register_log_handler(struct msmcomm_context *ctx, 
                                  msmcomm_log_handler_cb log_handler, 
                                  void *data);

/**
 * These are common operations which are valid for all kind of messages
 */

struct msmcomm_message *msmcomm_create_message(unsigned int type);
struct msmcomm_message *msmcomm_message_make_copy(struct msmcomm_message *msg);
uint32_t msmcomm_message_get_size(struct msmcomm_message *msg);
uint32_t msmcomm_message_get_type(struct msmcomm_message *msg);
uint32_t msmcomm_message_get_ref_id(struct msmcomm_message *msg);
void msmcomm_message_set_ref_id(struct msmcomm_message *msg, uint32_t ref_id);
unsigned int msmcomm_message_get_result(struct msmcomm_message *msg);
unsigned int msmcomm_message_get_message_type(struct msmcomm_message *msg);

/**
 * These are message/response/event specific operations which only should be
 * executed on the right message!
 */

void msmcomm_message_change_operation_mode_set_operation_mode(struct msmcomm_message *msg, uint8_t operation_mode);

void msmcomm_message_charging_set_voltage(struct msmcomm_message *msg, unsigned int voltage);
void msmcomm_message_charging_set_mode(struct msmcomm_message *msg, unsigned int mode);

void msmcomm_message_set_mode_preference_status_set_mode(struct msmcomm_message *msg, unsigned int mode);

void msmcomm_message_dial_call_set_caller_id(struct msmcomm_message *msg, 
                                             const char *caller_id,
                                             unsigned int len);
void msmcomm_message_dial_call_set_block(struct msmcomm_message *msg, unsigned int block);
                                             
void msmcomm_message_answer_call_set_call_id(struct msmcomm_message *msg, 
                                             uint8_t call_id);
                                             
void msmcomm_message_end_call_set_call_id(struct msmcomm_message *msg, 
                                          uint8_t call_id);

void msmcomm_message_verify_pin_set_pin(struct msmcomm_message *msg, 
                                        const char *pin);
                                             
void msmcomm_message_enable_pin_set_pin_type(struct msmcomm_message *msg, 
                                             unsigned int pin_type);

void msmcomm_message_disable_pin_set_pin_type(struct msmcomm_message *msg, unsigned int pin_type);
void msmcomm_message_disable_pin_set_pin(struct msmcomm_message *msg, const char *pin);

void msmcomm_message_read_phonebook_set_book_type(struct msmcomm_message *msg,
                                                  unsigned int book_type);
void msmcomm_message_read_phonebook_set_position(struct msmcomm_message *msg, 
                                                 uint8_t position);

void msmcomm_message_write_phonebook_set_number(struct msmcomm_message *msg, 
                                                const char *number,
                                                unsigned int len);
void msmcomm_message_write_phonebook_set_title(struct msmcomm_message *msg, 
                                               const char *title,
                                               unsigned int len);
void msmcomm_message_write_phonebook_set_book_type(struct msmcomm_message *msg,
                                                   unsigned int book_type);

void msmcomm_message_delete_phonebook_set_position(struct msmcomm_message *msg, 
                                                   uint8_t position);
void msmcomm_message_delete_phonebook_set_book_type(struct msmcomm_message *msg,
                                                    unsigned int book_type);

void msmcomm_message_change_pin_set_old_pin(struct msmcomm_message *msg, 
                                            const char *old_pin,
                                            unsigned int len);
void msmcomm_message_change_pin_set_new_pin(struct msmcomm_message *msg, 
                                            const char *new_pin,
                                            unsigned int len);

uint8_t msmcomm_event_sms_wms_read_template_get_digit_mode(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_mode(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_sms_wms_read_template_get_number_plan(struct msmcomm_message *msg);

unsigned int msmcomm_event_phonebook_ready_get_book_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_phonebook_modified_get_position(struct msmcomm_message *msg);
uint8_t msmcomm_event_phonebook_modified_get_book_type(struct msmcomm_message *msg);

unsigned int msmcomm_resp_phonebook_get_book_type(struct msmcomm_message *msg);
uint8_t msmcomm_resp_phonebook_get_position(struct msmcomm_message *msg);
unsigned int msmcomm_resp_phonebook_get_encoding_type(struct msmcomm_message *msg);
char *msmcomm_resp_phonebook_get_number(struct msmcomm_message *msg);
char *msmcomm_resp_phonebook_get_title(struct msmcomm_message *msg);
uint8_t msmcomm_resp_phonebook_get_modify_id(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_slot_count(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_slots_used(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_title(struct msmcomm_message *msg);
uint32_t msmcomm_resp_get_phonebook_properties_get_max_chars_per_number(struct msmcomm_message *msg);

char *msmcomm_resp_get_firmware_info_get_info(struct msmcomm_message *msg);
uint8_t msmcomm_resp_get_firmware_info_get_hci_version(struct msmcomm_message *msg);

char *msmcomm_resp_get_imei_get_imei(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charging_get_voltage(struct msmcomm_message *msg);
unsigned int msmcomm_resp_charging_get_mode(struct msmcomm_message *msg);

unsigned int msmcomm_resp_charger_status_get_voltage(struct msmcomm_message *msg);
unsigned int msmcomm_resp_charger_status_get_mode(struct msmcomm_message *msg);

void msmcomm_message_set_system_time_set(struct msmcomm_message *msg, uint16_t year, uint16_t month,
                                         uint16_t day, uint16_t hours, uint16_t minutes,
                                         uint16_t seconds, int32_t timezone_offset);

void msmcomm_message_rssi_status_set_status(struct msmcomm_message *msg, uint8_t status);

uint8_t msmcomm_resp_cm_ph_get_result(struct msmcomm_message *msg);

uint16_t msmcomm_resp_cm_call_get_cmd_type(struct msmcomm_message *msg);

uint8_t msmcomm_event_power_state_get_state(struct msmcomm_message *msg);

unsigned int msmcomm_event_charger_status_get_voltage(struct msmcomm_message *msg);

char *msmcomm_event_call_status_get_caller_id(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_reject_type(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_reject_value(struct msmcomm_message *msg);
uint8_t msmcomm_event_call_status_get_call_id(struct msmcomm_message *msg);
unsigned int msmcomm_event_call_status_get_call_type(struct msmcomm_message *msg);

unsigned int msmcomm_event_network_state_info_is_only_rssi_update(struct msmcomm_message *msg);
uint32_t msmcomm_event_network_state_info_get_change_field(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_new_value(struct msmcomm_message *msg);
uint8_t *msmcomm_event_network_state_info_get_plmn(struct msmcomm_message *msg);
char *msmcomm_event_network_state_info_get_operator_name(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_rssi(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_ecio(struct msmcomm_message *msg);
void msmcomm_event_network_state_info_trace_changes(struct msmcomm_message *msg,
                                                    msmcomm_network_state_info_changed_field_type_cb
                                                    type_handler, void *user_data);
uint8_t msmcomm_event_network_state_info_get_service_domain(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_service_capability(struct msmcomm_message *msg);
uint8_t msmcomm_event_network_state_info_get_gprs_attached(struct msmcomm_message *msg);
uint16_t msmcomm_event_network_state_info_get_roam(struct msmcomm_message *msg);
unsigned int msmcomm_event_get_networklist_get_network_count(struct msmcomm_message *msg);
unsigned int msmcomm_event_get_networklist_get_plmn(struct msmcomm_message *msg, int nnum);
char *msmcomm_event_get_networklist_get_network_name(struct msmcomm_message *msg, int nnum);

char* msmcomm_resp_sim_get_field_data(struct msmcomm_message *msg);
unsigned int msmcomm_resp_sim_info_get_field_type(struct msmcomm_message *msg);

void msmcomm_message_sim_info_set_field_type(struct msmcomm_message *msg, 
                                             unsigned int field_type);
                                            
uint8_t *msmcomm_resp_audio_modem_tuning_params_get_params(struct msmcomm_message *msg, unsigned int *len);

void msmcomm_message_set_audio_profile_set_class(struct msmcomm_message *msg, uint8_t class);
void msmcomm_message_set_audio_profile_set_sub_class(struct msmcomm_message *msg, uint8_t sub_class);

uint8_t msmcomm_event_cm_ph_get_plmn_count(struct msmcomm_message *msg);
unsigned int msmcomm_event_cm_ph_get_plmn(struct msmcomm_message *msg, unsigned int n);

/*
 * MSMCOMM_EVENT_SMS_RECEIVED_MESSAGE methods
 */

char* msmcomm_event_sms_received_message_event_get_sender(struct msmcomm_message *msg);
uint8_t* msmcomm_event_sms_received_message_event_get_pdu(struct msmcomm_message *msg, unsigned int *len);

#endif
