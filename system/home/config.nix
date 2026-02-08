{
  config,
  var,
  lib,
  ...
}:

with config.lib.file;

let
  cfg = "/home/${var.username}/nix/config";
  mkLink = mkOutOfStoreSymlink;
in
{
  home.file = {
    # clean up login features for insomnia by using a plugin
    ".config/Insomnia/plugins/insomnia-plugin-hide-login" = {
      source = mkLink "${cfg}/insomnia-plugin-hide-login";
    };

    # allow unfree
    ".config/nixpkgs/config.nix" = {
      text = lib.generators.toPretty { } {
        allowUnfree = true;
      };
    };
  };
}
