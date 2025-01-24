{ ... }:

{
  # zsh
  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    cd = "z";
  };

  # zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.enableBashIntegration = true;
}
