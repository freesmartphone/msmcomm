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

using GLib;

namespace Msmcomm.Daemon
{
	internal void hexdump2(bool write, uint8[] data, FsoFramework.Logger logger)
	{
		if (data.length < 1)
			return;

		int BYTES_PER_LINE = 16;
		var hexline = new StringBuilder(write ? "<<< " : ">>> ");
		var ascline = new StringBuilder();
		int i = 0;

		foreach (uint8 byte in data)
		{
			i++;

			hexline.append_printf("%02x ", byte);
			if (31 < byte && byte < 128)
				ascline.append_printf("%c", byte);
			else
				ascline.append_printf(".");

			if (i % BYTES_PER_LINE + 1 == BYTES_PER_LINE)
			{
				hexline.append(ascline.str);
				logger.debug(hexline.str);
				hexline = new StringBuilder(write ? ">>> " : "<<< ");
				ascline = new StringBuilder();
			}
		}

		if (i % BYTES_PER_LINE + 1 != BYTES_PER_LINE)
		{
			while (hexline.len < 52)
				hexline.append_c(' ');
			hexline.append(ascline.str);
			logger.debug(hexline.str);
		}
	}

    public Msmcomm.LowLevel.PhonebookType convertPhonebookBookType(PhonebookBookType book_type)
    {
        Msmcomm.LowLevel.PhonebookType result = Msmcomm.LowLevel.PhonebookType.ADN;

        switch (book_type)
        {
            case PhonebookBookType.FDN:
                result = Msmcomm.LowLevel.PhonebookType.FDN;
                break;
            case PhonebookBookType.SDN:
                result = Msmcomm.LowLevel.PhonebookType.SDN;
                break;
            case PhonebookBookType.ADN:
                result = Msmcomm.LowLevel.PhonebookType.ADN;
                break;
            case PhonebookBookType.MBDN:
                result = Msmcomm.LowLevel.PhonebookType.MBDN;
                break;
            case PhonebookBookType.MBN:
                result = Msmcomm.LowLevel.PhonebookType.MBN;
                break;
        }

        return result;
    }

    public PhonebookBookType convertPhonebookType(Msmcomm.LowLevel.PhonebookType book_type)
    {
        PhonebookBookType result = PhonebookBookType.UNKNOWN;

        switch (book_type)
        {
            case Msmcomm.LowLevel.PhonebookType.FDN:
                result = PhonebookBookType.FDN;
                break;
            case Msmcomm.LowLevel.PhonebookType.SDN:
                result = PhonebookBookType.SDN;
                break;
            case Msmcomm.LowLevel.PhonebookType.ADN:
                result = PhonebookBookType.ADN;
                break;
            case Msmcomm.LowLevel.PhonebookType.MBDN:
                result = PhonebookBookType.MBDN;
                break;
            case Msmcomm.LowLevel.PhonebookType.MBN:
                result = PhonebookBookType.MBN;
                break;
        }

        return result;
    }
} // namespace Msmcomm
