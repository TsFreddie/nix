{
  description = "TsFreddie's NixOS Configuration";
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma Manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      var = lib.optionalAttrs (builtins.pathExists ./var.nix) (import ./var.nix);
      specialArgs = {
        inherit inputs;
        inherit var;
        inherit pkgs;
        inherit stable;
      };
    in
    {
      nixosConfigurations = {
        ${var.hostname} = lib.nixosSystem {
          inherit specialArgs;

          modules =
            [
              {
                imports = [ nixpkgs.nixosModules.readOnlyPkgs ];
                nixpkgs.pkgs = pkgs;
              }

              ./configuration.nix
              ./nixos

              # make home-manager as a module of nixos
              # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.backupFileExtension = "fbkp";
                home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

                home-manager.users.${var.username} = import ./home;
              }
            ]
            # use custom.nix module if exists
            ++ lib.optionals (builtins.pathExists ./custom.nix) [
              ./custom.nix
            ]
            # use nixos-hardware config if defined in var.nix
            ++ lib.optionals (builtins.hasAttr "nixos-hardware" var) [
              nixos-hardware.nixosModules.${var.nixos-hardware}
            ]
            # use no-nix-channel if defined in var.nix
            ++ lib.optionals (builtins.hasAttr "no-nix-channel" var && var.no-nix-channel) [
              ./var/no-nix-channel.nix
            ];
        };
      };
    };
}
