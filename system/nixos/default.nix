{
  lib,
  pkgs,
  var,
  extra,
  ...
}:

{
  imports = lib.fileset.toList (
    lib.fileset.fileFilter (
      file: file.name != "default.nix" && file.hasExt "nix" && file.type == "regular"
    ) ./.
  );

  # Substituters
  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store?priority=1"
    "https://nix-community.cachix.org?priority=40"
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # Enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Enable Docker
  virtualisation.docker.enable = true;
  users.users.${var.username}.extraGroups = [ "docker" ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Install steam.
  programs.steam = {
    enable = true;
  };

  # Enable gpg
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
      ];
    };
  };

  # Enable input remapper
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };

  # Enable opengl
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Gamemode
  programs.gamemode.enable = true;

  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = true;

  # Linux kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "ntsync" ];

  # Packages
  environment.systemPackages = (
    import ../packages/system.nix {
      inherit pkgs;
      inherit extra;
    }
  );

  services.udev.packages = (
    import ../packages/udev.nix {
      inherit pkgs;
      inherit extra;
    }
  );
}
