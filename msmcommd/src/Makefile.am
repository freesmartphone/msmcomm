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
	--pkg msmhll-1.0 \
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
	util.vala \
	abstractobject.vala \
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
	voicemailservice.vala \
	soundservice.vala \
	smsservice.vala \
	supsservice.vala \
	gpsservice.vala \
	serviceconv.vala \
	modemchannel.vala \
	commandhandler.vala \
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
