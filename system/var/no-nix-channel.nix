# Removes nix channel. Use flake exclusively.

{ inputs, ... }:

{
  nix.registry = {
    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    nixpkgs.flake = inputs.nixpkgs;
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, use flakes exclusively.

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
  ];
}
