include $(top_srcdir)/Makefile.decl

NULL =

AM_CFLAGS = \
	$(GLIB_CFLAGS) \
	-I$(top_srcdir)/msmhll \
	$(NULL)

VALAC_ARGS = \
	-C \
	--basedir $(top_srcdir) \
	--vapidir $(top_srcdir)/msmhll \
	--pkg posix \
	--pkg glib-2.0 \
	--pkg msmhll-1.0 \
	$(NULL)

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = \
	$(GLIB_LIBS) \
	../msmhll/libmsmhll.la
	$(NULL)

TEST_PROGS += \
	$(NULL)

#
# xdr buffer test
#
#testxdrbuffer_VALASOURCES = testxdrbuffer.vala
#testxdrbuffer_SOURCES = testxdrbuffer.c
#$(testxdrbuffer_SOURCES): $(testxdrbuffer_VALASOURCES)
#	$(VALAC) $(VALAC_ARGS) $^
#	touch $@
#testxdrbuffer_LDADD = $(progs_ldadd)
#EXTRA_DIST += $(testxdrbuffer_VALASOURCES)

CLEANFILES = \
    $(TEST_PROGS) \
    *.? \
    $(NULL)

MAINTAINERCLEANFILES = \
  Makefile.in \
  $(NULL)
