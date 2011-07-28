#!/usr/bin/env python
# -*- coding: utf-8 -*-
# (C) 2010-2011 Simon Busch <morphis@gravedo.de>
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
        self.devices = {}
        self.structures = []
        self.structure = {}
        self.device_structures = {}
        self.field = {}
        self.text = ""
        self.device = ""
        self.anonymous_count = 0

    def startDocument(self):
        pass

    def endDocument(self):
        pass

    def startElement(self, element, attrs):
        if element.startswith("namespace"):
            self.namespace = element.split(':')[1]
            self.device = attrs.get('device', 'none')
        elif element == "structures":
            self.structures = []
        elif element == "structure":
            self.anonymous_count = 0
            self.structure = {}
            self.structure['name'] = attrs.get('name')
            self.structure['length'] = attrs.get('length')
            self.structure['fields'] = []
            type_size[self.structure['name']] = self.structure['length']
        elif element == "field":
            self.field = {}
            self.field['name'] = attrs.get('name', None)
            # If no name set we have a anonymous field
            if self.field['name'] == None:
                self.field['name'] = "value%i" % self.anonymous_count
                self.anonymous_count += 1
            self.field['start'] = attrs.get('start', 0)
            self.field['end'] = attrs.get('end', 0)
            self.field['type'] = attrs.get('type', 'uint8_t')
            self.field['value'] = attrs.get('value', None)
            self.field['variants'] = []
        elif element == "variant":
            v = {}
            v['name'] = attrs.get('name')
            v['type'] = attrs.get('type')
            self.field['variants'].append(v)

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
        elif element.startswith("namespace"):
            if not self.device_structures.has_key(self.device) or self.device_structures[self.device] == None:
                self.device_structures[self.device] = self.structures
            else:
                for item in self.structures:
                    self.device_structures[self.device].append(item)

    def dump(self, f):
        for d in self.device_structures:
            for s in self.device_structures[d]:
                f.write("start %s %s device=%s\n" % (s['name'], s['length'], d))
                for field in s['fields']:
                    r = ""
                    start = int(field['start'])
                    end = int(field['end'])
                    if end <= start:
                        r = "[%i]" % start
                    elif end > start:
                        r = "[%i-%i]" % (start, end)

                    f.write("%s %s %s" % (r, field['type'], field['name']))
                    if not len(field['variants']) == 0:
                        f.write(" [")
                        count = 0
                        for v in field['variants']:
                            f.write("%s" % (v['type']))
                            if not count == len(field['variants']) - 1:
                                f.write(",")
                            count += 1
                        f.write("]")
                    if not field['value'] == None:
                        f.write(" = %s" % field['value'])
                    f.write("\n")
                f.write("end\n")
                f.write("\n")

if __name__ == "__main__":
    f = sys.stdout
    for filename in sys.argv[1:]:
        handler = Handler()
        xml.sax.parse(filename, handler)
        handler.dump(f)

