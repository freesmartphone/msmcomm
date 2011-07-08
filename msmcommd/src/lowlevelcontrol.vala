/**
 * This file is part of msmcommd.
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
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

using FsoFramework;

namespace Msmcomm.Daemon
{
    public class LowLevelControl : AbstractObject, ILowLevelControl
    {
        private string powernode;
        private string bootnode;
        private string wakeupnode;

        private const string DEFAULT_POWER_NODE  = "/sys/user_hw/pins/modem/power_on/level";
        private const string DEFAULT_BOOT_NODE   = "/sys/user_hw/pins/modem/boot_mode/level";
        private const string DEFAULT_WAKEUP_NODE = "/sys/user_hw/pins/modem/wakeup_modem/level";

        //
        // public API
        //

        public LowLevelControl()
        {
            // load sysfs nodes from config file
            powernode = config.stringValue("lowlevel", "power_node", DEFAULT_POWER_NODE);
            bootnode = config.stringValue("lowlevel", "boot_node", DEFAULT_BOOT_NODE);
            wakeupnode = config.stringValue("lowlevel", "wakeup_node", DEFAULT_WAKEUP_NODE);
        }

        public override string repr()
        {
            return "< Msmcomm.Daemon.LowLevelControl @ >";
        }

        public void reset()
        {
            FileHandling.write("0", bootnode);
            FileHandling.write("0", wakeupnode);
            FileHandling.write("0", powernode);

            Posix.sleep(2);

            FileHandling.write("1", powernode);
            FileHandling.write("1", wakeupnode);
        }

        public void powerOn()
        {
            FileHandling.write("1", powernode);
        }

        public void powerOff()
        {
            FileHandling.write("0", bootnode);
            FileHandling.write("0", powernode);
        }
    }
} // namespace Msmcomm

