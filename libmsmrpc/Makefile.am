SUBDIRS = \
	msmrpc \
	tests

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = msmrpc-1.0.pc

EXTRA_DIST = \
	MAINTAINERS \
	msmcomm-1.0.pc.in

# Extra clean files so that maintainer-clean removes *everything*
MAINTAINERCLEANFILES = \
	aclocal.m4 compile config.guess config.sub \
	configure depcomp install-sh ltmain.sh     \
	Makefile.in missing config.h.in            \
	mkinstalldirs src/Makefile.in
