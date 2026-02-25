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

  libX11
  libXext
  libXi
  libXrender
  libXtst
  libXrandr
  libXinerama
  libXcursor
  libXdamage
  libXfixes
  libXcomposite
  libxkbfile
  libxcb
  libxkbcommon
  libgbm
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
