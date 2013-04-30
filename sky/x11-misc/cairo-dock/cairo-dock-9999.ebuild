# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils bzr  versionator 

EBZR_REPO_URI="lp:cairo-dock-core"

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="xcomposite"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/libXrender
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	bzr_src_prepare
}

#src_configure() {
#	econf $(use_enable xcomposite xextend)
#}

src_install() {
cd  /var/tmp/portage/x11-misc/cairo-dock-9999/work/cairo-dock-9999_build && emake DESTDIR="${D}" install || die "emake install failed"
}
