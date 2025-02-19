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
    kdePackages.kcalc

    stable.bitwarden-desktop
    stable.bitwarden-cli
    stable.chromium
  ];

  services.udev.packages = with pkgs; [
    vial
  ];
}
