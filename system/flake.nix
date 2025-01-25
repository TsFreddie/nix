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
      #if you want to use let, use it to cover more cases, this helps with readability. (e.g:
      #let
      #    system = "x86_64-linux";
      #    pkgs = import nixpkgs {
      #      inherit system;
      #      config.allowUnfree = true;              
      #    };
      #    stable = import nixpkgs-stable {
      #      inherit system;
      #      config.allowUnfree = true;
      #    };
      # 
      # instead of in your user configuration. helps immensely when managing multiple systems/users.
      #)

      lib = nixpkgs.lib;
      var = lib.optionalAttrs (builtins.pathExists ./var.nix) (import ./var.nix);
    in
    {
      #did you leave it nixos on purpose? why not use a more fitting system name? (e.g TsFreddie)
      #nixosConfigurations = {
      #  freddie = nixpkgs.lib.nixosSystem {
      #    specialArgs = {
      #      inherit *;
      #    };
      #  }
      nixosConfigurations.nixos =
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
          specialArgs = {
            inherit inputs;
            inherit var;
            inherit pkgs;
            inherit stable;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          inherit specialArgs;

          modules =
            [
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
}
