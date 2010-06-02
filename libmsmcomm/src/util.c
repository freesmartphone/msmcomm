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

unsigned int network_plmn_to_value(const uint8_t *plmn)
{
    unsigned int value = 0;
    value = (plmn[0] & 0xf) * 10000;
    value += ((plmn[0] & 0xf0) >> 4) * 1000;
    value += (plmn[1] & 0xf) * 100;
    value += (plmn[2] & 0xf) * 10;
    value += ((plmn[2] & 0xf0) << 4);
    return value;
}
