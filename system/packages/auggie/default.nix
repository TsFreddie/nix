{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  nodejs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "auggie";
  version = "0.5.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/@augmentcode/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-LeQoNJcMMnAi9eyg8gXdIXweZoJD18ZlsE0BHBarbuY=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname}
    cp -r . $out/share/${pname}
    makeWrapper ${nodejs}/bin/node $out/bin/auggie \
      --add-flags $out/share/${pname}/augment.mjs
    runHook postInstall
  '';

  meta = {
    description = "AI agent that brings the power of Augment's agent and context engine into your terminal";
    homepage = "https://docs.augmentcode.com/cli";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    mainProgram = "auggie";
  };
}
