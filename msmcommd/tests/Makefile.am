include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	$(DEPS_CFLAGS) \
	$(MSMCOMM_CFLAGS) \
	$(NULL)

VALAC_ARGS = \
	-C \
	--basedir $(top_srcdir) \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg msmcomm-specs-2.0

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = \
	$(DEPS_LIBS) \
	$(MSMCOMM_SPECS_LIBS)

TEST_PROGS += testmgmt

#
# management test
#
testmgmt_VALASOURCES = testmgmt.vala
testmgmt_SOURCES = testmgmt.c
$(testmgmt_SOURCES): $(testmgmt_VALASOURCES)
	$(VALAC) $(VALAC_ARGS) $^
	touch $@
testmgmt_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testmgmt_VALASOURCES)

CLEANFILES = \
    $(TEST_PROGS) \
    *.? \
    $(NULL)

MAINTAINERCLEANFILES = \
  Makefile.in \
  $(NULL)
