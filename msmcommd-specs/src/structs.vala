

/**
 * This file is part of msmcommd.
 *
 * (C) 2010 Simon Busch <morphis@gravedo.de>
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmcomm
{
    [CCode (cprefix = "MSMCOMMD_PHONEBOOK_BOOK_TYPE_", cheader_filename = "msmcommd.h")]
    [DBus (use_string_marshalling = true)]
    public enum PhonebookBookType
    {
        ADN,
        SDN,
        FDN,
        MBDN,
        MBN,
        UNKNOWN,
    }
    
    [CCode (type_id = "MSMCOMMD_PHONEBOOK_PROPERTIES", cheader_filename = "msmcommd.h")]
    public struct PhonebookProperties
    {
        public int slot_count;
        public int slots_used;
        public int max_chars_per_title;
        public int max_chars_per_number;
        
        public PhonebookProperties(int slot_count, int slots_used, int max_chars_per_title, int max_chars_per_number)
        {
            this.slot_count = slot_count;
            this.slots_used = slots_used;
            this.max_chars_per_title = max_chars_per_title;
            this.max_chars_per_number = max_chars_per_number;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_PHONEBOOK_ENTRY", cheader_filename = "msmcommd.h")]
    public struct PhonebookEntry
    {
        public PhonebookBookType book_type;
        public int position;
        public string number;
        public string title;
        public string encoding_type;
        
        public PhonebookEntry(PhonebookBookType book_type, int position, string number, string title, string encoding_type)
        {
            this.book_type = book_type;
            this.position = position;
            this.number = number;
            this.title = title;
            this.encoding_type = encoding_type;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_NETWORK_PROVIDER", cheader_filename = "msmcommd.h")]
    public struct NetworkProvider
    {
        string operator_name;
        uint plmn;
        
        public NetworkProvider(string operator_name, uint plmn)
        {
            this.operator_name = operator_name;
            this.plmn = plmn;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_FIRMWARE_INFO", cheader_filename = "msmcommd.h")]
    public struct FirmwareInfo
    {
        string version_string;
        int hci_version;
        
        public FirmwareInfo(string version_string, int hci_version)
        {
            this.version_string = version_string;
            this.hci_version = hci_version;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_PHONE_STATE_INFO", cheader_filename = "msmcommd.h")]
    public struct PhoneStateInfo
    {
        int current_state;
        
        public PhoneStateInfo(int current_state)
        {
            this.current_state = current_state;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_NETWORK_STATE_INFO", cheader_filename = "msmcommd.h")]
    public struct NetworkStateInfo
    {
        bool only_rssi_update;
        uint change_field;
        uint new_value;
        string operator_name;
        uint rssi;
        uint ecio; 
        uint service_domain;
        uint service_capability;
        bool gprs_attached;
        uint roam;
        
        public NetworkStateInfo(bool only_rssi_update, uint change_field, uint new_value, string operator_name, uint rssi, uint ecio, uint service_domain, uint service_capability, bool gprs_attached, uint roam)
        {
            this.only_rssi_update = only_rssi_update;
            this.change_field = change_field;
            this.new_value = new_value;
            this.operator_name = operator_name;
            this.rssi = rssi;
            this.ecio = ecio;
            this.service_domain = service_domain;
            this.service_capability = service_capability;
            this.gprs_attached = gprs_attached;
            this.roam = roam;
        }
    }
    
    [CCode (type_id = "MSMCOMMD_CALL_INFO", cheader_filename = "msmcommd.h")]
    public struct CallInfo
    {
        string number;
        string type;
        uint id;
        uint reject_type;
        uint reject_value;
        
        public CallInfo(string number, string type, uint id, uint reject_type, uint reject_value)
        {
            this.number = number;
            this.type = type;
            this.id = id;
            this.reject_type = reject_type;
            this.reject_value = reject_value;
        }
    }
    
    [CCode (cprefix = "MSMCOMMD_CHARGER_STATUS_MODE_", cheader_filename = "msmcommd.h")]
    [DBus (use_string_marshalling = true)]
    public enum ChargerStatusMode
    {
        UNKNOWN,
        USB,
        INDUCTIVE,
    }
    
    [CCode (cprefix = "MSMCOMMD_CHARGER_STATUS_VOLTAGE_", cheader_filename = "msmcommd.h")]
    [DBus (use_string_marshalling = true)]
    public enum ChargerStatusVoltage
    {
        VOLTAGE_250mA,
        VOLTAGE_500mA,
        VOLTAGE_1A,
        VOLTAGE_UNKNOWN,
    }
       
    [CCode (type_id = "MSMCOMMD_CHARGER_STATUS", cheader_filename = "msmcommd.h")] 
    public struct ChargerStatus
    {
        public ChargerStatusMode mode;
        public ChargerStatusVoltage voltage;
        
        public ChargerStatus(ChargerStatusMode mode, ChargerStatusVoltage voltage)
        {
            this.mode = mode;
            this.voltage = voltage;
        }
    }

    [CCode (cprefix = "MSMCOMMD_MODEM_OPERATION_MODE_", cheader_filename = "msmcommd.h")]
    [DBus (use_string_marshalling = true)]    
    public enum ModemOperationMode
    {
        OFFLINE,
        ONLINE,
        UNKNOWN,
    }
    
    [CCode (type_id = "MSMCOMMD_SMS_INFO", cheader_filename = "msmcommd.h")]
    public struct SmsInfo
    {
        public string sender_number { get; set; }
        public uint8[] pdu { get; set; }
        
        public SmsInfo(string sender_number, uint8[] pdu)
        {
            this.sender_number = sender_number;
            this.pdu = pdu;
        }
    }
    
} // namespace Msmcomm
