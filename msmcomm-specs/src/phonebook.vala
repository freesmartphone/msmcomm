/**
 * This file is part of msmcomm-specs
 *
 * (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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
    [CCode (cprefix = "MSMCOMM_PHONEBOOK_ENCODING_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum PhonebookEncodingType
    {
        NO_ENCODING,
        ASCII,
        BUCS2,
    }

    [CCode (cprefix = "MSMCOMM_PHONEBOOK_BOOK_TYPE_", cheader_filename = "msmcomm-specs.h")]
    [DBus (use_string_marshalling = true)]
    public enum PhonebookBookType
    {
        ADN,
        FDN,
        SDN,
        ECC,
        UNKNOWN,
    }

    [CCode (type_id = "MSMCOMM_PHONEBOOK_RECORD", cheader_filename="msmcomm-specs.h")]
    public struct PhonebookRecord
    {
        public string title;
        public string number;
        public uint position;
        public PhonebookBookType book_type;
        public PhonebookEncodingType encoding_type;
    }

    [CCode (type_id = "MSMCOMM_PHONEBOOK_INFO", cheader_filename="msmcomm-specs.h")]
    public struct PhonebookInfo
    {
        public PhonebookBookType book_type;
        public uint slot_count;
        public uint slots_used;
        public uint max_chars_per_title;
        public uint max_chars_per_number;
    }

    [DBus (timeout = 120000, name = "org.msmcomm.Phonebook")]
    public interface Phonebook : GLib.Object
    {
        public abstract async PhonebookRecord read_record(PhonebookBookType book_type, uint position) throws GLib.Error, Msmcomm.Error;
        public abstract async void write_record(PhonebookBookType book_type, uint position, string title, string number) throws GLib.Error, Msmcomm.Error;
        public abstract async void read_record_bulk(PhonebookBookType book_type, uint first, uint last) throws GLib.Error, Msmcomm.Error;
        public abstract async void get_all_record_id() throws GLib.Error, Msmcomm.Error;
        public abstract async PhonebookInfo get_extended_file_info(PhonebookBookType book_type) throws GLib.Error, Msmcomm.Error;

        public signal void ready(PhonebookBookType book_type);
        public signal void record_added(PhonebookBookType book_type, uint position);
        public signal void record_deleted(PhonebookBookType book_type, uint position);
        public signal void record_updated(PhonebookBookType book_type, uint position);
        public signal void record_failed(PhonebookBookType book_type, uint position);
        public signal void refresh_start();
        public signal void refresh_done();
        public signal void locked();
        public signal void unlocked();
        public signal void ph_unique_ids_validated();
        public signal void record_write_event(PhonebookBookType book_type, uint position);
        public signal void get_all_record_id_event();
    }
}
