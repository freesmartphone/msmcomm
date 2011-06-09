#!/usr/bin/env python

import re, string, sys

patterns = {
    "all-message-types": "^HCI_.*[RSP|CMD|EVT]$",
    "subys-types": "^HCI_SUBSYS_.*$",
    "cmd-types": "^HCI_.*[RSP]$",
    "evt-types": "^HCI_.*[RSP]$",
    "rsp-types": "^HCI_.*[RSP]$",
}

stores = {
    "all-message-types": [],
    "subys-types": [],
    "cmd-types": [],
    "evt-types": [],
    "rsp-types": [],
}

def add_type(pattern, type):
    store = stores[pattern]
    if store != None and not type in store:
        store.append(type)

with open(sys.argv[1]) as f:
    for line in f:
        for p in patterns.iterkeys():
            mo = re.match(patterns[p], line)
            if mo:
                add_type(p, line.rstrip("\n"))

for s in stores.iterkeys():
    print "%s count: %i" % (s, len(stores[s]))
