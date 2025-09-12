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
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Enable AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
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

  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = true;

  # Linux kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
