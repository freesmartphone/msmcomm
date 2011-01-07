AC_INIT([msmcommd-specs], [0.6.0], [smartphones-standards@linuxtogo.org], [msmcommd-specs])
AC_CONFIG_SRCDIR([src/Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

VALA_REQUIRED=0.11.1
AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)
m4_ifdef([AM_PROG_VALAC], [AM_PROG_VALAC([$VALA_REQUIRED])])

AC_ARG_ENABLE(typelib,
	[AS_HELP_STRING([--enable-typelib],
		[enable typelib generation (default is no)])],
	[ ],
	[enable_typelib=no])
AM_CONDITIONAL([TYPELIB], [test x$enable_typelib != xno])

AS_IF([test "x$enable_typelib" != xno],
	[AC_PATH_PROG(GIR_COMPILER, g-ir-compiler, :)
	 AC_SUBST(GIR_COMPILER)
	 AS_IF([test "$GIR_COMPILER" = :],
		[AC_MSG_ERROR([g-ir-compiler not found])])])

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

GLIB_REQUIRED=2.26.0

# build time specs
PKG_CHECK_MODULES(DEPS,
	glib-2.0 >= $GLIB_REQUIRED
	gobject-2.0 >= $GLIB_REQUIRED
	gio-2.0 >= $GLIB_REQUIRED
	gthread-2.0 >= $GLIB_REQUIRED)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)

AC_CONFIG_FILES([
	Makefile
	src/Makefile
	msmcomm-specs-2.0.pc
])
AC_OUTPUT
