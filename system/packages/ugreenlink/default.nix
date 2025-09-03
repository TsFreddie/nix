{
  stdenv,
  nwjs,
  nwjs-ffmpeg-prebuilt,
  makeDesktopItem,
  makeWrapper,
  imagemagick,
  ...
}:

stdenv.mkDerivation rec {
  pname = "uglink";
  src = ./src;
  version = "0.0.1";

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];
  buildInputs = [ nwjs ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "UGREEN Nas Manager";
    genericName = "UGREENLink";
    type = "Application";
    desktopName = "UGREENLink";
    categories = [
      "Video"
      "AudioVideo"
    ];
  };

  phases = [
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p out
    cp -r ${src}/* out
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/pkgs
    cp -r out/* $out/pkgs/
    cp -r ${nwjs-ffmpeg-prebuilt}/lib/* $out/bin/lib

    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick $out/pkgs/icon.png -background none -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done

    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop -t $out/share/applications
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/pkgs

    runHook postInstall
  '';
}
