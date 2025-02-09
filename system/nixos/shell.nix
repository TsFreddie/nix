{ pkgs, ... }:

{
  # default shell
  programs.zsh.enable = true;
  users.users.tsfreddie.shell = pkgs.zsh;
}
