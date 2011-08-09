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
	--pkg fsobasics-2.0 \
	--pkg fsotransport-2.0 \
	$(NULL)

if WANT_DEBUG
VALAC_ARGS += -g -D DEBUG
AM_CFLAGS += -ggdb -O0
endif

EXTRA_DIST += \
	$(NULL)

TEST_PROGS += testpalmpreaccess
testpalmpreaccess_VALASOURCES = testpalmpreaccess.vala
testpalmpreaccess_SOURCES = testpalmpreaccess.c
$(testpalmpreaccess_SOURCES): $(testpalmpreaccess_VALASOURCES)
	$(VALAC) $(VALAC_ARGS) $^
	touch $@
testpalmpreaccess_LDADD = $(progs_ldadd)
EXTRA_DIST += $(testpalmpreaccess_VALASOURCES)

CLEANFILES = \
	$(TEST_PROGS) \
	*.? \
	$(NULL)

MAINTAINERCLEANFILES = \
	Makefile.in \
	*.la \
	*.lo \
	$(NULL)
