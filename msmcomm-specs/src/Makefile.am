AUTOMAKE_OPTIONS =

NULL = 

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER)

VALACFLAGS = \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--header msmcomm-specs.h \
	--library msmcomm-specs-2.0 \
	--gir msmcomm-specs-2.0.gir

BUILT_SOURCES = libmsmcomm_specs_la.vala.stamp

lib_LTLIBRARIES = libmsmcomm_specs.la

libmsmcomm_specs_la_VALASOURCES = \
	management.vala \
	error.vala \
	misc.vala \
	state.vala \
	sim.vala \
	phonebook.vala \
	call.vala \
	network.vala \
	sound.vala \
	$(NULL)

libmsmcomm_specsdir = $(includedir)/msmcomm-specs-2.0
libmsmcomm_specs_HEADERS = \
	msmcomm-specs.h

vapidir = $(datadir)/vala/vapi
vapi_DATA = \
	msmcomm-specs-2.0.vapi \
	msmcomm-specs-2.0.deps

girdir = $(datadir)/gir-1.0
gir_DATA = msmcomm-specs-2.0.gir

libmsmcomm_specs_la_SOURCES = \
	$(libmsmcomm_specs_la_VALASOURCES:.vala=.c)

msmcomm-specs.h msmcomm-specs-2.0.deps libmsmcomm_specs_la.vala.stamp: $(libmsmcomm_specs_la_VALASOURCES)
	$(VALAC) -C ${VALACFLAGS} --basedir . $(libmsmcomm_specs_la_VALASOURCES)
	touch $@

if TYPELIB
typelibdir = $(libdir)/girepository-1.0
typelib_DATA = msmcomm-specs-2.0.typelib

msmcomm-specs-1.0.typelib: msmcomm-specs-2.0.gir
	$(GIR_COMPILER) --includedir /usr/share/gir-1.0/ msmcomm-specs-2.0.gir -o msmcomm-specs-2.0.typelib
endif

libmsmcomm_specs_la_LIBADD = \
	$(DEPS_LIBS)

EXTRA_DIST = \
	$(libmsmcomm_specs_la_VALASOURCES) \
	libmsmcomm_specs_la.vala.stamp

CLEANFILES = \
	*.c \
	*.h \
	*.vapi \
	*.gir \
	*.typelib \
	libmsmcomm_specs_la.vala.stamp

DISTCLEANFILES = \
	Makefile.in
