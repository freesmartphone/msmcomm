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
 
namespace Msmcomm.Daemon
{
    public enum LinkStateType
    {
        NULL,
        INIT,
        ACTIVE
    }
    
    public string linkStateTypeToString(LinkStateType type)
    {
        string result = "<unknown>";
        switch (type)
        {
            case LinkStateType.NULL:
                result = "NULL";
                break;
            case LinkStateType.INIT:
                result = "INIT";
                break;
            case LinkStateType.ACTIVE:
                result = "ACTIVE";
                break;
        }
        return result;
    }


    public class LinkContext
    { 
        public uint8 window_size { get; set; default = 8; }
        public uint8 max_sequence_number { get; private set; default = 0xf; }
        public uint max_send_attempts { get; set; default = 10; }
        
        public LinkStateType state { get; set; default = LinkStateType.NULL; }

        public uint8 next_seq { get; set; default = 0; }
        public uint8 next_ack { get; set; default = 0; }
        public uint8 expected_seq { get; set; default = 0; }
        public uint8 last_ack { get; set; default = 0; }

        public Gee.LinkedList<Frame> ack_queue { get; set; }
        
        public Timer ack_timer { get; set; }
        
        //
        // public API
        //
        
        public LinkContext()
        {
            ack_queue = new Gee.LinkedList<Frame>();
            
            ack_timer = new Timer();
            ack_timer.interval = 1000;
        }

        public void reset()
        {
            state = LinkStateType.NULL;
            next_seq = 0;
            next_ack = 0;
            expected_seq = 0;
            last_ack = 0;
            ack_queue.clear();
        }

        public uint8 nextSequenceNumber()
        {
            uint8 seq = next_seq;
            next_seq = (next_seq + 1) % (max_sequence_number + 1);
            return seq;
        }

        public uint8 nextAcknowledgeNumber()
        {
            next_ack = (next_ack + 1) % (max_sequence_number + 1);
            return next_ack;
        }

        public void changeState(LinkStateType new_state)
        {
            FsoFramework.theLogger.info(@"leaving $(linkStateTypeToString(state)) state ...");
            state = new_state;
            stateChanged(new_state);
            FsoFramework.theLogger.info(@"entering $(linkStateTypeToString(state)) state ...");
        }
        
        public signal void stateChanged(LinkStateType new_state);
    }
    
} // namespace Msmcomm
