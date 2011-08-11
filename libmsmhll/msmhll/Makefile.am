include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	-DG_LOG_DOMAIN=\"libmsmhll\" \
	$(GLIB_CFLAGS) \
	$(GEE_CFLAGS) \
	$(FSO_CFLAGS) \
	$(NULL)

VALAC_ARGS = \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg fsobasics-2.0 \
	--header msmhll.h \
	--library msmhll-1.0 \
	$(NULL)

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

BUILT_SOURCES = msmhll.vala.stamp


lib_LTLIBRARIES = \
	libmsmhll.la \
	$(NULL)

libmsmhll_la_VALASOURCES = \
	crc.vala \
	frame.vala \
	timer.vala \
	contract.vala \
	abstractlinkhandler.vala \
	activelinkhandler.vala \
	flowcontrolhandler.vala \
	linkcontext.vala \
	linklayercontrol.vala \
	setuplinkhandler.vala \
	transmissionhandler.vala \
	$(NULL)

libmsmhll_la_SOURCES = \
	msmhll.vala.stamp \
	$(libmsmhll_la_VALASOURCES:.vala=.c) \
	$(NULL)

msmhllincludedir = $(includedir)/msmhll-1.0
msmhllinclude_HEADERS = msmhll.h

msmhll-1.0.vapi msmhll.vala.stamp: $(libmsmhll_la_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

libmsmhll_la_LIBADD = \
	-lpthread \
	$(GLIB_LIBS) \
	$(GEE_LIBS) \
	$(FSO_LIBS) \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	msmhll-1.0.vapi \
	msmhll-1.0.deps \
	$(NULL)

EXTRA_DIST += \
	$(libmsmhll_la_VALASOURCES) \
	msmhll-1.0.vapi \
	msmhll.vala.stamp \
	$(NULL)

CLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmhll_la_VALASOURCES:.vala=.c) \
	*.vapi \
	*.h \
	$(NULL)


MAINTAINERCLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmhll_la_VALASOURCES:.vala=.c) \
	*.h \
	Makefile.in \
	$(NULL)

