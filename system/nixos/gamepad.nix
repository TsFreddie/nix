{ pkgs, ... }:

{
  programs.opengamepadui = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    inputplumber.enable = true;
  };
}
