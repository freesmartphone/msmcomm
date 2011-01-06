include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	$(NULL)

VALAC_ARGS = \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/vapi \
	--pkg structures \
	--pkg glib-2.0 \
	--pkg gee-1.0 \
	--pkg fsobasics-2.0 \
	--header msmcomm.h \
	--library msmcomm-2.0

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

BUILT_SOURCES = msmcomm.vala.stamp

lib_LTLIBRARIES = \
	libmsmcomm.la
	$(NULL)

libmsmcomm_la_VALASOURCES = \
	abstractobject.vala \
	messagetype.vala \
	messageresulttype.vala \
	messageclass.vala \
	basemessage.vala \
	callmessage.vala \
	statemessage.vala \
	basemessagegroup.vala \
	callmessagegroup.vala \
	messageassembler.vala \
	messagedisassembler.vala \
	$(NULL)

libmsmcomm_la_SOURCES = \
	msmcomm.vala.stamp \
	$(libmsmcomm_la_VALASOURCES:.vala=.c) \
	$(NULL)

msmcommincludedir = $(includedir)/msmcomm-2.0
msmcomminclude_HEADERS = msmcomm.h

msmcomm-2.0.vapi msmcomm.vala.stamp: $(libmsmcomm_la_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

libmsmcomm_la_LIBADD = \
	$(GLIB_LIBS) \
	$(LIBNL_LIBS) \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	msmcomm-2.0.vapi \
	$(NULL)

EXTRA_DIST += \
	$(libmsmcomm_la_VALASOURCES) \
	msmcomm-2.0.vapi \
	msmcomm.vala.stamp

CLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmcomm_la_VALASOURCES:.vala=.c) \
	$(NULL)


MAINTAINERCLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmcomm_la_VALASOURCES:.vala=.c) \
	Makefile.in \
	$(NULL)

