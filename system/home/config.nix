{ config, var, ... }:

with config.lib.file;

let
  cfg = "${var.pwd}/config";
  mkLink = mkOutOfStoreSymlink;
in
{
  home.file = {
    # clean up login features for insomnia by using a plugin
    ".config/Insomnia/plugins/insomnia-plugin-hide-login" = {
      source = mkLink "${cfg}/insomnia-plugin-hide-login";
    };

    # ghostty config
    ".config/ghostty" = {
      source = mkLink "${cfg}/ghostty";
    };
  };
}
