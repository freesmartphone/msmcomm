include $(top_srcdir)/Makefile.decl

NULL = 

AM_CFLAGS = \
	-I$(top_srcdir)/msmcomm \
	$(DEPS_CFLAGS) \
	$(NULL)

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = \
	$(DEPS_LIBS) \
	../msmcomm/libmsmcomm.la

VALAC_ARGS = \
	-C \
	--thread \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/msmcomm \
	--vapidir $(top_srcdir)/vapi \
	--pkg structures \
	--pkg glib-2.0 \
	--pkg gee-1.0 \
	--pkg msmcomm-2.0 \
	--pkg fsobasics-2.0

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

EXTRA_DIST += \
	$(NULL)

#
# message disassembler test
#
#TEST_PROGS += testmessagedisassembler
#testmessagedisassembler_VALASOURCES = testmessagedisassembler.vala
#testmessagedisassembler_SOURCES = testmessagedisassembler.c
#$(testmessagedisassembler_SOURCES): $(testmessagedisassembler_VALASOURCES)
#	$(VALAC) $(VALAC_ARGS) $^
#	touch $@
#testmessagedisassembler_LDADD = $(progs_ldadd)
#EXTRA_DIST += $(testmessagedisassembler_VALASOURCES)

#TEST_PROGS += testmessageassembler
#testmessageassembler_VALASOURCES = testmessageassembler.vala
#testmessageassembler_SOURCES = testmessageassembler.c
#$(testmessageassembler_SOURCES): $(testmessageassembler_VALASOURCES)
#	$(VALAC) $(VALAC_ARGS) $^
#	touch $@
#testmessageassembler_LDADD = $(progs_ldadd)
#EXTRA_DIST += $(testmessageassembler_VALASOURCES)

#TEST_PROGS += testmessageutils
#testmessageutils_VALASOURCES = testmessageutils.vala
#testmessageutils_SOURCES = testmessageutils.c
#$(testmessageutils_SOURCES): $(testmessageutils_VALASOURCES)
#	$(VALAC) $(VALAC_ARGS) $^
#	touch $@
#testmessageutils_LDADD = $(progs_ldadd)
#EXTRA_DIST += $(testmessageutils_VALASOURCES)



CLEANFILES = \
	$(TEST_PROGS) \
	*.? \
	$(NULL)

MAINTAINERCLEANFILES = \
	Makefile.in \
	*.la \
	*.lo \
	$(NULL)
