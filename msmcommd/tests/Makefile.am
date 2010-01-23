INCLUDES = $(all_includes) -I$(top_srcdir)/include
AM_CFLAGS=-Wall -ggdb3

noinst_PROGRAMS = frame_test

frame_test_SOURCES = frame_test.c \
    $(top_srcdir)/src/log.c \
    $(top_srcdir)/src/frame.c \
    $(top_srcdir)/src/talloc.c \
    $(top_srcdir)/src/talloc_ctx.c
