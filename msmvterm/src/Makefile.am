NULL =

VALAC_ARGS = \
	--vapidir $(top_srcdir)/libmsmcomm/vapi \
	--vapidir ../vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg fsotransport-2.0 \
	--pkg readline \
	--pkg msmcomm-1.0 \
	--pkg config \
	--thread \
	--save-temps \
	--basedir $(top_srcdir)

INCLUDES = \
	-I$(top_srcdir) \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

sbin_PROGRAMS = msmvterm

msmvterm_VALASOURCES = \
	main.vala \
	terminal.vala \
	commands.vala \
	$(NULL)

msmvterm_SOURCES = \
	$(msmvterm_VALASOURCES:.vala=.c) \
	$(NULL)

.vala.stamp: $(msmvterm_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

msmvterm_LDADD = \
	$(LIBREADLINE) \
	$(LIBHISTORY) \
	$(DEPS_LIBS) \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
	$(msmvterm_VALASOURCES) \
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
