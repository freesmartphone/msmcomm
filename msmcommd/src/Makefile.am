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
	--pkg dbus-glib-1 \
	--pkg msmcomm-1.0 \
	--pkg msmcommd-1.0 \
	--thread \
	--save-temps \
	--basedir $(top_srcdir)

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

sbin_PROGRAMS = msmcommd

msmcommd_VALASOURCES = \
	contract.vala \
	main.vala \
	crc.vala \
	frame.vala \
	timer.vala \
	util.vala \
	abstractobject.vala \
	linkcontext.vala \
	abstractlinkhandler.vala \
	activelinkhandler.vala \
	flowcontrolhandler.vala \
	setuplinkhandler.vala \
	transmissionhandler.vala \
	linklayercontrol.vala \
	modemcontrol.vala \
	lowlevelcontrol.vala \
	dbusservice.vala \
	commandhandler.vala \
	commands.vala \
	modemchannel.vala \
	commandworker.vala \
	$(NULL)

msmcommd_SOURCES = \
	$(msmcommd_VALASOURCES:.vala=.c) \
	$(NULL)
	
.vala.stamp: $(msmcommd_VALASOURCES)
	$(VALAC) -C $(VALAC_ARGS) $^
	touch $@

msmcommd_LDADD = \
	$(DEPS_LIBS) \
	$(NULL)

EXTRA_DIST = \
	MAINTAINERS \
	$(msmcommd_VALASOURCES) \
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
