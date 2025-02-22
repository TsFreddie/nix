{ config, ... }:

with config.lib.file;

{
  home.file = {
    # clean up login features for insomnia by using a plugin
    ".config/Insomnia/plugins/insomnia-plugin-hide-login".source = mkOutOfStoreSymlink ./files/insomnia-plugin-hide-login;

    # ghostty config
    ".config/ghostty/config".source = mkOutOfStoreSymlink ./files/ghostty/config;
  };
}
