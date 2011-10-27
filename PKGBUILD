# Maintainer: feuri

pkgname=neticon-bzr
pkgver=1
pkgrel=1
pkgdesc="A utility to display your current network status in the tray"
arch=(i686 x86_64)
url=https://github.com/feuri/NetIcon
license=(GPL3)
depends=(glib2 gtk3)
makedepends=(git vala)

_gitroot="git://github.com/feuri/NetIcon.git"
_gitname="NetIcon"

build()
{
  git clone $_gitroot #$_gitname
  cd $_gitname
  make
  make DESTDIR="${pkgdir}" install
}
