{ ... }:

{
  # clean up login features for insomnia by using a plugin
  home.file.".config/Insomnia/plugins/insomnia-plugin-hide-login" = {
    source = ./files/insomnia-plugin-hide-login;
    recursive = false;
  };
}
