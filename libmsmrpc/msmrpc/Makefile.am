include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	-DG_LOG_DOMAIN=\"libmsmrpc\" \
	$(GLIB_CFLAGS) \
	$(FSO_CFLAGS) \
	$(NULL)

VALAC_ARGS = \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg fsobasics-2.0 \
	--pkg fsotransport-2.0 \
	--header msmrpc.h \
	--library msmrpc-1.0 \
	$(NULL)

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

BUILT_SOURCES = msmrpc.vala.stamp


lib_LTLIBRARIES = \
	libmsmrpc.la \
	$(NULL)

libmsmrpc_la_VALASOURCES = \
	common.vala \
	client.vala \
	xdrbuffer.vala \
	rpc.vala \
	oemrapiclient.vala \
	callbackregistry.vala \
	$(NULL)

libmsmrpc_la_SOURCES = \
	msmrpc.vala.stamp \
	$(libmsmrpc_la_VALASOURCES:.vala=.c) \
	$(NULL)

msmrpcincludedir = $(includedir)/msmrpc-1.0
msmrpcinclude_HEADERS = msmrpc.h

msmrpc-1.0.vapi msmrpc.vala.stamp: $(libmsmrpc_la_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

libmsmrpc_la_LIBADD = \
	-lpthread \
	$(GLIB_LIBS) \
	$(FSO_LIBS) \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	msmrpc-1.0.vapi \
	msmrpc-1.0.deps \
	$(NULL)

EXTRA_DIST += \
	$(libmsmrpc_la_VALASOURCES) \
	msmrpc-1.0.vapi \
	msmrpc.vala.stamp \
	$(NULL)

CLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmrpc_la_VALASOURCES:.vala=.c) \
	*.vapi \
	*.h \
	$(NULL)


MAINTAINERCLEANFILES = \
	$(BUILT_SOURCES) \
	$(libmsmrpc_la_VALASOURCES:.vala=.c) \
	*.h \
	Makefile.in \
	$(NULL)

