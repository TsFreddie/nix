{ var, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3 --nogcroots";
    flake = "${var.pwd}/system";
  };
}
