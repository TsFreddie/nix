{ pkgs, extra }:

with pkgs;
with extra;
[
  git
  vim
  wget
  nixd
  nixfmt-rfc-style
  thunderbird
  gamescope
  mpv
  vial

  btop-cuda

  xsettingsd
  xorg.xrdb

  kdePackages.partitionmanager
  kdePackages.kdenlive
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

  ghostty
  gearlever

  p7zip
  unrar
  unzip
  zip

  bitwarden-desktop
  bitwarden-cli
  chromium
  libreoffice-qt6

  qt5.qttools
  qpwgraph

  okteta

  icu
  wl-clipboard

  zen-browser.default

  dotnet-sdk_9
  protontricks

  ripgrep
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

  lsfg-vk
  lsfg-vk-ui

  # asio
  wineasio
]
