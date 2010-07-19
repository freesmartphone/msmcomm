NULL =

VALAC_ARGS = \
	--debug \
	--vapidir ../vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg fsotransport-2.0 \
	--pkg config \
	--thread \
	--save-temps \
	--basedir $(top_srcdir)

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

sbin_PROGRAMS = msmlogd

msmlogd_VALASOURCES = \
	main.vala \
	worker.vala \
	$(NULL)

msmlogd_SOURCES = \
	$(msmlogd_VALASOURCES:.vala=.c) \
	$(NULL)

.vala.stamp: $(msmlogd_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

msmlogd_LDADD = \
	$(DEPS_LIBS) \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
	$(msmlogd_VALASOURCES) \
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
