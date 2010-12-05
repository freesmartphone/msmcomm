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

    public class LowLevelControl : AbstractObject, ILowLevelControl
    {
        private string[] sysfsnodes;

        private enum SysfsNodeType
        {
            POWER_ON,
            BOOT_MODE,
            WAKEUP_MODEM
        }

        //
        // public API
        //

        public LowLevelControl()
        {
            // load sysfs nodes from config file
            sysfsnodes = new string[3];
            sysfsnodes[SysfsNodeType.POWER_ON] = config.stringValue("lowlevel", "sysfs_power_on", "/sys/user_hw/pins/modem/power_on/level");
            sysfsnodes[SysfsNodeType.BOOT_MODE] = config.stringValue("lowlevel", "sysfs_boot_mode", "/sys/user_hw/pins/modem/boot_mode/level");
            sysfsnodes[SysfsNodeType.WAKEUP_MODEM] = config.stringValue("lowlevel", "sysfs_wakeup_modem", "/sys/user_hw/pins/modem/wakeup_modem/level");
        }

        public override string repr()
        {
            return "<>";
        }

        private void executeShellCommand(string command)
        {
            if ( Posix.system(command) < 0 )
            {
                logger.error(@"Could not execute shell command: '$command'");
            }
        }

        public void reset()
        {
            executeShellCommand(@"echo 0 > $(sysfsnodes[SysfsNodeType.BOOT_MODE])");
            executeShellCommand(@"echo 0 > $(sysfsnodes[SysfsNodeType.WAKEUP_MODEM])");
            executeShellCommand(@"echo 0 > $(sysfsnodes[SysfsNodeType.POWER_ON])");

            Posix.sleep(2);

            executeShellCommand(@"echo 1 > $(sysfsnodes[SysfsNodeType.POWER_ON])");
            executeShellCommand(@"echo 1 > $(sysfsnodes[SysfsNodeType.WAKEUP_MODEM])");
        }

        public void powerOn()
        {
            executeShellCommand(@"echo 1 > $(sysfsnodes[SysfsNodeType.POWER_ON])");
        }

        public void powerOff()
        {
            executeShellCommand(@"echo 0 > $(sysfsnodes[SysfsNodeType.BOOT_MODE])");
            executeShellCommand(@"echo 0 > $(sysfsnodes[SysfsNodeType.POWER_ON])");
        }
    }
} // namespace Msmcomm

