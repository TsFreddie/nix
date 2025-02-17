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

    # Rocket powered garment
    jetbra.url = "github:Sanfrag/nix-jetbra/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      home-manager,
      plasma-manager,
      jetbra,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs =
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
        // {
          stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };

      lib = nixpkgs.lib;
      var = import ./generated.nix;
      specialArgs = {
        inherit var;
        inherit inputs;
        inherit pkgs;
        inherit self;
        hardware = nixos-hardware.nixosModules;
      };
      modules = [
        {
          imports = [ nixpkgs.nixosModules.readOnlyPkgs ];
          nixpkgs.pkgs = pkgs;
        }

        ./configuration.nix
        ./nixos
        ./var/no-nix-channel.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "fbkp";
          home-manager.sharedModules = [
            plasma-manager.homeManagerModules.plasma-manager
            jetbra.homeManagerModules.jetbra
          ];

          home-manager.users.tsfreddie = import ./home;
        }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        builtins.map
          (path: {
            name = builtins.baseNameOf (builtins.dirOf (toString path));
            value = lib.nixosSystem {
              inherit specialArgs;
              modules = modules ++ [
                path
              ];
            };
          })
          (
            lib.fileset.toList (
              lib.fileset.fileFilter (file: file.type == "regular" && file.name == "default.nix") ./machines
            )
          )
      );
    };
}
