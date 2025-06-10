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

    # fonts
    fonts =
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

    # shortcuts
    shortcuts = {
      "services/com.mitchellh.ghostty.desktop"."_launch" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = [ ];
    };
  };

  # konsole
  programs.konsole = {
    enable = true;
    profiles = {
      nix = {
        font.name = "FiraCode Nerd Font Mono";
        font.size = 12;
      };
    };
    defaultProfile = "nix";
  };
}
