/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
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

namespace Msmcomm.LowLevel
{
    public enum MessageResult
    {
        OK,
        ERROR_BAD_CALL_ID,
        ERROR_BAD_SIM_STATE,
        ERROR_PHONEBOOK_NOT_ACTIVE,
        ERROR_PHONEBOOK_RECORD_EMPTY,
        ERROR_PHONEBOOK_FAILED_TO_WRITE_RECORD,
        ERROR_BAD_PIN,
        ERROR_NOT_ONLINE,
        ERROR_UNKNOWN,
    }
}
