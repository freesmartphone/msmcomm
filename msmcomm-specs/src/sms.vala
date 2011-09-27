/**
 * This file is part of msmcomm-specs
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
 * (C) 2011 Lukas Märdian <lukasmaerdian@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more infos.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm
{
    [CCode (cprefix = "MSMCOMM_SMS_TEMPLATE_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SmsTemplateType
    {
        SMSC_NUMBER,
        EMAIL_ADDRESS
    }

    [CCode (cprefix = "MSMCOMM_SMS_NUMBER_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SmsNumberType
    {
        UNKNOWN,
        INTERNATIONAL,
        NATIONAL,
        NETWORK_SPECIFIC,
        SUBSCRIBER,
        ALPHANUMERIC,
        ABBREVIATED,
        RESERVED
    }

    [CCode (cprefix = "MSMCOMM_SMS_NUMBERING_PLAN_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum SmsNumberingPlan
    {
        UNKNOWN,
        ISDN,
        DATA,
        TELEX,
        SC1,
        SC2,
        NATIONAL,
        PRIVATE,
        ERMES,
        RESERVED
    }

    [CCode (type_id = "MSMCOMM_SMS_TEMPLATE_INFO", cheader_filename = "msmcomm-specs.h")]
    public struct SmsTemplateInfo
    {
        public uint8 digit_mode;
        public uint32 number_mode;
        public SmsNumberType number_type;
        public SmsNumberingPlan numbering_plan;
        public string smsc_number;
        public uint8 protocol_id;
    }

    [CCode (type_id = "MSMCOMM_SMS_MESSAGE", cheader_filename = "msmcomm-specs.h")]
    public struct SmsMessage
    {
        public string sender;
        public uint8[] pdu;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.Sms")]
    public interface Sms : GLib.Object
    {
        public abstract async SmsTemplateInfo message_read_template(SmsTemplateType template_type) throws GLib.Error, Msmcomm.Error;
        public abstract async void set_gateway_domain() throws GLib.Error, Msmcomm.Error;
        public abstract async void set_routes() throws GLib.Error, Msmcomm.Error;
        public abstract async void get_message_list() throws GLib.Error, Msmcomm.Error;
        public abstract async uint get_memory_status() throws GLib.Error, Msmcomm.Error; 
        public abstract async void send_message(string smsc, uint8[] pdu) throws GLib.Error, Msmcomm.Error;
        public abstract async void acknowledge_message() throws GLib.Error, Msmcomm.Error;

        public signal void incoming_message(SmsMessage message);
    }
}
