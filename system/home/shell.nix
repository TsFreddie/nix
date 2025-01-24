{ lib, ... }:

{
  # zsh
  programs.zsh.enable = true;
  programs.zsh.autosuggestion.enable = true;

  # zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.enableBashIntegration = true;
  home.shellAliases = {
    cd = "z";
  };

  # starship
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$line_break"
      "[┌─](bold green)$directory$rust$package"
      "$line_break"
      "[└$character ](bold green)"
    ];
    scan_timeout = 10;
    character = {
      success_symbol = "->";
      error_symbol = "->";
    };
  };
}
