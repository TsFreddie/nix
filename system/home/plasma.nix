{ ... }:

{
  # enable fcitx5
  programs.plasma = {
    enable = true;

    configFile = {
      "kwinrc"."Wayland"."InputMethod" = {
        value = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        shellExpand = true;
      };
    };

    # colemak
    input.keyboard.layouts = [
      {
        layout = "us";
        variant = "colemak";
      }
    ];
  };
}
