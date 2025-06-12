{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    export name=$NID_NAME
    export SHELL=$NID_SHELL
  '';
  packages = with pkgs; [
    # Add packages here
  ];
}
