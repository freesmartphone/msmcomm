NULL =

dbusconfdir = @DBUS_DIR@/system.d
dist_dbusconf_DATA = msmcommd.conf

dbusservicedir = @DBUS_SERVICE_DIR@/../system-services
dbusservice_in_file = org.msmcomm.service.in
dist_dbusservice_DATA = $(dbusservice_in_file:.service.in=.service)

CLEANFILES = $(dist_dbusservice_DATA)
MAINTAINERCLEANFILES = Makefile.in

