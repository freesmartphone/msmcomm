#!/usr/bin/python

import sys
import string
import re

indent_type = '\t'

byte_size = {
  'uint8_t':  1,
  'int8_t': 1,
  'uint16_t': 2,
  'int16_t': 2,
  'uint32_t': 4,
  'int32_t': 4,
}

if not len(sys.argv) == 2:
  print "usage: generate_structs.py <struct definition file>"
  sys.exit(1)

def print_indent(str):
  print "%s%s" % (indent_type, str)

def build_object(name, len, parts):
  print "struct %s" % name
  print "{"

  for part in parts:
    type = part['type']
    name = part['name']
    len = part['len']

    to_print = "%s %s" % (type, name)

    if len == 1:
      to_print = "%s;" % to_print
    elif len > 1:
      to_print = "%s[%i];" % (to_print, len)
    elif len == 0:
      continue
    print_indent(to_print)

  print "};"

in_object = False
object_name = ""
object_len = 0
object_parts = []
unknown_counter = 0
last_end_offset = 0

patterns = {
  'part' : r"^[(.*)] (\w*) (\w*).*$",
}

with open(sys.argv[1]) as f:
  for line in f:
    line = line.rstrip('\n')
    if line.startswith('#'):
      continue
    elif line.startswith('start') and not in_object:
      in_object = True
      parts = line.split(' ')
      object_name = parts[1]
      object_len = int(parts[2])
    elif line.startswith('[') and in_object:
      start = 0
      rparts = line.split(' ')

      if not len(rparts) == 3:
        print "fatal parsing error: '%s'" % line
        sys.exit(1)

      if not rparts[1] in byte_size:
        print "part type invalid: '%s'" % line
        sys.exit(1)

      # start offset + end offset
      offsets = rparts[0].lstrip('[')
      offsets = offsets.rstrip(']')
      offsets = offsets.split('-')
      if len(offsets) == 1:
        start_offset = int(offsets[0])
        end_offset = int(offsets[0])
      else:
        start_offset = int(offsets[0])
        end_offset = int(offsets[1])
      
      # do we have to fill a gap between the last part and this one?
      if start_offset > last_end_offset:
        gap = {}
        gap['len'] = start_offset - last_end_offset
        gap['name'] = 'unknown%i' % unknown_counter
        unknown_counter += 1
        gap['type'] = 'uint8_t'
        object_parts.append(gap)
        last_end_offset = last_end_offset + gap['len']

      # create current part
      part = {}
      part['name'] = rparts[2]
      part['type'] = rparts[1]
      part['len'] = (end_offset - start_offset +1) / byte_size[part['type']]

      object_parts.append(part)
      last_end_offset = start_offset + part['len']

    elif line.startswith('end') and in_object:
      if not last_end_offset == object_len:
        gap = {}
        gap['name'] = 'unknown%i' % unknown_counter
        unknown_counter += 1
        gap['type'] = 'uint8_t'
        gap['len'] = object_len - last_end_offset
        object_parts.append(gap)
      
      build_object(object_name, object_len, object_parts)

