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

  # konsole
  programs.konsole.enable = true;
  programs.konsole.profiles = {
    tsfreddie = {
      font.name = "Fira Code";
    };
  };
}
