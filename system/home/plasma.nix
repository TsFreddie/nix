{ ... }:

{
  # enable fcitx5
  programs.plasma.enable = true;
  programs.plasma.configFile = {
    "kwinrc"."Wayland"."InputMethod" = {
      value = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
      shellExpand = true;
    };
  };

  # colemak
  programs.plasma.input.keyboard.layouts = [
    {
      layout = "us";
      variant = "colemak";
    }
  ];

  # theme
  programs.plasma.workspace.theme = "breeze-dark";

  # fonts
  programs.plasma.fonts =
    let
      regular = {
        family = "Noto Sans CJK SC";
        weight = "normal";
        pointSize = 10;
      };
      mono = {
        family = "Noto Sans Mono";
        weight = "normal";
        pointSize = 10;
      };
    in
    {
      general = regular;
      fixedWidth = mono;
      small = {
        inherit (regular) family weight;
        pointSize = 8;
      };
      toolbar = regular;
      menu = regular;
      windowTitle = regular;
    };

  # konsole
  programs.konsole.enable = true;
  programs.konsole.profiles = {
    nix = {
      font.name = "FiraCode Nerd Font Mono";
      font.size = 12;
    };
  };
  programs.konsole.defaultProfile = "nix";
}
