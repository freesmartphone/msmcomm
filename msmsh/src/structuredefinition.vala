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

namespace Msmcomm {

public errordomain StructureDefinitionError {
	COULD_NOT_LOAD_FILE,
	COULD_NOT_PARSE_FILE,
}

public enum FieldType {
	INVALID,
	UINT8,
	UINT16,
	UINT32,
	INT8,
	INT16,
	INT32,
}

public FieldType string_to_field_type(string val) {
	switch (val) {
		case "uint8_t":
			return FieldType.UINT8;
		case "uint16_t":
			return FieldType.UINT16;
		case "uint32_t":
			return FieldType.UINT32;
		case "int8_t":
			return FieldType.INT8;
		case "int16_t":
			return FieldType.INT16;
		case "int32_t":
			return FieldType.INT32;
	}

	return FieldType.INVALID;
}

public class StructureField {
	public string name { get; set; }
	public FieldType f_type { get; set; }
	public int offset_start { get; set; }
	public int offset_end { get; set; }
}

public class StructureDefinition {
	public string name { get; set; }
	public int length { get; set; }
	public Gee.ArrayList<StructureField> fields { get; set; }
	
	public StructureDefinition() {
		fields = new Gee.ArrayList<StructureField>();
	}
}

public class StructureDefinitionReader : Object
{
	private const GLib.MarkupParser _parser = { start, end, text, null, null };
	private GLib.MarkupParseContext _context;
	private StructureDefinition _currentStructureDef;
	private bool _inStructure = false;
	
	public Gee.ArrayList<StructureDefinition> structures { get; set; }
	public string domain_name { get; set; default = "<unknown>"; }


	construct {
		_context = new GLib.MarkupParseContext(_parser, 0, this, destroy); 
		structures = new Gee.ArrayList<StructureDefinition>();
		_currentStructureDef = null;
	}

	public void readFromFile(string path) throws StructureDefinitionError {	
		string line;
		
		// Check if file exits and open it
		var file = File.new_for_path(path);
		if (!file.query_exists(null)) 
			throw new StructureDefinitionError.COULD_NOT_LOAD_FILE(@"could not load structure definiton from file '$(path)'");
		
		try {
			// read content from file
			var inStream = new GLib.DataInputStream(file.read(null));
			var buffer = new GLib.StringBuilder();
			while((line = inStream.read_line(null, null)) != null)
			{
				buffer.append(@"$(line)\n");
			}
			
			// parse file content
			parse(buffer.str);
		}
		catch (Error err) {
			throw new StructureDefinitionError.COULD_NOT_PARSE_FILE(@"Could not load file '$(path)'");
		}
	}
	
	private void destroy() {
	}

	private bool parse(string content) throws MarkupError {
		try {
			return _context.parse(content, -1);
		}
		catch(MarkupError err) {
			stdout.printf(@"$(err.message)");
			throw err;
		}
	}

	private void beginStructure(string name, int length) {
		_currentStructureDef = new StructureDefinition();
		_currentStructureDef.name = name;
		_currentStructureDef.length = length;
		_inStructure = true;
	}

	private void addField(string name, int start, int end, FieldType type) {
		if (_currentStructureDef != null) {
			var field = new StructureField();
			field.name = name;
			field.offset_start = start;
			field.offset_end = end;
			field.f_type = type;
			_currentStructureDef.fields.add(field);
		}
	}

	private void endStructure() {
		if (_currentStructureDef != null) {
			structures.add(_currentStructureDef);
			_currentStructureDef = null;
		}
		_inStructure = false;
	}

	private string getAttrValue(string name, string[] attrNames, string[] attrValues) {
		string retval = "";
		
		for (int n=0; n<attrNames.length; n++) {
			if (attrNames[n] == name) {
				retval = attrValues[n];
				break;
			}
		}
		
		return retval;
	}

	private void start(GLib.MarkupParseContext context, string elementName, 
					   string[] attrNames, string[] attrValues) {
		string name, typeName, offsetStart, offsetEnd, length;
		
		switch (elementName) {
			case "structures":
				domain_name = getAttrValue("domain", attrNames, attrValues);
				break;
			case "structure":
				name = getAttrValue("name", attrNames, attrValues);
				length = getAttrValue("length", attrNames, attrValues);
				
				// Fixup length, if empty
				if (length == "") length = "0";
				
				beginStructure(name, length.to_int());
				_inStructure = true;
				break;
			case "field":
				name = getAttrValue("name", attrNames, attrValues);
				typeName = getAttrValue("type", attrNames, attrValues);
				offsetStart = getAttrValue("start", attrNames, attrValues);
				offsetEnd = getAttrValue("end", attrNames, attrValues);
				
				// Fixup end offset, if empty
				if (offsetEnd == "") offsetEnd = "0";
				
				addField(name, offsetStart.to_int(), offsetEnd.to_int(), 
						 string_to_field_type(typeName));
				break;
			default:
				break;
		}
	}
	
	private void end(GLib.MarkupParseContext context, string elementName) {
		switch (elementName) {
			case "structure":
				endStructure();
				break;
			case "field":
				break;
			default:
				break;
		}
	}
	
	private void text(GLib.MarkupParseContext contxt, string text, size_t text_size) {
	}
}

public class StructureDefinitionWriter {
	public Gee.ArrayList<StructureDefinition> Structures { get; set; }
	public string domain_name { get; set; default = "<unknown>"; }
	
	public void write(string path) {
		try {
			var file = File.new_for_path(path);
			var fileStream = file.create(FileCreateFlags.NONE, null);
			if (file.query_exists(null)) {
				var dataStream = new DataOutputStream(fileStream);
				dataStream.put_string("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", null);
				dataStream.put_string(@"<structures domain=\"$(domain_name)\">\n", null);
				
				foreach (var structure in Structures) {
					dataStream.put_string(@"\t<structure name=\"$(structure.name)\" length=\"$(structure.length)\"", null);
					
					dataStream.put_string(@"\t</structure>", null);
				}
				
				dataStream.put_string("</structures>\n", null);
			}
		}
		catch (GLib.Error err) {
		}
	}
}

} // namespace
