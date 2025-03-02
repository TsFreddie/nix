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
          overlays = [
            (final: prev: {
              input-remapper = prev.input-remapper.overrideAttrs (old: rec {
                version = "2.1.1";

                src = pkgs.fetchFromGitHub {
                  owner = "sezanzeb";
                  repo = "input-remapper";
                  rev = "2.1.1";
                  hash = "sha256-rwlVGF/cWSv6Bsvhrs6nMDQ8avYT80aasrhWyQv55/A=";
                };
              });
            })
          ];
        }
        // {
          stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      lib = nixpkgs.lib;
      generated = import ./generated.nix;
      var = import ./var.nix // generated;
      specialArgs = {
        inherit var;
        inherit inputs;
        inherit pkgs;
        hardware = nixos-hardware.nixosModules;
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        builtins.map
          (
            path:
            let
              hostname = builtins.baseNameOf (builtins.dirOf (toString path));
            in
            {
              name = hostname;
              value = lib.nixosSystem {
                inherit specialArgs;
                modules =
                  [
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

                      home-manager.users.${var.username} = {
                        imports =
                          [
                            ./home
                          ]
                          ++ lib.optionals (lib.pathExists ./machines/${hostname}/home.nix) [
                            ./machines/${hostname}/home.nix
                          ];
                      };
                    }
                  ]
                  ++ [
                    path
                  ];
              };
            }
          )
          (
            lib.fileset.toList (
              lib.fileset.fileFilter (file: file.type == "regular" && file.name == "default.nix") ./machines
            )
          )
      );
    };
}
