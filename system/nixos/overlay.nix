{ lib, pkgs, ... }:
{
  nixpkgs.overlays =
    lib.lists.forEach
      (lib.fileset.toList (
        lib.fileset.fileFilter (file: file.hasExt "nix" && file.type == "regular") ../overlays/nixpkgs
      ))
      (
        file:
        import file {
          inherit pkgs;
        }
      );
}
