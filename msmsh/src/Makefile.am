NULL =

VALAC_ARGS = \
	--vapidir ../vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg readline \
	--pkg config \
	--thread \
	--save-temps \
	--basedir $(top_srcdir)

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

sbin_PROGRAMS = msmsh

msmsh_VALASOURCES = \
	main.vala \
	shell.vala \
	logger.vala \
	commands.vala \
	session.vala \
	controller.vala \
	structuredefinition.vala \
	dump.vala \
	$(NULL)

msmsh_SOURCES = \
	$(msmsh_VALASOURCES:.vala=.c) \
	$(NULL)

.vala.stamp: $(msmsh_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

msmsh_LDADD = \
	$(LIBREADLINE) \
	$(LIBHISTORY) \
	$(DEPS_LIBS) \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
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
