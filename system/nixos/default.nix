{ imports, lib, stable, ... }:

{
  imports = lib.fileset.toList (
    lib.fileset.fileFilter (
      file: file.name != "default.nix" && file.hasExt "nix" && file.type == "regular"
    ) ./.
  );

  # Substituters
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  # Install steam.
  programs.steam = {
    enable = true;
    package = stable.steam;
  };

  # Enable gpg
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
