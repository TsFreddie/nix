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
      kdeglobals.General.fixed = "Sarasa Mono SC,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.font = "Sarasa UI SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.menuFont = "Sarasa UI SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.smallestReadableFont = "Sarasa UI SC,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.toolBarFont = "Sarasa UI SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
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
      "services/Alacritty.desktop".New = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = [ ];
    };
  };
}
