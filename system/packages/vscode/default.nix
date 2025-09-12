{ vscode, lib }:

let
  originalPackage = vscode;
in
originalPackage.overrideAttrs (old: {
  name = "vscode-ld";
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
      --set LD_LIBRARY_PATH "$NIX_LD_LIBRARY_PATH"
  '';

})
