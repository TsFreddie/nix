{
  lib,
  pkgs,
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
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

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

  # Enable nh
  programs.nh = {
    enable = true;
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

  # Enable input remapper
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };
}
