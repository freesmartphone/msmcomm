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

public class Session : GLib.Object {
	public Configuration configuration { get; set; }
	public ArrayList<PacketDefinition> definitions { get; set; }
	public ArrayList<StructureDefinition> structures { get; set; }

	construct {
		configuration = new Configuration();
		definitions = new ArrayList<PacketDefinition>();
		structures = new ArrayList<StructureDefinition>();
	}

	public void appendStructureDefinitions(ArrayList<StructureDefinition> structdefs) {
		structures.insert_all(structures.size, structdefs);
	}
}

}

