
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

#define LIBMSMCOMM_RESP_IMEI_LEN             17
#define LIBMSMCOMM_RESP_FIRMWARE_LEN         20

/*
 * MSMCOMM_RESPONSE_TEST_ALIVE
 */

unsigned int resp_test_alive_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0x2);
}

void resp_test_alive_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    /* FIXME */
}

uint32_t resp_test_alive_get_size(struct msmcomm_message *msg)
{
    return 0;
}

/*
 * MSMCOMM_RESPONSE_GET_FIRMWARE_INFO
 */

unsigned int resp_get_firmware_info_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0xa);
}

void resp_get_firmware_info_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct get_firmware_info_resp))
    {
        return;
    }

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct get_firmware_info_resp)->ref_id;
}

uint32_t resp_get_firmware_info_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_firmware_info_resp);
}

uint8_t msmcomm_resp_get_firmware_info_get_hci_version(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct get_firmware_info_resp)->hci_version;
}

// caller needs to free the result
char *msmcomm_resp_get_firmware_info_get_info(struct msmcomm_message *msg)
{
    void *result = malloc(LIBMSMCOMM_RESP_FIRMWARE_LEN);

    memcpy(result, MESSAGE_CAST(msg, struct get_firmware_info_resp)->firmware_version,
           LIBMSMCOMM_RESP_FIRMWARE_LEN);
    // firmware version data already contains the tailing 0
    return result;
}

/*
 * MSMCOMM_RESPONSE_GET_IMEI
 */

unsigned int resp_get_imei_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0x9);
}

void resp_get_imei_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct get_imei_resp))
    {
        msg->payload = NULL;
        return;
    }

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct get_imei_resp)->ref_id;
}

uint32_t resp_get_imei_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct get_imei_resp);
}

/* caller needs to free the result */
char *msmcomm_resp_get_imei_get_imei(struct msmcomm_message *msg)
{
    int n;

    struct get_imei_resp *resp;

    resp = (struct get_imei_resp *)msg->payload;

    char *result = malloc(LIBMSMCOMM_RESP_IMEI_LEN + 1);

    /* imei consists of 17 bytes - each byte is one number of the imei */
    for (n = 0; n < LIBMSMCOMM_RESP_IMEI_LEN; ++n)
    {
        result[n] = 0x30 + resp->imei[n];
    }
    result[LIBMSMCOMM_RESP_IMEI_LEN] = 0;
    return result;
}

/*
 * MSMCOMM_RESPONSE_CHARGER_STATUS
 */

unsigned int resp_charger_status_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0x16);
}

void resp_charger_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct charger_status_msg))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct charger_status_msg)->ref_id;
}

uint32_t resp_charger_status_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct charger_status_msg);
}

unsigned int msmcomm_resp_charger_status_get_mode(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct charger_status_msg)->mode)
    {
        case 0x1:
            return MSMCOMM_CHARGING_MODE_USB;
        case 0x2:
            return MSMCOMM_CHARGING_MODE_INDUCTIVE;
    }

    return MSMCOMM_CHARGING_MODE_INDUCTIVE;
}

unsigned int msmcomm_resp_charger_status_get_voltage(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct charger_status_msg)->voltage)
    {
        case 250:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_250mA;
        case 500:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_500mA;
        case 1000:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_1A;
    }

    return MSMCOMM_MESSAGE_INVALID;
}

/*
 * MSMCOMM_RESPONSE_CARGE_USB
 */

unsigned int resp_charging_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0x14);
}

void resp_charging_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct charging_msg))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct charging_msg)->ref_id;
}

uint32_t resp_charging_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct charging_msg);
}

unsigned int msmcomm_resp_charging_get_mode(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct charging_msg)->mode)
    {
        case 0x1:
            return MSMCOMM_CHARGING_MODE_USB;
        case 0x2:
            return MSMCOMM_CHARGING_MODE_INDUCTIVE;
    }

    return MSMCOMM_CHARGING_MODE_INDUCTIVE;
}

unsigned int msmcomm_resp_charging_get_voltage(struct msmcomm_message *msg)
{
    switch (MESSAGE_CAST(msg, struct charger_status_msg)->voltage)
    {
        case 250:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_250mA;
        case 500:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_500mA;
        case 1000:
            return MSMCOMM_CHARGING_VOLTAGE_MODE_1A;
    }

    return MSMCOMM_MESSAGE_INVALID;

}

/*
 * MSMCOMM_RESPONSE_CM_PH
 */

unsigned int resp_cm_ph_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x4) && (msg->msg_id == 0x1);
}

void resp_cm_ph_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct cm_ph_resp))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct cm_ph_resp)->ref_id;

    /* set message result code to the one we got with the response */
    switch (MESSAGE_CAST(msg, struct cm_ph_resp)->result)
    {
        case 0x0:
            msg->result = MSMCOMM_RESULT_OK;
            break;
        case 0x1a:
            msg->result = MSMCOMM_RESULT_ERROR;
            break;
    }
}

uint32_t resp_cm_ph_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct cm_ph_resp);
}

uint8_t msmcomm_resp_cm_ph_get_result(struct msmcomm_message *msg)
{
    return MESSAGE_CAST(msg, struct cm_ph_resp)->result;
}

/*
 * MSMCOMM_RESPONSE_SET_SYSTEM_TIME
 */

unsigned int resp_set_system_time_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x1c) && (msg->msg_id == 0xf);
}

void resp_set_system_time_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct set_system_time_resp))
        return;

    msg->payload = data;
}

uint32_t resp_set_system_time_get_size(struct msmcomm_message * msg)
{
    return sizeof (struct set_system_time_resp);
}

/*
 * MSMCOMM_RESPONSE_RSSI_STATUS
 */

unsigned int resp_rssi_status_is_valid(struct msmcomm_message *msg)
{
    return (msg->group_id == 0x7) && (msg->msg_id == 0x1);
}

void resp_rssi_status_handle_data(struct msmcomm_message *msg, uint8_t * data, uint32_t len)
{
    if (len != sizeof (struct rssi_status_resp))
        return;

    msg->payload = data;
    msg->ref_id = MESSAGE_CAST(msg, struct rssi_status_resp)->ref_id;
}

uint32_t resp_rssi_status_get_size(struct msmcomm_message *msg)
{
    return sizeof (struct rssi_status_resp);
}
