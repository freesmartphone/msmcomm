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

namespace Msmcomm {

public class ResultNode {
	private Gtk.TreeStore _model;
	private Gtk.TreeIter _parent_iter;
	private Gtk.TreeIter _iter;

	public IResult result { get; set; }

	public ResultNode(Gtk.TreeStore model, Gtk.TreeIter parent_iter, IResult res) {
		_model = model;
		_parent_iter = parent_iter;
		_model.append(out _iter, _parent_iter);
		result = res;
		
		propagate_data_transfer_object(result.to_data_transfer_object());
	}

	private void propagate_data_transfer_object(DataTransferObject dto) {
		_model.set(_iter, 0, @"", 1, @"$(dto.name)", -1);
		foreach (var key in dto.fields.keys) {
			Gtk.TreeIter iter;
			_model.append(out iter, _iter);
			_model.set(iter, 0, "", 1, @"$(key): $(dto.fields[key])", -1);
		}
	}
}

public class PacketNode {
	private Gtk.TreeStore _model;
	private Gtk.TreeIter? _parent_iter;
	private Gtk.TreeIter _iter;
	private Gee.ArrayList<ResultNode> _nodes;
	
	public PacketNode(Gtk.TreeStore model, Gtk.TreeIter? parent_iter) {
		_nodes = new Gee.ArrayList<ResultNode>();
		_model = model;
		_parent_iter = parent_iter;
		_model.append(out _iter, _parent_iter);
	}

	public void append_result(IResult result) {
		var node = new ResultNode(_model, _iter, result);
		_nodes.add(node);
	}

	public void update_title() {
		string title = generate_title_from_nodes();
		_model.set(_iter, 0, "", 1, @"$(title)", -1);
	}

	private string generate_title_from_nodes() {
		string title = "";
		foreach (var node in _nodes) {
			title += node.result.append_to_title;
		}
		return title;
	}
}

public class PacketlistView : GLib.Object {
	private Gtk.Window _window;
	private Controller _controller;
	private Gtk.TreeView _packetListView;
	private Gtk.TreeStore _packetListModel;
	private int _packet_counter = 0;
	private Gee.ArrayList<PacketNode> _packet_nodes;

	construct {
		_packet_nodes = new Gee.ArrayList<PacketNode>();
	}

	public PacketlistView(Controller ctrl) {
		_controller = ctrl;

		_window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		_window.set_default_size(800, 600);
		_window.set_position(Gtk.WindowPosition.CENTER);
		_window.set_title("Msmcomm - FIXME");
		_window.destroy.connect (Gtk.main_quit);
	
		var mainBox = new Gtk.VBox(false, 0);

		var toolbar = new Gtk.Toolbar();
		var openButton = new Gtk.ToolButton.from_stock(Gtk.STOCK_OPEN);
		toolbar.add(openButton);
		openButton.clicked.connect(on_open_clicked);
		mainBox.pack_start(toolbar, false, true, 0);

		var scroll = new Gtk.ScrolledWindow(null, null);
		scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
		
		_packetListView = new Gtk.TreeView();
		_packetListModel = new Gtk.TreeStore(2, typeof(string), typeof(string));
		_packetListView.set_model(_packetListModel);
		_packetListView.set_enable_tree_lines(true);
		_packetListView.insert_column_with_attributes(-1, "Nr", new Gtk.CellRendererText(), "text", 0); 
		_packetListView.insert_column_with_attributes(-1, "Description", new Gtk.CellRendererText(), "text", 1);
		scroll.add(_packetListView);
		mainBox.pack_start(scroll, true, true, 0);
		
		_window.add(mainBox);
	}

	private void on_open_clicked() {
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

	private PacketNode new_packet_node() {
		return new PacketNode(_packetListModel, null);
	}

	public void append_packet_with_results(Gee.ArrayList<IResult> results) {
		if (results.size == 0) return;
		
		var node = new_packet_node();
		foreach (var result in results) {
			node.append_result(result);
		}
		node.update_title();
		_packet_nodes.add(node);
	}

	public void clearPacketList() {
		_packetListModel.clear();
		_packet_counter = 0;
	}
}

} // namespace

