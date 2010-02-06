NULL =

AUTOMAKE_OPTIONS = subdir-objects
VALAC_ARGS = \
	--vapidir vapi \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg dbus-glib-1 \
	--pkg fsotransport-2.0 \
	--pkg readline \
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

fso_term_VALASOURCES = \
	src/main.vala \
	src/terminal.vala \
	src/reader.vala \
	src/abysstransport.vala \
	$(NULL)

fso_term_SOURCES = \
	$(fso_term_VALASOURCES:.vala=.c) \
	$(NULL)

src/.vala.stamp: $(fso_term_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

fso_term_LDADD = \
	$(LIBREADLINE) \
	$(LIBHISTORY) \
	$(DEPS_LIBS) \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
	$(fso_term_VALASOURCES) \
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
