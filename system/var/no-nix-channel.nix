# Removes nix channel. Use flake exclusively.

{ inputs, ... }:

{
  nix.registry = {
    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    nixpkgs.flake = inputs.nixpkgs;
    # allow `nix run stable#nixpkgs` to directly reference stable packages
    stable.flake = inputs.nixpkgs-stable;
    # allow `nix run home-manager` to directly reference home-manager
    home-manager.flake = inputs.home-manager;
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, use flakes exclusively.

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  # Same with stable
  environment.etc."nix/inputs/stable".source = "${inputs.nixpkgs-stable}";

  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
    "stable=${inputs.nixpkgs-stable}"
  ];
}
