AC_INIT([msmcommd], [0.5.0], [morphis@gravedo.de], [msmcommd])
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
FSO_GLIB_REQUIRED=2010.07.28.1
DBUS_REQUIRED=1.2.16
DBUS_GLIB_REQUIRED=0.84
MSMCOMM_REQUIRED=0.5.0
MSMCOMM_SPECS_REQUIRED=0.1.0

PKG_CHECK_MODULES(VALA,
  vala-0.10 >= $VALA_REQUIRED)
AC_SUBST(VALA_CFLAGS)
AC_SUBST(VALA_LIBS)

PKG_CHECK_MODULES(DEPS,
  glib-2.0 >= $GLIB_REQUIRED
  gio-2.0 >= $GLIB_REQUIRED
  gobject-2.0 >= $GLIB_REQUIRED
  gthread-2.0 >= $GLIB_REQUIRED
  gee-1.0 >= $GEE_REQUIRED
  dbus-1 >= $DBUS_REQUIRED
  dbus-glib-1 >= $DBUS_GLIB_REQUIRED
  fsotransport-2.0 >= $FSOT_REQUIRED
  fso-glib-1.0 >= $FSO_GLIB_REQUIRED
  msmcomm-1.0 >= $MSMCOMM_REQUIRED
  msmcommd-specs-1.0 >= $MSMCOMM_SPECS_REQUIRED)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)


##############################################################################
# dbus conf directory
DBUS_DIR="`$PKG_CONFIG --variable=sysconfdir dbus-1`"
if (test -z "{DBUS_DIR}"); then
  DBUS_DIR="${sysconfdir}/dbus-1"
else
  DBUS_DIR="$DBUS_DIR/dbus-1"
fi
AC_SUBST(DBUS_DIR)

##############################################################################
# dbus service directory
DBUS_SERVICE_DIR="`$PKG_CONFIG --variable=session_bus_services_dir dbus-1`"
if (test -z "{DBUS_SERVICE_DIR}"); then
  DBUS_SERVICE_DIR="${datadir}/dbus-1/services"
fi
AC_SUBST(DBUS_SERVICE_DIR)

################################################################################
AC_CONFIG_FILES([
	Makefile
	conf/Makefile
	data/Makefile
	data/org.msmcomm.service
	src/Makefile
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
