/**
 * This file is part of msmsh.
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

using Gee;

namespace Msmcomm {

public errordomain ControllerError {
	CONFIGURATION_NOT_FOUND,
	CONFIGURATION_IS_INVALID,
	ERROR_WHILE_READ_CONFIGURATION,
	NO_STRUCTURES_PATH_FOUND,
	NO_PACKET_DEFINITION_PATH_FOUND,
	COULD_NOT_LOAD_STRUCTURES,
}

public class Controller : GLib.Object {
	private PacketlistView _packetListView;
	private Session current_session;
	
	construct {
	}

	public void setup() throws ControllerError {
		string home_path = Environment.get_variable("HOME");
		
		current_session = new Session();
		current_session.configuration.loadFromFile(home_path);
	}

	private void loadStructureDefinitionsIntoSession(Session session, string path) throws ControllerError {
		try {
			var directory = File.new_for_path(path);
			var enumerator = directory.enumerate_children(FILE_ATTRIBUTE_STANDARD_NAME, 0, null);
			FileInfo fileInfo;
			while ((fileInfo = enumerator.next_file(null)) != null) {
				session.appendStructureDefinitions(loadStructureDefintion(@"$(path)/$(fileInfo.get_name())"));
			}
		}
		catch (Error err) {
			string msg = "ERROR: could not load structure definitions";
			throw new ControllerError.COULD_NOT_LOAD_STRUCTURES(msg);
		}
	}

	private Gee.ArrayList<StructureDefinition> loadStructureDefintion(string path) throws ControllerError {
		try {
			var reader = new StructureDefinitionReader();
			reader.readFromFile(path);
			stdout.printf(@"Read $(reader.structures.size) structures for domain '$(reader.domain_name)'\n");

			return reader.structures;
		}
		catch (StructureDefinitionError err) {
			stdout.printf(@"Could not read structure definitions from '$(path)'\n");
		}

		return null;
	}

	private void loadPacketDefinitions(string path) throws ControllerError {
		try {
			var reader = new PacketDefinitionReader();
			current_session.definitions = reader.read_from_file(path);
		}
		catch (PacketDefinitionError err) {
			stdout.printf(@"Could not read packet definitions from '$(path)'\n");
		}
	}

	public void launch() {
		_packetListView = new PacketlistView(this);
		_packetListView.show();
	}

	public void onLoadDump(string path) {
		try {
			var reader = new DumpReader();
			reader.readFromFile(path);
			stdout.printf(@"INFO: Read $(reader.current_buffers.size) packets from dump '$(path)'\n");

			displayDump(reader.current_buffers);
		}
		catch (DumpReaderError err) {
			stdout.printf(@"ERROR: could not load dump from file '$(path)'\n");
		}
	}

	private void displayDump(Gee.ArrayList<RawDataBuffer> buffers) {
		_packetListView.clearPacketList();
		
		var packets = new Gee.ArrayList<Packet>();
		var worker = new DissectorWorker();
		Packet p;

		foreach (var buffer in buffers) {
			p = worker.run(buffer);
			if (p != null)
				packets.add(p);
		}

		_packetListView.append_packets(packets);
	}

	public void onQuit() {
	}

	public void cleanup() {
	}
}

} // namespace
