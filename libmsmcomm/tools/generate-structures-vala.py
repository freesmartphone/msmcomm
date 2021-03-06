#!/usr/bin/python

import sys
import string
import re

indent_type = '\t'
indent = 1

byte_size = {
  'uint8_t':  1,
  'int8_t': 1,
  'uint16_t': 2,
  'int16_t': 2,
  'uint32_t': 4,
  'int32_t': 4,
}

vala_types = {
  'uint8_t':  'uint8',
  'int8_t': 'int8',
  'uint16_t': 'uint16',
  'int16_t': 'int16',
  'uint32_t': 'uint32',
  'int32_t': 'int32',
}


if not len(sys.argv) == 2:
  print "usage: %s <struct definition file>" % sys.argv[0]
  sys.exit(1)

def print_indent(str):
  print "%s%s" % (indent_type * indent, str)

def print_object_header():
  print "\n"

message_type_name_map = {
  'msg' : 'Message',
  'resp' : 'Response',
  'event' : 'Event',
  'field' : 'Field',
}

def format_name(name):
  parts = name.split("_")
  new_name = ""
  for part in parts[:-1]:
    new_name += part.capitalize()
  new_name += message_type_name_map[parts[len(parts)-1]]
  vala_types[name] = new_name
  return new_name

def build_object(name, device_name, len, parts):
  global indent
  vala_name = format_name(name)

  print "[CCode (cname = \"struct %s_%s\", cheader_filename = \"structures.h\", destroy_function = \"\")]" % (device_name, name)
  print "struct %s.%s" % (device_name.capitalize(), vala_name)
  print "{"

  len_params = {}

  for part in parts:
    type = part['type']
    member_name = part['name']
    type_len = part['len']

    # Print all variants of the current part
    for v in part['variants']:
      variant_type_name = format_name(v)
      variant_prop_name = v.replace("_field", "")

      print_indent("public %s %s" % (variant_type_name, variant_prop_name))
      print_indent("{")
      indent += 1
      print_indent("get")
      print_indent("{")
      indent += 1
      print_indent("return (%s?) %s;" % (variant_type_name, member_name))
      indent -= 1
      print_indent("}")
      indent -= 1

      print_indent("}")

    to_print = "public %s %s" % (vala_types[type], member_name)

    if type_len == 1:
      to_print = "%s;" % to_print
    elif type_len > 1:
      to_print = "public %s %s[%i];" % (vala_types[type], member_name, type_len)
    else:
      continue
    print_indent(to_print)
  print_indent("public unowned uint8[] data")
  print_indent("{")
  indent += 1
  print_indent("get")
  print_indent("{")
  indent += 1
  print_indent("unowned uint8[] res = (uint8[])(&this);")
  print_indent("res.length = (int)sizeof( %s );" % (vala_name, ))
  print_indent("return res;")
  indent -= 1
  print_indent("}")
  indent -= 1
  print_indent("}")
  print_indent("[CCode (cname = \"msmcomm_%s_%s_init\")]" % (device_name, name))
  print_indent("public %s();" % vala_name)
  print "}"

in_object = False
object_name = ""
object_device_name = ""
object_len = 0
object_parts = []
unknown_counter = 0
last_end_offset = 0
first_object = True

patterns = {
  'part' : r"^[(.*)] (\w*) (\w*).*$",
}

print "/* "
print " * (c) 2010-2011 by Simon Busch <morphis@gravedo.de>"
print " * All Rights Reserved"
print " *"
print " * This program is free software; you can redistribute it and/or modify"
print " * it under the terms of the GNU General Public License as published by"
print " * the Free Software Foundation; either version 2 of the License, or"
print " * (at your option) any later version."
print " *"
print " * This program is distributed in the hope that it will be useful,"
print " * but WITHOUT ANY WARRANTY; without even the implied warranty of"
print " * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
print " * GNU General Public License for more details."
print " *"
print " * You should have received a copy of the GNU General Public License along"
print " * with this program; if not, write to the Free Software Foundation, Inc.,"
print " * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA."
print " *"
print " */"

print ""
print "/* All structures in this file are autogenerated by %s */" % sys.argv[0]
print ""

print "namespace Msmcomm.LowLevel.Structures"
print "{"

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
      if len(parts) == 4:
        object_device_name = parts[3].split("=")[1]
      else:
        object_device_name = "common"
    elif line.startswith('[') and in_object:
      start = 0
      rparts = line.split(' ')

      if not len(rparts) in (3, 4, 5):
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
        gap['variants'] = []
        gap['name'] = 'unknown%i' % unknown_counter
        unknown_counter += 1
        gap['type'] = 'uint8_t'
        object_parts.append(gap)
        last_end_offset = last_end_offset + gap['len']

      # create current part
      part = {}
      part['name'] = rparts[2]
      part['type'] = rparts[1]
      if not part['type'] in byte_size:
        print "fatal error: no valid type '%s'" % line
        sys.exit(1)
      part['len'] = (end_offset - start_offset + 1) / byte_size[part['type']]

      # append all variant types for the current part
      part['variants'] = []
      if len(rparts) == 4:
        part['variants'] = rparts[3].rstrip("]").lstrip("[").split(",")

      if len(rparts) == 5:
        part['value'] = rparts[4]

      object_parts.append(part)
      last_end_offset = start_offset + part['len'] * byte_size[part['type']]

    elif line.startswith('end') and in_object:
      if not last_end_offset == object_len:
        gap = {}
        gap['name'] = 'unknown%i' % unknown_counter
        gap['variants'] = []
        unknown_counter += 1
        gap['type'] = 'uint8_t'
        gap['len'] = object_len - last_end_offset
        object_parts.append(gap)

      if not first_object:
        print_object_header()
      first_object = False
      byte_size[object_name] = object_len
      build_object(object_name, object_device_name, object_len, object_parts)

      # reset everything
      object_parts = []
      object_name = ""
      object_len = 0
      unknown_counter = 0
      in_object = False
      last_end_offset = 0

print ""
print "} /* namespace Msmcomm.LowLevel.Structures */ "
print ""

