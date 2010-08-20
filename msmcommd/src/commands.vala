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

namespace Msmcomm
{
    public abstract class BaseCommand
    {
        public ModemChannel channel { get; set; }
    
        public abstract async void run() throws CommandError;
        
        protected void checkResponse(Msmcomm.Message response) throws CommandError
        {
            if (response.result != Msmcomm.ResultType.OK)
            {
                var msg = @"$(eventTypeToString(response.type)) command failed with: $(resultTypeToString(response.result))";
                throw new CommandError.FAILED(msg);
            }
        }
    }
    
    public class ChangeOperationModeCommand : BaseCommand
    {
        public string mode { get; set; }
        
        public override async void run() throws CommandError
        {
            var cmd = new Msmcomm.Command.ChangeOperationMode();
            
            switch (mode)
            {
                case "offline":
                    cmd.mode = Msmcomm.OperationMode.OFFLINE;
                    break;
                case "online":
                    cmd.mode = Msmcomm.OperationMode.ONLINE;
                    break;
                case "reset":
                    cmd.mode = Msmcomm.OperationMode.RESET;
                    break;
                default:
                    var msg = "Invalid argument supplied for mode parameter for ChangeOperationMode command";
                    throw new CommandError.INVALID_ARGUMENTS(msg);
            }
            
            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        } 
    }

    public class TestAliveCommand : BaseCommand
    {
        public override async void run() throws CommandError
        {  
            var cmd = new Msmcomm.Command.TestAlive();
            unowned Msmcomm.Message response = yield channel.enqueueAsync((owned) cmd);
            checkResponse(response);
        }
    }
}
