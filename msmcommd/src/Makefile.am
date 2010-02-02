NULL =

AM_CFLAGS = \
-I$(top_srcdir)/include \
-pg \
$(NULL)

bin_PROGRAMS = msmcommd msmcterm msmc_forward

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
msmcommd_LDADD = -pg

msmcterm_SOURCES = msmcterm.c select.c timer.c log.c talloc.c talloc_ctx.c
msmcterm_LDADD =

msmc_forward_SOURCES = forward.c
msmc_forward_LDADD =
