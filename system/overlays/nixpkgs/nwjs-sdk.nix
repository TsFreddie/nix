{ pkgs }:

final: prev: {
  nwjs-sdk = prev.nwjs-sdk.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Install nwjs-ffmpeg-prebuilt from nixpkgs
      cp -f ${pkgs.nwjs-ffmpeg-prebuilt}/lib/libffmpeg.so $out/share/nwjs/lib/libffmpeg.so
    '';
  });
}
