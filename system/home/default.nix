{
  lib,
  pkgs,
  extra,
  var,
  ...
}:

{
  imports = lib.fileset.toList (
    lib.fileset.fileFilter (
      file: file.name != "default.nix" && file.hasExt "nix" && file.type == "regular"
    ) ./.
  );

  home.username = var.username;
  home.homeDirectory = "/home/${var.username}";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # packages
  home.packages =
    with pkgs;
    with extra;
    [
      obs-studio
      blender
      insomnia
      anytype
      inkscape
      tetrio-desktop

      vesktop

      godot_4_4-mono

      jetbrains.rider
      youtube-music

      scrcpy
      yt-dlp

      pixelorama
      ghidra

      beans.pbean-dev
      beans.vbean-dev

      nwjs-sdk
      (callPackage ../packages/ugreenlink { })
    ];
  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "TsFreddie";
    userEmail = "whatis@tsdo.in";
    signing = {
      key = "73AEEBCE3A3F9C766E0BBB183054B1FC80F9AF6F";
      signByDefault = true;
    };
    lfs.enable = true;
    extraConfig = {
      core = {
        autocrlf = "input";
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
