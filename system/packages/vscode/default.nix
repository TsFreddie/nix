{ vscode, lib, stdenv }:

let
  originalPackage = vscode;
in
originalPackage.overrideAttrs (old: {
  name = "vscode-ld";
  version = old.version;
  __intentionallyOverridingVersion = true;
  buildCommand = ''
    set -euo pipefail

    ${lib.concatStringsSep "\n" (
      map (outputName: ''
        echo "Copying output ${outputName}"
        set -x
        cp -rs --no-preserve=mode "${originalPackage.${outputName}}" "''$${outputName}"
        set +x
      '') (old.outputs or [ "out" ])
    )}
  '';

  postInstall = ''
    wrapProgram $out/bin/code \
      --set NIX_LD "${lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker"}"
  '';

})
