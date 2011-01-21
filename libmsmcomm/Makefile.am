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

STRUCTURE_SPECS = \
	specs/structures/call.xml \
	specs/structures/misc.xml \
	specs/structures/state.xml \
	specs/structures/sms.xml \
	specs/structures/sim.xml \
	specs/structures/phonebook.xml \
	specs/structures/network.xml

generate-structures:
	$(top_srcdir)/tools/xml-to-sdef.py $(STRUCTURE_SPECS) > $(top_srcdir)/specs/msmcomm.sdef
	$(top_srcdir)/tools/generate-structures-c.py $(top_srcdir)/specs/msmcomm.sdef > $(top_srcdir)/msmcomm/structures.h
	$(top_srcdir)/tools/generate-structures-vala.py $(top_srcdir)/specs/msmcomm.sdef > $(top_srcdir)/vapi/structures.vapi
