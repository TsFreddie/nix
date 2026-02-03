{ ... }:

{
  programs.plasma = {
    # enable fcitx5
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

    # theme
    workspace.theme = "breeze-dark";

    # shortcuts
    shortcuts = {
      "services/com.mitchellh.ghostty.desktop"."_launch" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = [ ];
    };
  };
}
