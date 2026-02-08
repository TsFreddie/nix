{ lib, var, ... }:

{
  # zsh
  programs.zsh.enable = true;
  programs.zsh.autosuggestion.enable = true;

  # zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  home.shellAliases = {
    cd = "z";
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # starship
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$line_break"
      "$directory$all"
      "$line_break"
      "[$character](bold green)"
    ];
    scan_timeout = 100;
    character = {
      success_symbol = " >";
      error_symbol = "[!>](red)";
    };
    nix_shell = {
      format = "via [$symbol$name$state]($style) ";
      impure_msg = "";
      pure_msg = " (pure)";
    };
  };

  # custom utilities path
  home.sessionPath = [
    "$HOME/utils"
  ];

  # alacritty settings
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Sarasa Term SC";
          style = "Regular";
        };
      };
    };
  };

  # nid
  home.shellAliases = {
    nid = "/home/${var.username}/nix/nid.sh";
  };
}
