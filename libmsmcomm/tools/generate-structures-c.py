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

base_types = byte_size.keys()

if not len(sys.argv) == 2:
  print "usage: generate_structs.py <struct definition file>"
  sys.exit(1)

def print_indent(str):
  print "%s%s" % (indent_type, str)

def print_object_header():
  print "\n"

def has_len(members, name):
  for n in members:
    if name + "_len" == n['name']:
      return True
  return False

def build_object(name, member_len, parts, gid, mid):
  if not mid is None and not gid is None:
    print "#define %s_GROUP_ID %s" % (string.upper(name), gid)
    print "#define %s_MESSAGE_ID %s" % (string.upper(name), mid)
    print ""

  print "struct %s" % name
  print "{"

  lengths = {}

  for part in parts:
    type = part['type']
    member_name = part['name']
    member_len = part['len']

    if not type in base_types:
        type = "struct " + type
    to_print = "%s %s" % (type, member_name)

    if member_len == 1:
      to_print = "%s;" % to_print
    elif member_len > 1:
      to_print = "%s[%i];" % (to_print, member_len)
      if has_len(parts, member_name):
        lengths[member_name + "_len"] = member_len
      print "#define %s_%s_SIZE %i" % (name.upper(), member_name.upper(), member_len)
    elif member_len == 0:
      continue
    print_indent(to_print)

  print "} __attribute__ ((packed));"

  print ""
  print "static void msmcomm_low_level_structures_%s_init(struct %s* self)" % (name, name)
  print "{"
  for n,l in lengths.iteritems():
    print_indent("self->%s = %i;" % (n, l))
  print "}"

in_object = False
object_name = ""
object_len = 0
object_parts = []
object_gid = None
object_mid = None
unknown_counter = 0
last_end_offset = 0
first_object = True

patterns = {
  'part' : r"^[(.*)] (\w*) (\w*).*$",
}
print "/* "
print " * (c) 2010 by Simon Busch <morphis@gravedo.de>"
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

print "#ifndef STRUCTURES_H_"
print "#define STRUCTURES_H_"
print ""
print "/* All structures in this file are autogenerated by generate_structs.py */"
print ""
print "#include <stdint.h>"
print ""

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
      if len(parts) == 5:
        object_gid = parts[3]
        object_mid = parts[4]
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
      if not part['type'] in byte_size:
        print "fatal error: no valid type '%s'" % line
        sys.exit(1)
      part['len'] = (end_offset - start_offset + 1) / byte_size[part['type']]

      object_parts.append(part)
      last_end_offset = start_offset + part['len'] * byte_size[part['type']]

    elif line.startswith('end') and in_object:
      if not last_end_offset == object_len:
        gap = {}
        gap['name'] = 'unknown%i' % unknown_counter
        unknown_counter += 1
        gap['type'] = 'uint8_t'
        gap['len'] = object_len - last_end_offset
        byte_size[object_name] = object_len
        object_parts.append(gap)
      
      if not first_object:
        print_object_header()
      first_object = False
      build_object(object_name, object_len, object_parts, object_gid, object_mid)

      # reset everything
      object_parts = []
      object_name = ""
      object_len = 0
      object_gid = None
      object_mid = None
      unknown_counter = 0
      in_object = False
      last_end_offset = 0

print ""
print "#endif"
print ""
      

