{ var, ... }:

{
  # enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };

  # globally ignore direnv files
  programs.git.ignores = [
    "*~"
    ".niv"
    ".envrc"
  ];

  # niv alias
  home.shellAliases = {
    niv = "${var.pwd}/niv.sh";
  };
}
