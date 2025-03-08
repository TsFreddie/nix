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
    btop-rocm

    xsettingsd
    xorg.xrdb

    kdePackages.partitionmanager
    kdePackages.kdenlive
    kdePackages.filelight
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

    qalculate-qt

    ghostty
    gearlever

    stable.bitwarden-desktop
    stable.bitwarden-cli
    stable.chromium
  ];

  services.udev.packages = with pkgs; [
    vial
  ];
}
