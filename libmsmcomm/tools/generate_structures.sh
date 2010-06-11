#!/bin/sh
tools/xml-to-sdef.py specs/structures/call.xml specs/structures/sim.xml specs/structures/network.xml specs/structures/system.xml specs/structures/audio.xml specs/structures/gps.xml specs/structures/sms.xml > specs/msmcomm.sdef
tools/generate_structs.py specs/msmcomm.sdef > src/structures.h
