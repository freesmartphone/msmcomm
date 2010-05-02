NULL =

VALAC_ARGS = \
	--vapidir ../vapi \
	--vapidir $(top_srcdir)/libmsmcomm/vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg gtk+-2.0 \
	--pkg config \
	--pkg msmcomm-1.0 \
	--thread \
	-g \
	--save-temps \
	--basedir $(top_srcdir)

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-I$(top_srcdir)/libmsmcomm/src \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

sbin_PROGRAMS = msmsh

msmsh_VALASOURCES = \
	main.vala \
	controller.vala \
	structuredefinition.vala \
	dump.vala \
	tvbuf.vala \
	dissector.vala \
	packetlist.vala \
	packetdefinition.vala \
	configuration.vala \
	session.vala \
	$(NULL)

msmsh_SOURCES = \
	$(msmsh_VALASOURCES:.vala=.c) \
	$(NULL)

.vala.stamp: $(msmsh_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

msmsh_LDADD = \
	$(DEPS_LIBS) \
	../../libmsmcomm/src/libmsmcomm.la \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
	util.c \
	$(msmsh_VALASOURCES) \
	$(BUILT_SOURCES) \
	$(NULL)

CLEANFILES = \
	*.? \
	*.l? \
	$(BUILT_SOURCES) \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

MAINTAINERCLEANFILES = aclocal.m4 compile config.guess config.sub \
                       configure depcomp install-sh ltmain.sh     \
                       Makefile.in missing config.h.in            \
                       intltool-extract \
                       intltool-merge \
                       intltool-update \
                       mkinstalldirs \
                       *.c *.h \
                       $(NULL)
