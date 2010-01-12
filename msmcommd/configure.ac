AC_INIT([msmcommd], [0.1], [morphis@gravedo.de], [msmcommd])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

AC_PROG_CC
AC_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AC_PREFIX_DEFAULT(/usr/local)

if (test "${CFLAGS}" = ""); then
  CFLAGS="-Wall -O2"
fi
  
AC_LANG_C
AC_PROG_INSTALL

AC_CONFIG_FILES([Makefile src/Makefile tests/Makefile])
AC_OUTPUT
  
