#!/bin/sh
tools/xml-to-sdef.py specs/xml/call.xml specs/xml/sim.xml specs/xml/network.xml specs/xml/system.xml specs/xml/audio.xml specs/xml/gps.xml > specs/msmcomm.sdef
tools/generate_structs.py specs/msmcomm.sdef > src/structures.h
