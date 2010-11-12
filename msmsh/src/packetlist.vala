/**
 * This file is part of msmsh
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

using Gtk;
using Pango;

namespace Msmcomm 
{
    public class PacketlistView : GLib.Object 
    {
        private Gtk.Window _window;
        private Controller _controller;
        private Gtk.TreeView packetListView;
        private Gtk.TreeView structuresInfoView;
        private Gtk.ListStore structuresInfoModel;
        private Gtk.ListStore packetListModel;
        private int packetCounter = 0;
        private Gee.HashMap<int, Packet> packets;
        private Gee.HashMap<int, TreeRowReference> rows;
        private TextView packetDumpView;
        private Gtk.TextTag _textTagCovered;
        private Gtk.TextTag _textTagNotCovered;

        construct 
        {
            packets = new Gee.HashMap<int, Packet>();
            rows = new Gee.HashMap<int, TreeRowReference>();
        }

        public PacketlistView(Controller ctrl) 
        {
            _controller = ctrl;

            _window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
            _window.set_default_size(1000, 700);
            _window.set_position(Gtk.WindowPosition.CENTER);
            _window.set_title("Msmcomm Protocol Dissector");
            _window.destroy.connect (Gtk.main_quit);

            var mainBox = new Gtk.VBox(false, 5);
            _window.add(mainBox);

            var toolbar = new Gtk.Toolbar();
            var openButton = new Gtk.ToolButton.from_stock(Gtk.STOCK_OPEN);
            toolbar.add(openButton);
            openButton.clicked.connect(onOpenClicked);
            mainBox.pack_start(toolbar, false, true, 0);
            
            var scroll = new Gtk.ScrolledWindow(null, null);
            scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scroll.set_shadow_type(Gtk.ShadowType.IN);
            
            packetListView = new Gtk.TreeView();
            packetListModel = new Gtk.ListStore(10, typeof(int), typeof(string), typeof(string), 
                                                typeof(string), typeof(string), typeof(string), 
                                                typeof(string), typeof(string), typeof(string),
                                                typeof(string));
            packetListView.set_model(packetListModel);
            packetListView.insert_column_with_attributes(-1, "nr", new Gtk.CellRendererText(), "text", 0); 
            packetListView.insert_column_with_attributes(-1, "direction", new Gtk.CellRendererText(), "text", 1);
            packetListView.insert_column_with_attributes(-1, "frame type", new Gtk.CellRendererText(), "text", 2);
            packetListView.insert_column_with_attributes(-1, "frame seq nr", new Gtk.CellRendererText(), "text", 3);
            packetListView.insert_column_with_attributes(-1, "frame ack nr", new Gtk.CellRendererText(), "text", 4);
            packetListView.insert_column_with_attributes(-1, "subsystem id", new Gtk.CellRendererText(), "text", 5);
            packetListView.insert_column_with_attributes(-1, "group id", new Gtk.CellRendererText(), "text", 6);
            packetListView.insert_column_with_attributes(-1, "msg id", new Gtk.CellRendererText(), "text", 7);
            packetListView.insert_column_with_attributes(-1, "structure type", new Gtk.CellRendererText(), "text", 8);
            packetListView.insert_column_with_attributes(-1, "message type", new Gtk.CellRendererText(), "text", 9);
            packetListView.cursor_changed.connect(onSelectPacket);
            scroll.add(packetListView);
            mainBox.pack_start(scroll, true, true, 0);
            
            scroll = new ScrolledWindow(null, null);
            scroll.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
            scroll.set_shadow_type(ShadowType.IN);
            mainBox.pack_start(scroll, true, true, 0);

            structuresInfoView = new TreeView();
            structuresInfoModel = new Gtk.ListStore(3, typeof(string), typeof(string), typeof(string));
            structuresInfoView.set_model(structuresInfoModel);
            structuresInfoView.insert_column_with_attributes(-1, "Name", new CellRendererText(), "text", 0);
            structuresInfoView.insert_column_with_attributes(-1, "Value (hex)", new CellRendererText(), "text", 1);
            structuresInfoView.insert_column_with_attributes(-1, "Value (ascii)", new CellRendererText(), "text", 2);
            scroll.add(structuresInfoView);

            
            packetDumpView = new Gtk.TextView();
            packetDumpView.editable = false;

            Pango.FontDescription font = Pango.FontDescription.from_string("Terminus 10");
            packetDumpView.modify_font(font);
            
            // Create our colorful tags
            _textTagCovered = packetDumpView.buffer.create_tag("covered", "foreground", "black", "background", "#abd");
            _textTagNotCovered = packetDumpView.buffer.create_tag("not-covered", "foreground", "0x00", "background", "0xff0000");
            
            scroll = new Gtk.ScrolledWindow(null, null);
            scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scroll.add(packetDumpView);
            mainBox.pack_start(scroll, true, true, 0);
        }
        
        private void appendBytesForLineToBuffer(uint offset, uint8[] bytes, bool[] bytes_covered, uint count)
        {
            string line = "", ascii = "", text = "";
            bool last_covered = false;
            
            append_with_tag(packetDumpView.buffer, "%08u ".printf(offset), null);
            
            for (int m = 0; m < count; m++)
            {
                if (bytes_covered[m])
                {
                    var tmp = "";
                    
                    if (last_covered)
                    {
                        tmp = " ";
                    }
                    else
                    {
                        append_with_tag(packetDumpView.buffer, " ", _textTagNotCovered);
                    }
                    
                    tmp += "%02x".printf(bytes[m]);
                    append_with_tag(packetDumpView.buffer, tmp, _textTagCovered);
                            
                    last_covered = true;
                }
                else
                {
                    append_with_tag(packetDumpView.buffer, " %02x".printf(bytes[m]), _textTagNotCovered);
                    last_covered = false;
                }
                        
                if (bytes[m] > 32 && bytes[m] < 128)
                {
                    ascii += "%c".printf(bytes[m]);
                }
                else
                {
                    ascii += ".";
                }
            }
            
            if (count < 16) 
            {
                for (uint n = count; n < 16; n++)
                {
                    append_with_tag(packetDumpView.buffer, "   ", _textTagNotCovered);
                }
            }
                    
            append_with_tag(packetDumpView.buffer, " %s\n".printf(ascii), _textTagNotCovered);
        }
        
        private void showPacketPayload(RawDataBuffer buffer, FieldMap field_map) 
        {
            uint pos = 0, count = 0, offset = 0;
            uint8 bytes[16];
            bool bytes_covered[16];
            
            packetDumpView.buffer.text = "";

            for (int n = (int)buffer.size-1; n >= 0; n--) 
            {            
                bytes[count] = buffer.data[pos];
                bytes_covered[count] = field_map.is_covered((int)pos);
                pos++;
                count++;
                
                if (count >= 16) 
                {
                    appendBytesForLineToBuffer(offset, bytes, bytes_covered, count);
                    offset += count;
                    count = 0;
                }
            }
            
            if (count < 16)
            {
                appendBytesForLineToBuffer(offset, bytes, bytes_covered, count);
            }
        }

        private Packet? getCurrentPacket() 
        {
            Gtk.TreePath p;
            Gtk.TreeIter iter;
            int nr = 0;
            
            packetListView.get_cursor(out p, null);
            
            if (p == null) 
                return null;

            packetListModel.get_iter(out iter, p);
            packetListModel.get(iter, 0, out nr);

            if (nr >= packets.size)
                return null;

            return packets[nr-1];
        }

        private void onSelectPacket() 
        {
            Packet p = getCurrentPacket();
            setCurrentPacket(p);
        }
        
        private FieldMap generateFieldMap(Packet packet)
        {
            var field_map = new FieldMap();
            
            if (packet.message == null || packet.message.fields == null)
                return field_map;
            
            foreach (var field in packet.message.fields)
            {
                field_map.add(field.offset_start, field.offset_end);
            }
            
            return field_map;
        }

        private void setCurrentPacket(Packet packet) 
        {
            structuresInfoModel.clear();
            if (packet.message != null && packet.message.fields != null) 
            {
                foreach (var field_info in packet.message.fields)
                {
                    Gtk.TreeIter iter;
                    structuresInfoModel.append(out iter);
                    structuresInfoModel.set(iter, 0, field_info.name);
                    structuresInfoModel.set(iter, 1, field_info.value_hex);
                    structuresInfoModel.set(iter, 2, field_info.value_ascii);
                }
            }

            // FIXME this should the message payload and not the frame payload !!!
            showPacketPayload(packet.message.payload, generateFieldMap(packet));
        }

        private void onOpenClicked() 
        {
            var file_chooser = new Gtk.FileChooserDialog ("Open File", this._window, Gtk.FileChooserAction.OPEN,
                                                      Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
                                                      Gtk.STOCK_OPEN, Gtk.ResponseType.ACCEPT, null);
            if (file_chooser.run () == Gtk.ResponseType.ACCEPT) 
            {
                string path = file_chooser.get_filename(); 
                _controller.onLoadDump(path);
            }
            file_chooser.destroy ();
        }

        public void show() 
        {
            _window.show_all();
        }

        public void appendPackets(Gee.ArrayList<Packet> packets) 
        {
            int count = 0;
            string description = "";
            string frame_type = "";
            string direction = "";
            string subsystem_id = "";
            string group_id = "";
            string msg_id = "";
            string structure_name = "";
            string msg_type_name = "";
            string frame_seq = "";
            string frame_ack =  "";
            TreeIter? iter = null;
            
            foreach (var packet in packets) 
            {
                description = "";
                subsystem_id = "";
                group_id = "";
                msg_id = "";
                structure_name = "";
                msg_type_name = "";
                frame_seq = "";
                frame_ack = "";
                
                frame_type = frame_type_to_string(packet.frame.fr_type);
                // Only data or acknowledge frames have a sequence or acknowlege number!
                if (packet.frame.fr_type == FrameType.DATA || packet.frame.fr_type == FrameType.ACKNOWLEDGE)
                {
                    frame_seq = "%02x".printf(packet.frame.seq);
                    frame_ack = "%02x".printf(packet.frame.ack);
                }
                direction = fs_action_to_string(packet.frame.fs_action);
                
                if (packet.message != null)
                {
                    subsystem_id = "%02x".printf(packet.message.subsystem_id);
                    group_id = "%02x".printf(packet.message.group_id);
                    msg_id = "%02x".printf(packet.message.msg_id);
                    structure_name = packet.message.structure_name;
                    msg_type_name = packet.message.message_type_name;
                }

                packetListModel.append(out iter);

                this.packets.set(count, packet);
                rows[count] = new TreeRowReference(packetListModel, packetListModel.get_path(iter));
                count++;
                
                packetListModel.set(iter, 0, count);
                packetListModel.set(iter, 1, direction);
                packetListModel.set(iter, 2, frame_type);
                packetListModel.set(iter, 3, frame_seq);
                packetListModel.set(iter, 4, frame_ack);
                packetListModel.set(iter, 5, subsystem_id);
                packetListModel.set(iter, 6, group_id);
                packetListModel.set(iter, 7, msg_id);
                packetListModel.set(iter, 8, structure_name);
                packetListModel.set(iter, 9, msg_type_name);
            }

            if (count > 0) 
            {
                packetListView.set_cursor(rows[0].get_path(), null, false);
            }
        }

        public void clearPacketList() 
        {
            packetListModel.clear();
            packetCounter = 0;
        }
    }
} // namespace

