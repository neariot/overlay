# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# Launchpad repository where "cairo-dock-plugins" lives:
EBZR_REPO_URI="lp:cairo-dock-plug-ins"

# You can specify a certain revision from the repository here.
# Or comment it out to choose the latest ("live") revision.
#EBZR_REVISION="2242"

inherit cmake-utils bzr

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="https://launchpad.net/cairo-dock-plug-ins/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# The next line has been stripped down somewhat from a longer version
# used in the ebuilds of other overlays.  For more info, see:
# https://bugs.launchpad.net/cairo-dock-plug-ins/+bug/922981/comments/8
IUSE="alsa exif gmenu terminal vala webkit xfce xgamma xklavier"

# Installation instructions (from BZR source) and dependencies are listed here:
# http://glx-dock.org/ww_page.php?p=From%20BZR&lang=en

RDEPEND="
	~x11-misc/cairo-dock-${PV}
	x11-libs/cairo
	gnome-base/librsvg
	dev-libs/libxml2
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	terminal? ( x11-libs/vte )
	webkit? ( >=net-libs/webkit-gtk-1.0 )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	vala? ( dev-lang/vala:0.12 )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig
	dev-libs/libdbusmenu:3[gtk]
"

pkg_setup()
{
	ewarn ""
	ewarn ""
	ewarn "THIS IS A LIVE EBUILD, NOT AN OFFICIAL RELEASE."
	ewarn "   Thus, it may FAIL to build properly."
	ewarn "   Please do NOT report bugs to Gentoo's bugzilla."
	ewarn "   Instead, report all bugs to write2david@gmail.com"
	ewarn ""
	ewarn ""
}

src_prepare() {
	bzr_src_prepare
}

# ====  These lines are from someone else's ebuild, with my notes...

# Can't find out what the following line does (no Gentoo documentation on it?) and it seems to find the makefile and compile fine without it, so commenting it out.
#MAKE_IN_SOURCE_BUILD=true

# Actually, it looks like it is supposed to be CMAKE_IN_SOURCE_BUILD
# http://devmanual.gentoo.org/eclass-reference/cmake-utils.eclass/index.html
# But still not needed, so it is still commented out.
#CMAKE_IN_SOURCE_BUILD=true


src_configure() {

	# Next line added because of the same issues/solution as reported on...
	# ... http://glx-dock.org/bg_topic.php?t=5733

	# Where to put this variable declaration was inspired from...
	# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/x11-libs/cairo/cairo-0.1.18.ebuild?hideattic=0&view=markup
	# However, adding this to "configure" not "compile" because the error show
	# up during configure stage.

	# Weird, cairo-dock installs files are under /usr/usr not /usr

    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+${PKG_CONFIG_PATH}:}/usr/usr/lib/pkgconfig"

	# Check the PKG_CONFIG_PATH value to make sure we're good...
	echo "The pkg_config variable is: ${PKG_CONFIG_PATH}"


	# Next line added because of the same issues/solutions reported on...
	# ... # https://bugs.launchpad.net/cairo-dock-plug-ins/+bug/922981
	# 
	# With a solution inspired on...
	# http://code.google.com/p/rion-overlay/source/browse/x11-misc/cairo-dock-plugins/cairo-dock-plugins-2.3.9999.ebuild?spec=svn71d4acbbb8c297b818ff886fb5dd434a6f54c377&r=71d4acbbb8c297b818ff886fb5dd434a6f54c377

	# Some more info...  http://www.cmake.org/Wiki/CMake_Useful_Variables
	mycmakeargs="${mycmakeargs} -DROOT_PREFIX=${D} -DCMAKE_INSTALL_PREFIX=/usr"
	cmake-utils_src_configure
}

pkg_postinst() {
	ewarn ""
	ewarn ""
	ewarn "THIS IS A LIVE EBUILD, NOT AN OFFICIAL RELEASE."
	ewarn "   Thus, it may FAIL to run properly."
	ewarn "   Please do NOT report bugs to Gentoo's bugzilla."
	ewarn "   Instead, report all bugs to write2david@gmail.com"
	ewarn ""
	ewarn ""
	# Dealing with the weird issue of cairo-dock installing under /usr/usr
	# Without this next line, cairo-dock won't start
	ln -s /usr/usr/lib/libgldi.so.3 /usr/lib/libgldi.so.3
}

