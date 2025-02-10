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
    stable.bitwarden-desktop
    stable.bitwarden-cli
    gamescope
    mpv
    vial
  ];

  services.udev.packages = with pkgs; [
    vial
  ];
}
