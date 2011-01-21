#!/usr/bin/env python
# -*- coding: utf-8 -*-
# (C) 2010 Simon Busch <morphis@gravedo.de>
# GPLv2 or later
#

__version__ = "0.0.1"

import sys
import xml.sax
from xml.sax.handler import ContentHandler

def convert_str_to_int(str):
	try:
		ret = int(str)
	except ValueError:
		ret = None
	return ret

type_size = {
  'uint8_t':  1,
  'int8_t': 1,
  'uint16_t': 2,
  'int16_t': 2,
  'uint32_t': 4,
  'int32_t': 4,
}

class Handler(ContentHandler):
	def __init__(self):
		ContentHandler.__init__(self)
		self.namespace = ""
		self.structures = []
		self.structure = {}
		self.field = {}
		self.text = ""

	def startDocument(self):
		pass

	def endDocument(self):
		pass

	def startElement(self, element, attrs):
		if element.startswith("namespace"):
			self.namespace = element.split(':')[1]
		elif element == "structures":
			self.structures = []
		elif element == "structure":
			self.structure = {}
			self.structure['name'] = attrs.get('name')
			self.structure['length'] = attrs.get('length')
			self.structure['fields'] = []
			if not attrs.get('group_id') is None and not attrs.get('message_id') is None:
				self.structure['gid'] = attrs.get('group_id')
				self.structure['mid'] = attrs.get('message_id')
			type_size[self.structure['name']] = self.structure['length']
		elif element == "field":
			self.field = {}
			self.field['name'] = attrs.get('name')
			self.field['start'] = attrs.get('start', 0)
			self.field['end'] = attrs.get('end', 0)
			self.field['type'] = attrs.get('type', 'uint8_t')

	def characters(self, char):
		c =char.strip() + " "
		if c:
			self.text += c

	def endElement(self, element):
		if element == "structure":
			self.structures.append(self.structure)
			self.structure = None
		elif element == "field":
			self.structure['fields'].append(self.field)

	def dump(self, f):
		f.write("#-------------------------------------------------------------------\n")
		f.write("# %s\n" % self.namespace.upper())
		f.write("#-------------------------------------------------------------------\n")
		f.write("")
		for s in self.structures:
			if len(s) == 5:
				f.write("start %s %s %s %s\n" % (s['name'], s['length'], s['gid'], s['mid']))
			else:
				f.write("start %s %s\n" % (s['name'], s['length']))
			for field in s['fields']:
				r = ""
				start = int(field['start'])
				end = int(field['end'])
				if end <= start:
					r = "[%i]" % start
				elif end > start:
					r = "[%i-%i]" % (start, end)

				f.write("%s %s %s\n" % (r, field['type'], field['name']))
			f.write("end\n")
			f.write("\n")
			
		

if __name__ == "__main__":
	f = sys.stdout
	for filename in sys.argv[1:]:
		handler = Handler()
		xml.sax.parse(filename, handler)
		handler.dump(f)
		

