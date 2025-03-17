# Removes nix channel. Use flake exclusively.

{ inputs, ... }:

{
  nix.registry = {
    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    nixpkgs.flake = inputs.nixpkgs;
    # make `nix run stable#nixpkgs` use the stable nixpkgs as the one used by this flake.
    stable.flake = inputs.nixpkgs-stable;
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, use flakes exclusively.

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  environment.etc."nix/inputs/stable".source = "${inputs.nixpkgs-stable}";

  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
    "stable=${inputs.nixpkgs-stable}"
  ];
}
