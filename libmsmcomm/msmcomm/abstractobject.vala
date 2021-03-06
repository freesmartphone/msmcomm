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
    public abstract class AbstractObject : GLib.Object
    {
        public FsoFramework.SmartKeyFile config;
        public FsoFramework.Logger logger;
        public string classname;

        construct 
        {
            classname = Type.from_instance(this).name();
            config = FsoFramework.SmartKeyFile.defaultKeyFile();
            logger = FsoFramework.Logger.createFromKeyFile(config, "logging", classname);
            logger.setReprDelegate(repr);
#if DEBUG
            debug(@"Msmcomm.LowLevel.AbstractObject: created logger for domain $classname");
#endif
        }

        public abstract string repr();
    }
}
