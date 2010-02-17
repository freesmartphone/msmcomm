NULL =

AM_CFLAGS = \
-I$(top_srcdir)/include \
$(NULL)

bin_PROGRAMS = msmcommd msmcterm

msmcommd_SOURCES = msmcommd.c \
                   select.c \
                   timer.c \
                   crc16.c \
                   llc.c \
                   frame.c \
                   log.c \
                   talloc.c \
                   talloc_ctx.c \
                   relay.c \
                   buffer.c \
msmcommd_LDADD =

msmcterm_SOURCES = msmcterm.c select.c timer.c log.c talloc.c talloc_ctx.c
msmcterm_LDADD =
