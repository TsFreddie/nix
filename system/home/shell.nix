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
      "[](bold green)  $nix_shell$directory$rust$package"
      "$line_break"
      "[$character](bold green)"
    ];
    scan_timeout = 100;
    character = {
      success_symbol = "->";
      error_symbol = "=>";
    };
    nix_shell = {
      impure_msg = "i";
      pure_msg = "p";
    };
  };

  # custom utilities path
  home.sessionPath = [
    "$HOME/utils"
    "${var.pwd}/utils"
  ];
}
