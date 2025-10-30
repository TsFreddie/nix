{ pkgs, extra }:

with pkgs;
with extra;
[
  icu
  zlib
  zstd
  stdenv.cc.cc
  stdenv.cc.cc.lib
  curl
  openssl
  attr
  libssh
  bzip2
  libxml2
  acl
  libsodium
  util-linux
  xz
  systemd

  xorg.libX11
  xorg.libXext
  xorg.libXi
  xorg.libXrender
  xorg.libXtst
  xorg.libXrandr
  xorg.libXinerama
  xorg.libXcursor
  xorg.libXdamage
  xorg.libXfixes
  xorg.libXcomposite
  xorg.libxkbfile
  xorg.libxcb
  freetype
  fontconfig
  glib
  gtk3
  cairo
  pango
  gdk-pixbuf
  atk
  libsecret
  nspr
  nss
  cups
  dbus
  at-spi2-atk
  at-spi2-core
  libdrm
  mesa
  expat
  alsa-lib
  pulseaudio
]
