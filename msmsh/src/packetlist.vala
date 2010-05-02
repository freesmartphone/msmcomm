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

namespace Msmcomm {

public class LeftLabel : Gtk.Label {
        public LeftLabel(string? text = null) {
                if (text != null)
                        set_markup("<b>%s</b>".printf(text));
                set_alignment(1, 0);
                set_padding(6, 0);
        }
}

public class RightLabel : Gtk.Label {
        public RightLabel(string? text = null) {
                set_text_or_na(text);
                set_alignment(0, 1);
                set_ellipsize(Pango.EllipsizeMode.START);
                set_selectable(true);
        }

        public void set_text_or_na(string? text = null) {
                if (text == null)
                        set_markup("<i>n/a</i>");
                else
                        set_text(text);
        }
}

public class PacketlistView : GLib.Object {
	private Gtk.Window _window;
	private Controller _controller;
	private Gtk.TreeView packetListView;
	private Gtk.TreeView structuresInfoView;
	private Gtk.ListStore structuresInfoModel;
	private Gtk.ListStore packetListModel;
	private int packetCounter = 0;
	private Gee.HashMap<int, Packet> packets;
	private Gee.HashMap<int, TreeRowReference> rows;
	private RightLabel label_type;
	private RightLabel label_ack;
	private RightLabel label_seq;
	private RightLabel label_read_write;
	private RightLabel label_is_complete;
	private RightLabel label_is_valid;
	private TextView packetDumpView;

	construct {
		packets = new Gee.HashMap<int, Packet>();
		rows = new Gee.HashMap<int, TreeRowReference>();
	}

	public PacketlistView(Controller ctrl) {
		_controller = ctrl;

		_window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		_window.set_default_size(1000, 700);
		_window.set_position(Gtk.WindowPosition.CENTER);
		_window.set_title("Msmcomm - FIXME");
		_window.destroy.connect (Gtk.main_quit);

		var mainBox = new Gtk.VBox(false, 5);
		_window.add(mainBox);

		var toolbar = new Gtk.Toolbar();
		var openButton = new Gtk.ToolButton.from_stock(Gtk.STOCK_OPEN);
		toolbar.add(openButton);
		openButton.clicked.connect(onOpenClicked);
		mainBox.pack_start(toolbar, false, true, 0);

		Gtk.Paned hpaned = new Gtk.HPaned();
		mainBox.pack_start(hpaned, true, true, 0);

		var scroll = new Gtk.ScrolledWindow(null, null);
		scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
		scroll.set_shadow_type(Gtk.ShadowType.IN);
		
		packetListView = new Gtk.TreeView();
		packetListModel = new Gtk.ListStore(2, typeof(int), typeof(string));
		packetListView.set_model(packetListModel);
		packetListView.insert_column_with_attributes(-1, "Nr", new Gtk.CellRendererText(), "text", 0); 
		packetListView.insert_column_with_attributes(-1, "Description", new Gtk.CellRendererText(), "text", 1);
		packetListView.cursor_changed.connect(onSelectPacket);
		scroll.add(packetListView);
		hpaned.pack1(scroll, true, false);

		var vbox = new Gtk.VBox(false, 6);
		hpaned.pack2(vbox, true, false);

		var table = new Gtk.Table(11, 2, false);
		table.set_row_spacings(6);
		vbox.pack_start(table, false, false, 0);

		label_type = new RightLabel();
		table.attach(new LeftLabel("Type:"), 0, 1, 0, 1, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_type, 1, 2, 0, 1, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);

		label_seq = new RightLabel();
		table.attach(new LeftLabel("Sequence Nr:"), 0, 1, 1, 2, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_seq, 1, 2, 1, 2, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		
		label_ack = new RightLabel();
		table.attach(new LeftLabel("Acknowledge Nr:"), 0, 1, 2, 3, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_ack, 1, 2, 2, 3, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		
		label_is_valid = new RightLabel();
		table.attach(new LeftLabel("Is Valid:"), 0, 1, 3, 4, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_is_valid, 1, 2, 3, 4, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		
		label_is_complete = new RightLabel();
		table.attach(new LeftLabel("Is Complete:"), 0, 1, 4, 5, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_is_complete, 1, 2, 4, 5, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		
		label_read_write = new RightLabel();
		table.attach(new LeftLabel("Read/Write:"), 0, 1, 6, 7, AttachOptions.FILL, AttachOptions.FILL, 0, 0);
		table.attach(label_read_write, 1, 2, 6, 7, AttachOptions.EXPAND|AttachOptions.FILL, AttachOptions.FILL, 0, 0);

		scroll = new ScrolledWindow(null, null);
		scroll.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		scroll.set_shadow_type(ShadowType.IN);
 		scroll.add(structuresInfoView);
 		vbox.pack_start(scroll, true, true, 0);

 		structuresInfoView = new TreeView();
 		structuresInfoModel = new Gtk.ListStore(2, typeof(string), typeof(string));
 		structuresInfoView.set_model(structuresInfoModel);
 		structuresInfoView.insert_column_with_attributes(-1, "Name", new CellRendererText(), "text", 0);
 		structuresInfoView.insert_column_with_attributes(-1, "Value", new CellRendererText(), "text", 1);
 		scroll.add(structuresInfoView);

		
		packetDumpView = new Gtk.TextView();
		packetDumpView.editable = false;
		scroll = new Gtk.ScrolledWindow(null, null);
		scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
		scroll.add(packetDumpView);
		vbox.pack_start(scroll, true, true, 0);
	}


	private Packet? getCurrentPacket() {
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

	private void onSelectPacket() {
		Packet p = getCurrentPacket();
		setCurrentPacket(p);
	}

	private void setCurrentPacket(Packet packet) {
		label_type.set_text(frame_type_to_string(packet.frame.fr_type));
		label_seq.set_text("0x%x".printf(packet.frame.seq));
		label_ack.set_text("0x%x".printf(packet.frame.ack));
		if (packet.frame.is_valid)
			label_is_valid.set_text("true");
		else 
			label_is_valid.set_text("false");
		if (packet.frame.is_complete)
			label_is_complete.set_text("true");
		else 
			label_is_complete.set_text("false");
		label_read_write.set_text(fs_action_to_string(packet.frame.fs_action));
	}

	private void onOpenClicked() {
		var file_chooser = new Gtk.FileChooserDialog ("Open File", this._window, Gtk.FileChooserAction.OPEN,
												  Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
												  Gtk.STOCK_OPEN, Gtk.ResponseType.ACCEPT, null);
		if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
			string path = file_chooser.get_filename(); 
			_controller.onLoadDump(path);
		}
		file_chooser.destroy ();
	}

	public void show() {
		_window.show_all();
	}

	public void append_packets(Gee.ArrayList<Packet> packets) {
		int count = 0;
		string description;
		string type;
		string read_write;
		TreeIter? iter = null;
		
		foreach (var p in packets) {
			type = frame_type_to_string(p.frame.fr_type);
			read_write = fs_action_to_string(p.frame.fs_action);
			description = @"[$(read_write)] '$(type)', <FIXME>";

			packetListModel.append(out iter);

			this.packets.set(count, p);
			rows[count] = new TreeRowReference(packetListModel, packetListModel.get_path(iter));
			count++;
			
			packetListModel.set(iter, 0, count, 1, description);
		}

		if (count > 0) {
			packetListView.set_cursor(rows[0].get_path(), null, false);
		}
	}

	public void clearPacketList() {
		packetListModel.clear();
		packetCounter = 0;
	}
}

} // namespace

