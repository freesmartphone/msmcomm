NULL =

AM_CFLAGS = \
	-I$(top_srcdir)  \
	-fno-short-enums \
	-DRPC_OFFSET=0 \
	-O0 \
	$(NULL)

if WANT_DEBUG
AM_CFLAGS += \
	-g \
	-DDEBUG \
	-DVERBOSE \
	$(NULL)
endif

lib_LTLIBRARIES = \
	libmsmrpc.la \
	$(NULL)

libmsmrpc_la_SOURCES = \
	clnt.c \
	ops.c \
	rpc.c \
	svc.c \
	svc_clnt_common.c \
	xdr.c \
	$(NULL)

msmrpcincludedir = $(includedir)/msmrpc-1.0
msmrpcinclude_HEADERS = \
	msmrpc.h \
	$(NULL)
msmrpcincludeprivdir = $(includedir)/msmrpc-1.0/msmrpc
msmrpcincludepriv_HEADERS = \
	clnt.h \
	debug.h \
	msmrpc.h \
	pmap_clnt.h \
	rpc.h \
	rpc_router_ioctl.h \
	svc.h \
	types.h \
	xdr.h \
	$(NULL)

libmsmrpc_la_LIBADD = \
	-lpthread \
	$(NULL)
