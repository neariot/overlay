# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypy/pypy-1.5.ebuild,v 1.2 2011/06/24 09:18:38 djc Exp $

EAPI="2"

inherit eutils

DESCRIPTION="PyPy is a very compliant implementation of the Python language"
HOMEPAGE="http://pypy.org/"
SRC_URI=""

LICENSE="MIT"
SLOT="2.0"
KEYWORDS="~x86 ~amd64"
IUSE="+jit stackless"
RESTRICT="mirror"

MY_PN="pypy"
S="${WORKDIR}/pypy-c-*-linux*"

pkg_setup() {
	if use amd64 && use stackless ; then
		einfo
		ewarn "There's no binary available with stackless support for amd64"
		ewarn "architectures. \"stackless\" USE flag will be ignored"
	fi
	if use !amd64 && use jit && use stackless ; then
		einfo
		ewarn "You have enabled both the \"jit\" as well as the \"stackless\""
		ewarn "USE flags."
		ewarn "At the moment it is not possible to have pypy with support for"
		ewarn "the JIT compiler and both stackless."
		ewarn "JIT will be used in this case. If you want stackless support,"
		ewarn "unset the \"jit\" USE flag and leave only \"stackless\" set."
	fi
}

src_unpack() {
        export http_proxy=127.0.0.1:8087
        wget http://cdn.bitbucket.org/pypy/pypy/downloads/pypy-2.0-beta2-linux64-libc2.15.tar.bz2
        tar -jxf pypy-2.0-beta2-linux64-libc2.15.tar.bz2
        mv pypy*/* ./
}

src_install() {
        local INSDESTTREE=/usr/$(get_libdir)/pypy${SLOT}
        doins -r bin include lib_pypy lib-python 
        fperms a+x $INSDESTTREE/bin/pypy
        dosym ../$(get_libdir)/pypy${SLOT}/bin/pypy /usr/bin/pypy
        dosym ../$(get_libdir)/pypy${SLOT}/bin/pypy /usr/bin/pypy-c${SLOT} 
        dodir $INSDESTTREE/site-packages
}
