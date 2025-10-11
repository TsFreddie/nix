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

  jetbrains.rider

  scrcpy
  yt-dlp

  pixelorama
  ghidra
  audacity

  beans.pbean-dev
  beans.vbean-dev

  nwjs-sdk
  vscode
  (callPackage ./ugreenlink { })
  (callPackage ./auggie { })
  (callPackage ./wechat-devtools { })
]
