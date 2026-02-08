{ pkgs }:

final: prev: {
  nwjs = prev.nwjs.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Install nwjs-ffmpeg-prebuilt from nixpkgs
      cp -f ${pkgs.nwjs-ffmpeg-prebuilt}/lib/libffmpeg.so $out/share/nwjs/lib/libffmpeg.so
    '';
  });
}
