{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    vscode
    nixd
    nixfmt-rfc-style
    thunderbird
    gamescope
    mpv
    vial

    # needed to make flatpak font works
    xsettingsd
    xorg.xrdb

    kdePackages.partitionmanager
    kdePackages.kdenlive
    kdePackages.filelight
    kdePackages.kolourpaint
    kdePackages.kfind
    kdePackages.kcolorchooser
    kdePackages.kcolorpicker
    kdePackages.ksystemlog
    kdePackages.krdc
    kdePackages.kgpg
    kdePackages.kompare
    kdePackages.k3b
    kdePackages.skanlite
    kdePackages.kruler
    kdePackages.kleopatra
    kdePackages.ktorrent
    kdePackages.lokalize
    kdePackages.kclock
    kdePackages.kmail
    kdePackages.kontact
    kdePackages.merkuro

    kdePackages.audiotube

    qalculate-qt

    stable.bitwarden-desktop
    stable.bitwarden-cli
    stable.chromium
  ];

  services.udev.packages = with pkgs; [
    vial
  ];
}
