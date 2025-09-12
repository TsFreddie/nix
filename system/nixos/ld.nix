{ pkgs, extra, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (
    import ../packages/ld.nix {
      inherit pkgs;
      inherit extra;
    }
  );
}
