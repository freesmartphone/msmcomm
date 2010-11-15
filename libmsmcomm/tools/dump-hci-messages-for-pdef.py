#!/usr/bin/env python

import sys

with open(sys.argv[1]) as f:
  current_group = ""
  current_group_id = 0x0
  current_message_id = 0x0
  for line in f:
    if line.startswith("#"):
      continue
    line = line.rstrip("\n")
    parts = line.split(", ")
    if current_group == "":
      current_group = parts[0]
    elif not current_group == parts[0]:
      current_group = parts[0]
      current_group_id += 1
      current_message_id = 0x0
    
    if current_group == sys.argv[2]:
      print "0x%02x 0x%02x none %s" % (current_group_id, current_message_id, parts[1])
   
    current_message_id += 1

