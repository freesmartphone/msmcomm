AUTOMAKE_OPTIONS =

NULL = 

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER)

VALACFLAGS = \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--header msmcommd.h \
	--library msmcommd-2.0 \
	--gir msmcommd-2.0.gir

BUILT_SOURCES = libmsmcommd_la.vala.stamp

lib_LTLIBRARIES = libmsmcommd.la

libmsmcommd_la_VALASOURCES = \
	management.vala \
	error.vala \
	$(NULL)

libmsmcommddir = $(includedir)/msmcommd-2.0
libmsmcommd_HEADERS = \
	msmcommd.h

vapidir = $(datadir)/vala/vapi
vapi_DATA = \
	msmcommd-2.0.vapi \
	msmcommd-2.0.deps

girdir = $(datadir)/gir-1.0
gir_DATA = msmcommd-2.0.gir

libmsmcommd_la_SOURCES = \
	$(libmsmcommd_la_VALASOURCES:.vala=.c)

msmcommd-2.0.deps libmsmcommd_la.vala.stamp: 
	$(VALAC) -C ${VALACFLAGS} --basedir . $(libmsmcommd_la_VALASOURCES)
	touch $@


if TYPELIB
typelibdir = $(libdir)/girepository-1.0
typelib_DATA = msmcommd-2.0.typelib

msmcommd-1.0.typelib: msmcommd-2.0.gir
	$(GIR_COMPILER) --includedir /usr/share/gir-1.0/ msmcommd-2.0.gir -o msmcommd-2.0.typelib
endif

libmsmcommd_la_LIBADD = \
	$(DEPS_LIBS)

EXTRA_DIST = \
	$(libmsmcommd_la_VALASOURCES) \
	libmsmcommd_la.vala.stamp

CLEANFILES = \
	*.c \
	*.h \
	*.vapi \
	*.gir \
	*.typelib \
	libmsmcommd_la.vala.stamp

DISTCLEANFILES = \
	Makefile.in
