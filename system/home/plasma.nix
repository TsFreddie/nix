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
}
