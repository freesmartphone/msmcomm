NULL =
EXTRA_CFLAGS = 

if WANT_DEBUG
EXTRA_CFLAGS += -g
endif

AM_CFLAGS = \
	-I../include \
	$(EXTRA_CFLAGS)
	$(NULL)

bin_PROGRAMS = \
	msmcommd

msmcommd_SOURCES = msmcommd.c \
                   util.c \
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
                   config.c \
msmcommd_LDADD =
