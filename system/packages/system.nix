{ pkgs, extra }:

with pkgs;
with extra;
[
  git
  vim
  wget
  nixd
  nixfmt
  gamescope
  mpv
  vial

  btop-cuda

  xsettingsd
  xrdb

  kdePackages.partitionmanager
  kdePackages.filelight
  kdePackages.kfind
  kdePackages.kcolorchooser
  kdePackages.ksystemlog
  kdePackages.krdc
  kdePackages.krfb
  kdePackages.kgpg
  kdePackages.kompare
  kdePackages.k3b
  kdePackages.skanlite
  kdePackages.kruler
  kdePackages.kleopatra
  kdePackages.ktorrent
  kdePackages.lokalize
  kdePackages.kclock
  kdePackages.kontact
  kdePackages.merkuro
  kdePackages.kdepim-addons
  kdePackages.plasma-browser-integration

  qalculate-qt

  kitty
  kitty-img
  gearlever

  p7zip
  unrar
  unzip
  zip

  enpass
  chromium

  qt5.qttools
  qpwgraph

  okteta

  icu

  protontricks

  ripgrep
  fd
  rsync

  # fix some GTK issues
  adwaita-icon-theme
  adwaita-icon-theme-legacy

  # games
  umu-launcher
  protonplus

  # scripting
  python3
  uv
  nodejs
  bun
  rustup

  gh

  android-tools
  (bottles.override {
    removeWarningPopup = true;
  })

  onlyoffice-desktopeditors

  # wayland tools
  wl-clipboard-rs
  (callPackage ./kwtype { })

  # sandboxing
  bubblewrap
  socat
]
