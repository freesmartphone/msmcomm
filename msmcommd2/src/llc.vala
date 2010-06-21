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

private enum LinkStateType
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

public class LinkLayerControl : GLib.Object, ILinkLayerControl
{
    private Gee.LinkedList tx_queue;
    private Gee.LinkedList ack_queue;

    private LinkStateType state;
    private uint8 window_size;
    private uint8 next_seq;
    private uint8 next_ack;
    private uint8 expected_seq;
    private uint8 last_ack;
    
    private Msmcomm.Timer ack_timer;
    private Msmcomm.Timer tx_timer;
    private Msmcomm.Timer sync_timer;
    
    private FsoFramework.Transport transport;

    construct
    {
        tx_queue = new Gee.LinkedList();
        ack_queue = new Gee.LinkedList();
        
        //
        // Setup timers
        //
        
        tx_timer = new Msmcomm.Timer { 
            interval = 50,
            priority = GLib.Priority.DEFAULT,
            cb = handleOutgoingDataCallback
        };   
        ack_timer = new Msmcomm.Timer {
            interval = 1000,
            priority = GLib.Priority.DEFAULT,
            cb = ackTimerCallback
        };
        sync_timer = new Msmcomm.Timer {
            interval = 1000,
            priority = GLib.Priority.DEFAULT,
            cb = syncTimerCallback
        };
    }
    
    public LinkLayerControl()
    {
        // FIXME
    }
    
    //
    // private API
    //
    
    private uint8 nextSequenceNumber()
    {
        uint8 seq = next_seq;
        next_seq = (next_seq + 1) % (MAX_SEQUENCE_NUMBER + 1);
        return seq;
    }
    
    private uint8 nextAcknowledgeNumber()
    {
        next_ack = (next_ack + 1) % (MAX_SEQUENCE_NUMBER + 1);
        return next_ack;
    }
    
    private bool ackTimerCallback()
    {
        // ack timer event occured, so one or more frames are not acknowledged
        // in time, so we have to resend this frames
        foreach (TransferObject to in ack_queue)
        {
            // Remove frame from ack queue, sendFrame(...) will add it again later
            trySendTransferObject(to);
        }

        // Reschedule ack timer as we are still waiting for the right acknowledge
        return true;
    }
    
    private bool syncTimerCallback()
    {
        if (state == LinkStateType.NULL)
        {
            createAndSendFrame(FrameType.SYNC);
            return true;
        }
        
        return false;
    }
    
    private void addAckTimer(TransferObject to)
    {
        // FIXME inlude check if ack_queue length is greater than the current window 
        // size?

        // Add frame to ack queue as we need to resend it if we get no
        // acknowledge for it
        ack_queue.add(to);

        // Reschedule timer cause we have a new frame in the ack queue
        // and all frames in ack queue are acknowledged when the last
        // frame is acknowledged
        ack_timer.restart();
    }
    
    private void trySendTransferObject(TransferObject to)
    {
        if (to.attempts >= MSMC_FRAME_MAX_ATTEMPTS)
        {
            logger.info(@"We have send a packet more than $(to.attempts) times with no response, restarting link!");
            restartLink();
        }
        else 
        {
            prepareAndSendFrame(frame, FrameType.DATA);
            to.attempts++;
        }
    }

    private void sendFrame(Frame frame)
    {
        // FIXME ...
        handleDataSendRequest(frame.pack());
    }

    private void prepareFrame(Frame frame, FrameType type)
    {
        frame.seq = 0x0;
        
        // Only if we send a non-ack frame we should set the seq nr
        if (type != FrameType.ACK) 
        {
            frame.seq = nextSequenceNumber();
        }
        
        // Handle different frame types
        if (type == FrameType.CONFIG_RESP)
        {
            frame.payload = new uint8[1];
            frame.payload[0] = 0x11;
        }
        
        frame.ack = nextAcknowledgeNumber();
        frame.type = type;
    }
    
    private void prepareAndSendFrame(Frame frame, FrameType type)
    {
        prepareFrame(frame, type);
        sendFrame(frame);
    }
    
    private void createAndSendFrame(FrameType type)
    {
        var frame = new Frame();
        prepareAndSendFrame(frame, type);
    }

    private bool handleOutgoingDataCallback()
    {
        foreach (TransferObject to in tx_queue) 
        {
            prepareAndSendFrame(to.frame, FrameType.DATA);
            addAckTimer(to);
            tx_queue.remove(to);
        }
    }
    
    private void acknowledgeFrame()
    {
        // FIXME check wether there are frames waiting for sending

        // The below method does set the appropiate values
        // for the seq and ack fields for us (as we specified the right
        // frame type)
        createAndSendFrame(FrameType.ACK);
    }
    
