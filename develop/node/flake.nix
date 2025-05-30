{
  description = "Node development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            shellHook = ''
              export name=$NID_NAME
              export SHELL=$NID_SHELL
            '';
            packages = with pkgs; [
              # Add packages here
              nodejs_22
              pnpm
              yarn
            ];
          };
        }
      );
    };
}
