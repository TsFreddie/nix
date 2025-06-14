{ ... }:

{
  # enable direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };

  # globally ignore direnv files
  programs.git.ignores = [
    "*~"
    ".nid"
    ".envrc"
    ".direnv"
  ];
}
