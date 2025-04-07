{
  stdenv,
  nwjs,
  makeDesktopItem,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "uglink";
  src = ./src;
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
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

    install -Dm644 $out/pkgs/icon.png $out/share/icons/hicolor/scalable/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop -t $out/share/applications
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/pkgs

    runHook postInstall
  '';
}
