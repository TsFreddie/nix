{ pkgs }:
{
  ldPackages = with pkgs; [
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
  ];
}
