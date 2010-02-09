NULL =

AUTOMAKE_OPTIONS = subdir-objects
VALAC_ARGS = \
	--vapidir vapi \
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

SUBDIRS = \
	$(NULL)

INCLUDES = \
	-I$(top_srcdir) \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = src/.vala.stamp

sbin_PROGRAMS = msmvterm

msmvterm_VALASOURCES = \
	src/main.vala \
	src/terminal.vala \
	src/commands.vala \
	$(NULL)

msmvterm_SOURCES = \
	$(msmvterm_VALASOURCES:.vala=.c) \
	$(NULL)

src/.vala.stamp: $(msmvterm_VALASOURCES)
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
	src/*.? \
	src/*.l? \
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
                       src/*.c src/*.h \
                       $(NULL)
