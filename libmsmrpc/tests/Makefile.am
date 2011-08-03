include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	$(GLIB_CFLAGS) \
	$(FSO_CFLAGS) \
	-I$(top_srcdir)/msmrpc \
	$(NULL)

VALAC_ARGS = \
	-C \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/msmrpc \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg msmrpc-1.0 \
	--pkg fsobasics-2.0 \
	--pkg fsotransport-2.0 \
	$(NULL)

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = \
	$(GLIB_LIBS) \
	$(FSO_LIBS) \
	../msmrpc/libmsmrpc.la
	$(NULL)

TEST_PROGS += \
	testrpcclient \
	testxdrbuffer \
	$(NULL)

#
# rpc client test
#
testrpcclient_VALASOURCES = testrpcclient.vala
testrpcclient_SOURCES = testrpcclient.c
$(testrpcclient_SOURCES): $(testrpcclient_VALASOURCES)
	$(VALAC) $(VALAC_ARGS) $^
	touch $@
testrpcclient_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testrpcclient_VALASOURCES)

#
# xdr buffer test
#
testxdrbuffer_VALASOURCES = testxdrbuffer.vala
testxdrbuffer_SOURCES = testxdrbuffer.c
$(testxdrbuffer_SOURCES): $(testxdrbuffer_VALASOURCES)
	$(VALAC) $(VALAC_ARGS) $^
	touch $@
testxdrbuffer_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testxdrbuffer_VALASOURCES)

CLEANFILES = \
    $(TEST_PROGS) \
    *.? \
    $(NULL)

MAINTAINERCLEANFILES = \
  Makefile.in \
  $(NULL)
