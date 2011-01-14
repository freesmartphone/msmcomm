SUBDIRS = \
	src \
	vapi \
	tests

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = msmcomm-1.0.pc

EXTRA_DIST = \
	MAINTAINERS \
	msmcomm-1.0.pc.in

# Extra clean files so that maintainer-clean removes *everything*
MAINTAINERCLEANFILES = \
	aclocal.m4 compile config.guess config.sub \
	configure depcomp install-sh ltmain.sh     \
	Makefile.in missing config.h.in            \
	mkinstalldirs src/Makefile.in

STRUCTURE_SPECS = \
	specs/structures/cm_call.xml \
	specs/structures/sim.xml \
	specs/structures/network.xml \
	specs/structures/system.xml \
	specs/structures/audio.xml \
	specs/structures/gps.xml \
	specs/structures/sms.xml

generate-structures:
	$(top_srcdir)/tools/xml-to-sdef.py $(STRUCTURE_SPECS) > $(top_srcdir)/specs/msmcomm.sdef
	$(top_srcdir)/tools/generate-structures-c.py $(top_srcdir)/specs/msmcomm.sdef > $(top_srcdir)/src/structures.h
