{ imports, ... }:

let
  pkgs = imports.pkgs;
in
{
  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.noto
  ];
}
