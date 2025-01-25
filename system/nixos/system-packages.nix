{ imports, pkgs, stable, ... }:

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
    bitwarden-desktop
    bitwarden-cli
  ];
}
