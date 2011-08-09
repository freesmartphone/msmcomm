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
	structures/palmpre/common.xml \
	structures/palmpre/call.xml \
	structures/palmpre/misc.xml \
	structures/palmpre/state.xml \
	structures/palmpre/sms.xml \
	structures/palmpre/sim.xml \
	structures/palmpre/phonebook.xml \
	structures/palmpre/network.xml \
	structures/palmpre/sound.xml \
	structures/palmpre/sups.xml \
	structures/palmpre/voicemail.xml \
	structures/palmpre/pdsm.xml

STRUCTURES = \
	$(STRUCTURES_palmpre) \
	$(NULL)

generate-structures:
	$(top_srcdir)/tools/xml-to-sdef.py $(STRUCTURES) > $(top_srcdir)/structures/msmcomm.sdef
	$(top_srcdir)/tools/generate-structures-c.py $(top_srcdir)/structures/msmcomm.sdef > $(top_srcdir)/msmcomm/structures.h
	$(top_srcdir)/tools/generate-structures-vala.py $(top_srcdir)/structures/msmcomm.sdef > $(top_srcdir)/vapi/structures.vapi
