DESCRIPTION = "Low level protocol implementation for binary protocol spoken by some Qualcome modems"
HOMEPAGE = "http://www.freesmartphone.org/"
AUTHOR = "Simon Busch <morphis@gravedo.de>"
SECTION = "console/network"
LICENSE = "GPL"
PV = "0.1.0+gitr${SRCREV}"
PR = "r1"

SRC_URI = "${FREESMARTPHONE_GIT}/msmcomm.git;protocol=git;branch=master"
S = "${WORKDIR}/git/msmcommd"

inherit autotools

