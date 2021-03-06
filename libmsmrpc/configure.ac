AC_INIT([libmsmrpc], [0.1.0], [morphis@gravedo.de], [libmsmrpc])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_GNU_SOURCE
AC_ISC_POSIX
AC_PROG_CC
AC_STDC_HEADERS
AC_PROG_LIBTOOL
AC_LIBTOOL_DLOPEN

################################################################################
AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

################################################################################
# vala 

VALA_REQUIRED=0.12.1
AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)
m4_ifdef([AM_PROG_VALAC], [AM_PROG_VALAC([$VALA_REQUIRED])])

################################################################################
# glib and friends

GLIB_REQUIRED=2.26

PKG_CHECK_MODULES(GLIB,
  glib-2.0 >= $GLIB_REQUIRED
  gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

################################################################################
# FSO

FSO_BASICS_REQUIRED=0.9.99
FSO_TRANSPORT_REQUIRED=0.9.8

PKG_CHECK_MODULES(FSO,
	fsobasics-2.0 >= $FSO_BASICS_REQUIRED
	fsotransport-2.0 >= $FSO_TRANSPORT_REQUIRED)
AC_SUBST(FSO_CFLAGS)
AC_SUBST(FSO_LIBS)

################################################################################
# check for debugging
AC_ARG_ENABLE(debug,
  [  --enable-debug            Enable debug build (default=disabled)],
  [debug=$enableval], 
  [debug="no"])
AM_CONDITIONAL( [WANT_DEBUG], [test x"$debug" = x"yes"])

################################################################################
AC_CONFIG_FILES([
	Makefile
	msmrpc-1.0.pc
	msmrpc/Makefile
	tests/Makefile
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
