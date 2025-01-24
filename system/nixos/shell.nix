{ imports, var, ... }:

let
  pkgs = imports.pkgs;
in
{
  # home
  home-manager.users.${var.username} = {
    # zsh
    programs.zsh.enable = true;

    # zoxide
    programs.zoxide.enable = true;
    programs.zoxide.enableZshIntegration = true;
    programs.zoxide.enableBashIntegration = true;
    home.shellAliases = {
      cd = "z";
    };
  };

  # default shell
  programs.zsh.enable = true;
  users.users.${var.username}.shell = pkgs.zsh;
}
