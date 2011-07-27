include $(top_srcdir)/Makefile.decl

NULL =

SUBDIRS = \
	msmcomm \
	vapi \
	tests \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = msmcomm-2.0.pc

EXTRA_DIST += \
	MAINTAINERS \
	msmcomm-2.0.pc.in

# Extra clean files so that maintainer-clean removes *everything*
MAINTAINERCLEANFILES = \
	aclocal.m4 compile config.guess config.sub \
	configure depcomp install-sh ltmain.sh     \
	Makefile.in missing config.h.in            \
	mkinstalldirs src/Makefile.in              \
	$(NULL)

STRUCTURES_palmpre = \
	protocol/structures/palmpre/common.xml \
	protocol/structures/palmpre/call.xml \
	protocol/structures/palmpre/misc.xml \
	protocol/structures/palmpre/state.xml \
	protocol/structures/palmpre/sms.xml \
	protocol/structures/palmpre/sim.xml \
	protocol/structures/palmpre/phonebook.xml \
	protocol/structures/palmpre/network.xml \
	protocol/structures/palmpre/sound.xml \
	protocol/structures/palmpre/sups.xml \
	protocol/structures/palmpre/voicemail.xml \
	protocol/structures/palmpre/pdsm.xml

STRUCTURES = \
	$(STRUCTURES_palmpre) \
	$(NULL)

generate-structures:
	$(top_srcdir)/tools/xml-to-sdef.py $(STRUCTURES) > $(top_srcdir)/protocol/msmcomm.sdef
	$(top_srcdir)/tools/generate-structures-c.py $(top_srcdir)/protocol/msmcomm.sdef > $(top_srcdir)/msmcomm/structures.h
	$(top_srcdir)/tools/generate-structures-vala.py $(top_srcdir)/protocol/msmcomm.sdef > $(top_srcdir)/vapi/structures.vapi
