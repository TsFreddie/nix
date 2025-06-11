{
  description = "TsFreddie's NixOS Configuration";
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma Manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # KWin effects forceblur
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rocket powered garment
    jetbra.url = "github:Sanfrag/nix-jetbra";

    # Custom packages
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beans = {
      url = "github:Sanfrag/beans";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    twcn-admin = {
      url = "github:TsFreddie/twcn-admin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      plasma-manager,
      jetbra,
      twcn-admin,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      extra = {
        zen-browser = inputs.zen-browser.packages.${system};
        beans = inputs.beans.packages.${system};
        kwin-effects-forceblur = inputs.kwin-effects-forceblur.packages.${system};
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
                modules =
                  [
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
                        twcn-admin.homeManagerModules.default
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
