{ pkgs, extra }:

with pkgs;
with extra;
[
  blender
  insomnia
  inkscape
  tetrio-desktop

  vesktop

  godot_4_5-mono

  scrcpy
  yt-dlp

  pixelorama
  ghidra
  audacity

  beans.pbean-dev
  beans.vbean-dev

  nwjs-sdk
  nwjs-ffmpeg-prebuilt

  unityhub
  ryubing

  pear-desktop

  (callPackage ./vscode { })
  (callPackage ./ugreenlink { })
  # (callPackage ./wechat-devtools { })
]
