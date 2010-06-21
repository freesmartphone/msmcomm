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

public enum FrameType
{
    SYNC,
    SYNC_RESP,
    CONFIG,
    CONFIG_RESP,
    ACK,
    DATA,
}

public string frameTypeToString(FrameType type)
{
    string result = "<unknown>";
    switch (type) 
    {
        case FrameType.SYNC:
            result = "SYNC";
            break;
        case FrameType.SYNC_RESP:
            result = "SYNC_RESPONSE";
            break;
        case FrameType.CONFIG:
            result = "CONFIG";
            break;
        case FrameType.CONFIG_RESP:
            result = "CONFIG_RESP";
            break;
        case FrameType.ACK:
            result = "ACK";
            break;
        case FrameType.DATA:
            result = "DATA";
            break;
    }
    return result;
}

private uint8 frameTypeToByte(FrameType type)
{
    uint8 result = 0x0;
    switch (type)
    {
        case FrameType.SYNC:
            result = 0x1;
            break;
        case FrameType.SYNC_RESP:
            result = 0x2;
            break;
        case FrameType.CONFIG:
            result = 0x3;
            break;
        case FrameType.CONFIG_RESP:
            result = 0x4;
            break;
        case FrameType.ACK:
            result = 0x5;
            break;
        case FrameType.DATA:
            result = 0x6;
            break;
    }
    return result;
}

private FrameType frameTypeFromByte(uint8 byte)
{
    FrameType result = FrameType.SYNC;
    switch (byte)
    {
        case 0x1:
            result = FrameType.SYNC;
            break;
        case 0x2:
            result = FrameType.SYNC_RESP;
            break;
        case 0x3:
            result = FrameType.CONFIG;
            break;
        case 0x4:
            result = FrameType.CONFIG_RESP;
            break;
        case 0x5:
            result = FrameType.ACK;
            break;
        case 0x6:
            result = FrameType.DATA;
            break;
    }
    return result;
}

/**
 * @class Msmcomm.Frame
 **/
public class Frame
{
    public uint8 addr { get; set; }
    public uint8 seq { set; get; }
    public uint8 ack { set; get; }
    public uint16 crc { set; get; }
    public FrameType type { set; get; }
    public uint8 flags { get; set; default = 0x0; }
    public uint8[] payload { get; set; }
    
    /**
     * Replace all occurences of 0x7d and 0x7e in the byte array with 
     * 0x7d 0x5d resp. 0x7d 0x5e.
     * 
     * @return byte array with encoded data
     **/
    private uint8[] encode(uint8[] data)
    {
        var buffer = new GLib.ByteArray();
        
        foreach (uint8 byte in data)
        {
            if (byte == 0x7d)
            {
                buffer.append(new uint8[] { 0x7d, 0x5d });
            }
            else if (byte == 0x7e)
            {
                buffer.append(new uint8[] { 0x7d, 0x5e });
            }
            else 
            {
                buffer.append(new uint8[] { byte });
            }
        }
        
        return buffer.data;
    }
    
    /**
     * Replace all occurences of 0x7d 0x5d or 0x7d 0x5e in the byte array 
     * with 0x7d resp. 0x7e.
     * 
     * @return byte array with decoded data
     **/
    private uint8[] decode(uint8[] data)
    {
        var buffer = new GLib.ByteArray();
        uint n = 0;
        
        foreach (uint8 byte in data)
        {
            if (byte == 0x7d && (n+1 < data.length && data[n+1] == 0x5d))
            {
                buffer.append(0x7d);
            }
            else if (byte == 0x7d && (n+1 < data.length && data[n+1] == 0x5e))
            {
                buffer.append(0x7e);
            }
            else
            {
                buffer.append(byte);
            }
            n++;
        }
    }
    
    /**
     * Pack all frame properties into a byte array for additional 
     * processing
     * 
     * @return the packed byte array for the frame
     **/
    public uint8[] pack()
    {
        var buffer = new GLib.ByteArray.sized(3 + payload.length + 2 + 1);
        uint16 crc = 0x0;
        
        // create header for this frame
        var header = new uint8[3];
        header[0] = addr;
        header[1] = (frameTypeToByte(type) << 4) | flags;
        header[2] = (seq << 4) | ack;
        data.append(header);
        
        // append payload
        buffer.append(payload);
        
        // compute and append crc checksum
        crc = Crc16.calculate(buffer.data);
        buffer.append(crc);
        
        // encode frame data
        var data = buffer.data;
        data = encode(data);
        
        // static frame end byte
        data[data.length-1] = 0x7e;
        
        return data;
    }
    
    /**
     * Unpack a frame from a byte array
     **/
    public bool unpack(uint8[] data)
    {
        uint16 crc = 0x0, fr_crc = 0x0, crc_result = 0xf0b8;
        
        // check data length, should be a least the header + crc + end byte
        if (data.length < 6)
        {
            return false;
        }
        
        // decode frame data first!
        data = decode(data);
    
        // calculate crc16 checksum
        fr_crc = (data[data.length - 2] << 8) | data[data.length - 1];
        crc = Crc16.caculate(data);
        
        if (crc != crc_result)
        {
            return false;
        }
        
        // fill header properties from data
        addr = data[0];
        type = frameTypeFromByte((data[1] & 0xf0 >> 4));
        flags = data[1] & 0x0f;
        seq = (data[2] & 0xf0) >> 4;
        ack = data[2] & 0x0f;
        
        return true;
    }
}

} // namespace Msmcomm
