{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # for dotnet
    icu

    # for some native lib on javascript projects
    stdenv.cc.cc.lib
  ];
}
