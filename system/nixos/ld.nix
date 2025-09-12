{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (import ../imports/ld-packages.nix { inherit pkgs; }).ldPackages;
}
