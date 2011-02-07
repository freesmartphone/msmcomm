NULL =

VALAC_ARGS = \
	--debug \
	--vapidir ../vapi \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gee-1.0 \
	--pkg fsotransport-2.0 \
	--pkg fsoframework-2.0 \
	--pkg config \
	--pkg msmcomm-2.0 \
	--pkg msmcomm-specs-2.0 \
	--pkg fso-glib-1.0 \
	--thread \
	--save-temps \
	--basedir $(top_srcdir)

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	$(FSO_CFLAGS) \
	$(MSMCOMM_SPECS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	-DG_LOG_DOMAIN=\"msmcommd\" \
	$(NULL)

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

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
	baseservice.vala \
	miscservice.vala \
	stateservice.vala \
	simservice.vala \
	phonebookservice.vala \
	callservice.vala \
	networkservice.vala \
	serviceconv.vala \
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
	$(FSO_LIBS) \
	$(MSMCOMM_SPECS_LIBS) \
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
