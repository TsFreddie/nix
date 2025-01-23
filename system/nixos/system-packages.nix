{ imports, ... }:

let
  pkgs = imports.pkgs;
  stable = imports.stable;
in
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
