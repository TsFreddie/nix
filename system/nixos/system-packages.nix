{ pkgs, stable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    vscode
    kdePackages.partitionmanager
    nixd
    nixfmt-rfc-style
    thunderbird
    gamescope
    mpv
    vial

    # dev
    openssl

    # needed to make flatpak font works
    xsettingsd
    xorg.xrdb

    stable.bitwarden-desktop
    stable.bitwarden-cli
    stable.chromium
  ];

  services.udev.packages = with pkgs; [
    vial
  ];
}
