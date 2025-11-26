{ pkgs, extra }:

with pkgs;
with extra;
[
  blender
  insomnia
  inkscape
  tetrio-desktop

  vesktop

  godot_4_4-mono

  scrcpy
  yt-dlp

  pixelorama
  ghidra
  audacity

  beans.pbean-dev
  beans.vbean-dev

  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  noto-fonts-color-emoji
  nerd-fonts.fira-code

  nwjs-sdk

  unityhub

  (callPackage ./vscode { })
  (callPackage ./ugreenlink { })
  # (callPackage ./wechat-devtools { })
]
