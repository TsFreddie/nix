{ pkgs, var, ... }:

{
  # default shell
  programs.zsh.enable = true;
  users.users.${var.username}.shell = pkgs.zsh;
}
