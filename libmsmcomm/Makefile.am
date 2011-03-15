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

STRUCTURE_protocol = \
	protocol/structures/common.xml \
	protocol/structures/call.xml \
	protocol/structures/misc.xml \
	protocol/structures/state.xml \
	protocol/structures/sms.xml \
	protocol/structures/sim.xml \
	protocol/structures/phonebook.xml \
	protocol/structures/network.xml \
	protocol/structures/sound.xml \
	protocol/structures/sups.xml \
	protocol/structures/voicemail.xml

generate-structures:
	$(top_srcdir)/tools/xml-to-sdef.py $(STRUCTURE_protocol) > $(top_srcdir)/protocol/msmcomm.sdef
	$(top_srcdir)/tools/generate-structures-c.py $(top_srcdir)/protocol/msmcomm.sdef > $(top_srcdir)/msmcomm/structures.h
	$(top_srcdir)/tools/generate-structures-vala.py $(top_srcdir)/protocol/msmcomm.sdef > $(top_srcdir)/vapi/structures.vapi