    private void restartLink()
    {
        logger.info("restarting link control layer ...\n");
        
        // Reset internal properties
        state = LinkStateType.NULL;
        next_seq = 0;
        next_ack = 0;
        expected_seq = 0;
        last_ack = 0;
        
        // Stop all timers
        ack_timer.stop();
        sync_timer.stop();
        tx_timer.stop();
        
        // Clear all queue's
        tx_queue.clear();
        ack_queue.clear();
    }
    
    private void switchState(LinkStateType new_state)
    {
        logger.debug(@"leaving $(linkStateTypeToString(state)) state ...");
        state = new_state;
        logger.debug(@"entering $(linkStateTypeToString(state)) state ...");
    }
    
    private void linkEstablishmentControl(Frame frame)
    {
        logger.debug(@"received $(frameTypeToString(frame.type)) frame");
        
        switch (state)
        {
            case NULL;
                // only handle SYNC and SYNC RESP frame types
                if (frame.type == FrameType.SYNC)
                {
                    handleFrame(frame);
                }
                else if (frame.type == FrameType.SYNC_RESP)
                {
                    switchState(LinkStateType.INIT);
                    // FIXME remove sync timer
                    createAndSendFrame(FrameType.CONFIG);
                }
                break;
            case INIT:
                if (frame.type == FrameType.SYNC) 
                {
                    // response with SYNC RESP message
                    createAndSendFrame(FrameType.SYNC_RESP);
                }
                else if {frame.type == FrameType.CONFIG)
                {
                    // response with a CONFIG RESP message 
                    createAndSendFrame(FrameType.CONFIG_RESP);
                }
                else if (frame.type == FrameType.CONFIG_RESP)
                {
                    switchState(LinkStateType.ACTIVE);
                }
                else
                {
                    logger.debug(@"recieve $(frameTypeToString(frame.type)) frame in $(linkStateTypeToString(state)) state ... discard frame!");
                }
                break;
            case ACTIVE:
                if (frame.type == FrameType.SYNC)
                {
                    logger.debug("got SYNC FRAME in ACTIVE state -> restart link!");
                    // The spec tolds us to restart the whole stack if we receive 
                    // a sync message in ACTIVE state
                    restartLink();
                }
                else if (frame.type == FrameType.CONFIG)
                {
                    // If we receive a CONFIG message in ACTIVE state we send out a 
                    // CONFIG RESP with our currrent configuration settings
                    // FIXME how to include current configuration settings?
                    createAndSendFrame(FrameType.CONFIG_RESP);
                }
                else
                {
                    logger.debug("recieve $(frameTypeToString(frame.type)) frame in ACTIVE state ... discarding frame!");
                }
                break;
            default:
                logger.error("arrived in invalid state ... assuming restart!");
                restartLink();
                break;
        }
    }

    private void linkControl(Frame frame)
    {
        switch (state)
        {
            case LinkStateType.ACTIVE:
                if (frame.type == FrameType.DATA)
                {
                    // Our frame is not the frame with the expected sequence nr 
                    if (frame.seq != expected_seq)
                        // FIXME Should we really drop this frame? 
                        return;

                    // handle received acknowledge and ack this frame
                    handleRecievedAck(frame);
                    acknowledgeFrame(frame);

                    // in debug mode we should log the frame for bug
                    // hunting ...
                    logger.debug("receive data from modem (seq=0x%x, ack=0x%x)".printf(frame.seq, frame.ack));
                    logger.debug("payload is: FIXME");
                    // FIXME implement hexdump
                    // hexdump(fr->payload, fr->payload_len);

                    // we have new data for our registered data handlers
                    // FIXME implement and handle data handlers
                }
                else if (frame.type == FrameType.ACK)
                {
                    // this frame is a pure ack frame and does not has a valid seq 
                    // nr so ingore it
                    handleRecievedAck(frame);
                }
                break;
            default: 
                logger.error("recieve frame in wrong state ... discard frame!");
                break;
        }
    }
    
    private bool frameTypIsDataOrAcknowlege(Frame frame)
    {
        return frame.type == FrameType.DATA || frame.type == FrameType.ACK;
    }
    
    private void handleIncommingFrame(Frame frame)
    {
        // delegate frame handling corresponding to the frame type 
        if (!frameTypIsDataOrAcknowlege(frame))
        {
            linkEstablishmentControl(frame);
        }
        else
        {
            linkControl(frame);
        }
    }
    
    //
    // Signals
    //
    
    public void handleDataSendRequest(uint8[] data);
    
    // 
    // public API
    //
    
    public void processIncommingData(uint8[] data)
    {
        uint start = 0;
        
        // try to find a valid frame within the incomming data
        foreach (uint8 byte in data)
        {
            len++;
            
            // search for the frame end byte, if we found it then we 
            // have found a valid frame
            if (byte == 0x7e)
            {
                // We have found a valid frame, handle it!
                var frame = new Frame();
                if (!frame.unpack(data[start:n]))
                {
                    logger.error("Could not unpack frame!");
                    return;
                }
            
                handleIncommingFrame(frame);
                start = n + 1;
            }
        }
    }
}

} // namespace Msmcomm
