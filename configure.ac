AC_INIT([msmcomm], [0.5.0], [morphis@gravedo.de], [msmcomm])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_GNU_SOURCE
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_LIBTOOL

################################################################################
AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

################################################################################
# Check for libreadline and/or libhistory
#
AC_CHECK_LIB(readline, rl_bind_key,
             [LIBREADLINE=-lreadline
              AC_DEFINE(HAVE_LIBREADLINE, 1,
               [Define to one if you have -lreadline])],
             [LIBREADLINE=], "$LIBTERMCAP")
AC_SUBST(LIBREADLINE)
AC_SUBST(LIBTERMCAP)

AC_CHECK_LIB(history, add_history,
             [LIBHISTORY=-lhistory
              AC_DEFINE(HAVE_LIBHISTORY, 1,
               [Define to one if you have -lhistory])],
             [LIBHISTORY=])

# If libhistory does not provide add_history check if libreadline has it.
if test -z "$LIBHISTORY" && test -n "$LIBREADLINE"; then
  AC_CHECK_LIB(readline, add_history,
               [LIBHISTORY=-lreadline
                AC_DEFINE(HAVE_LIBHISTORY, 1,
                     [Define to one if you have -lhistory])],
               [LIBHISTORY=])
fi

AC_SUBST(LIBHISTORY)

################################################################################
# check for debugging
AC_ARG_ENABLE(debug,
  [  --enable-debug            Enable debug build (default=disabled)],
  [debug=$enableval], 
  [debug="no"])
AM_CONDITIONAL( [WANT_DEBUG], [test x"$debug" = x"yes"])

################################################################################
VALA_REQUIRED=0.7.10
GLIB_REQUIRED=2.12.0
GEE_REQUIRED=0.5
FSOT_REQUIRED=0.9
GTK_REQUIRED=2.10.0

PKG_CHECK_MODULES(VALA,
  vala-1.0 >= $VALA_REQUIRED)
AC_SUBST(VALA_CFLAGS)
AC_SUBST(VALA_LIBS)

PKG_CHECK_MODULES(DEPS,
  glib-2.0 >= $GLIB_REQUIRED
  gobject-2.0 >= $GLIB_REQUIRED
  gthread-2.0 >= $GLIB_REQUIRED
  gee-1.0 >= $GEE_REQUIRED
  fsotransport-2.0 >= $FSOT_REQUIRED
  gio-2.0 >= $GLIB_REQUIRED
  gtk+-2.0 >= $GTK_REQUIRED)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)

################################################################################
AC_CONFIG_FILES([
	Makefile
	msmcommd/Makefile
	msmcommd/conf/Makefile
	msmcommd/src/Makefile
	msmcommd/tests/Makefile
	libmsmcomm/Makefile
	libmsmcomm/msmcomm-1.0.pc
	libmsmcomm/src/Makefile
	libmsmcomm/vapi/Makefile
	libmsmcomm/tests/Makefile
	msmvterm/Makefile
	msmvterm/src/Makefile
])

AC_OUTPUT

#
# Info
#
echo
echo
echo
echo "------------------------------------------------------------------------"
echo "$PACKAGE_NAME $PACKAGE_VERSION"
echo "------------------------------------------------------------------------"
echo
echo "  Compilation...............: make"
echo
echo "  Installation..............: make install"
echo
echo "    prefix..................: $prefix"
echo
