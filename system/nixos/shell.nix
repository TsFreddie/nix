{ imports, var, ... }:

let
  pkgs = imports.pkgs;
in
{
  # default shell
  programs.zsh.enable = true;
  users.users.${var.username}.shell = pkgs.zsh;
}
