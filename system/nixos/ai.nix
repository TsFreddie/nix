{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  # Enable waterfall
  services.waterfall.enable = true;
}
