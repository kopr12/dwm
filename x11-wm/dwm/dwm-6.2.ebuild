# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit savedconfig toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"
SRC_URI="https://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="attachaside alphaborder center hidevacanttags pertag personal restartsig roundedcorners systray vanitygaps xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
	roundedcorners? ( x11-libs/libXext
					  x11-libs/libxcb
	)
"

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk || die

	eapply "${FILESDIR}/config-mk.diff"
	eapply "${FILESDIR}/config.diff"
	eapply "${FILESDIR}/dwm-patches-6.2.diff"
	eapply "${FILESDIR}/drw-patches-6.2.diff"
	eapply_user

	if use roundedcorners; then
		sed -i -e 's/ROUNDEDCORNERSFLAGS =.*/ROUNDEDCORNERSFLAGS = -DROUNDEDCORNERS/g' config.mk || die
		sed -i -e 's/ROUNDEDCORNERSLIBS =.*/ROUNDEDCORNERSLIBS = -lxcb -lxcb-shape/g' config.mk || die
	else
		sed -i -e 's/ROUNDEDCORNERSFLAGS =.*/ROUNDEDCORNERSFLAGS = /g' config.mk || die
		sed -i -e 's/ROUNDEDCORNERSLIBS =.*/ROUNDEDCORNERSLIBS = /g' config.mk || die
	fi
	if use attachaside; then
		sed -i -e 's/ATTACHASIDEFLAGS =.*/ATTACHASIDEFLAGS = -DATTACHASIDE/g' config.mk || die
	else
		sed -i -e 's/ATTACHASIDEFLAGS =.*/ATTACHASIDEFLAGS = /g' config.mk || die
	fi
	if use center; then
		sed -i -e 's/CENTERFLAGS =.*/CENTERFLAGS = -DCENTER/g' config.mk || die
	else
		sed -i -e 's/CENTERFLAGS =.*/CENTERFLAGS = /g' config.mk || die
	fi
	if use alphaborder; then
		sed -i -e 's/ALPHABORDERFLAGS =.*/ALPHABORDERFLAGS = -DALPHABORDER/g' config.mk || die
	else
		sed -i -e 's/ALPHABORDERFLAGS =.*/ALPHABORDERFLAGS = /g' config.mk || die
	fi
	if use pertag; then
		sed -i -e 's/PERTAGFLAGS =.*/PERTAGFLAGS = -DPERTAG/g' config.mk || die
	else
		sed -i -e 's/PERTAGFLAGS =.*/PERTAGFLAGS = /g' config.mk || die
	fi
	if use systray; then
		sed -i -e 's/SYSTRAYFLAGS =.*/SYSTRAYFLAGS = -DSYSTRAY/g' config.mk || die
	else
		sed -i -e 's/SYSTRAYFLAGS =.*/SYSTRAYFLAGS = /g' config.mk || die
	fi
	if use personal; then
		sed -i -e 's/PERSONALFLAGS =.*/PERSONALFLAGS = -DPERSONAL/g' config.mk || die
	else
		sed -i -e 's/PERSONALFLAGS =.*/PERSONALFLAGS = /g' config.mk || die
	fi
	if use vanitygaps; then
		sed -i -e 's/VANITYGAPSFLAGS =.*/VANITYGAPSFLAGS = -DVANITYGAPS/g' config.mk || die
	else
		sed -i -e 's/VANITYGAPSFLAGS =.*/VANITYGAPSFLAGS = /g' config.mk || die
	fi
	if use restartsig; then
		sed -i -e 's/RESTARTSIGFLAGS =.*/RESTARTSIGFLAGS = -DRESTARTSIG/g' config.mk || die
	else
		sed -i -e 's/RESTARTSIGFLAGS =.*/RESTARTSIGFLAGS = /g' config.mk || die
	fi
	if use hidevacanttags; then
		sed -i -e 's/HIDEVACANTTAGSFLAGS =.*/HIDEVACANTTAGSFLAGS = -DHIDEVACANTTAGS/g' config.mk || die
	else
		sed -i -e 's/HIDEVACANTTAGSFLAGS =.*/HIDEVACANTTAGSFLAGS = /g' config.mk || die
	fi
	

	restore_config config.h
}

src_compile() {
	if use xinerama; then
		emake CC=$(tc-getCC) dwm
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/dwm-session2 dwm

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/dwm.desktop

	dodoc README

	save_config config.h
}
