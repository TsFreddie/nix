{
  description = "TsFreddie's NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma Manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    waterfall = {
      url = "github:Sanfrag/waterfall";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom packages
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    beans = {
      url = "github:Sanfrag/beans";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chinese-fonts-overlay.url = "github:brsvh/chinese-fonts-overlay";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      plasma-manager,
      waterfall,
      aagl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      extra = {
        zen-browser = inputs.zen-browser.packages.${system};
        beans = inputs.beans.packages.${system};
      };
      lib = nixpkgs.lib;
      generated = import ./generated.nix;
      var = import ./var.nix // generated;
      specialArgs = {
        inherit var;
        inherit inputs;
        inherit extra;
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
                modules = [
                  (
                    { ... }:
                    {
                      nixpkgs = {
                        config.allowUnfree = true;
                        overlays = [
                          inputs.chinese-fonts-overlay.overlays.default
                        ];
                      };
                    }
                  )
                  ./configuration.nix
                  ./nixos
                  ./var/no-nix-channel.nix

                  waterfall.nixosModules.waterfall

                  {
                    imports = [ aagl.nixosModules.default ];
                    nix.settings = aagl.nixConfig; # Set up Cachix
                    programs.sleepy-launcher.enable = true;
                  }

                  # make home-manager as a module of nixos
                  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.backupFileExtension = "fbkp";
                    home-manager.sharedModules = [
                      plasma-manager.homeModules.plasma-manager
                    ];

                    home-manager.users.${var.username} = {
                      imports = [
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
