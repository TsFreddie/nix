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
  youtube-music

  scrcpy
  yt-dlp

  pixelorama
  ghidra

  beans.pbean-dev
  beans.vbean-dev

  nwjs-sdk
  vscode
  (callPackage ./ugreenlink { })
]
