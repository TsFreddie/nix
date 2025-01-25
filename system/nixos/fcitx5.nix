{ imports, pkgs, ... }:

{
  # install fcitx5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-skk-qt
      fcitx5-gtk
      fcitx5-fluent
    ];
  };
}
