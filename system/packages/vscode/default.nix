{ vscode, lib }:

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

  # postInstall = ''
  #   wrapProgram $out/bin/code \
  #     --set LD_LIBRARY_PATH "/run/current-system/sw/share/nix-ld/lib"
  # '';

})
