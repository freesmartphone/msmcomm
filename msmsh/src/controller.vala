/**
 * This file is part of msmvterm.
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

public class Controller {
	public Session CurrentSession { get; set; }
	
	public Controller() {
		resetSession();
	}
	
	public void onLoadStructureDefinitions(string path) {
		try {
			StructureDefinitionReader reader = new StructureDefinitionReader();
			reader.readFromFile(path);
			CurrentSession.registerStructures(reader.DomainName, reader.Structures);
			
			stdout.printf(@"Read $(reader.Structures.size) structures for domain '$(reader.DomainName)'\n");
		}
		catch (StructureDefinitionError err) {
			stdout.printf(@"Could not read structure definitions from '$(path)'\n");
		}
	}
	
	private void listStructures(ArrayList<StructureDefinition> structs) {
		int n = 0;
		foreach (var structure in structs) {
			stdout.printf(@"$(n): $(structure.Name)\n");
			n++;
		}
	}
	
	public void onListStructures() {
		foreach (var domain in CurrentSession.Domains.keys) {
			ArrayList<StructureDefinition> structs = CurrentSession.Domains.get(domain);
			stdout.printf("=====================================\n");
			stdout.printf(@"Domain '$(domain)'\n");
			stdout.printf("=====================================\n");
			listStructures(structs);
		}
	}
	
	public void onListStructuresWithDomain(string domain) {
		if (CurrentSession.Domains.has_key(domain)) {
			ArrayList<StructureDefinition> structs = CurrentSession.Domains.get(domain);
			stdout.printf("=====================================\n");
			stdout.printf(@"structures for '$(domain)'\n");
			stdout.printf("=====================================\n");
			listStructures(structs);
		}
		else {
			stdout.printf(@"There are no structures for the domain '$(domain)'\n");
		}
	}
	
	public void resetSession() {
		if (CurrentSession != null) {
			CurrentSession.cleanup();
		}
		
		CurrentSession = new Session();
	}
}

} // namespace
