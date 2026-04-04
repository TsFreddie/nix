{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_NUM_PARALLEL = "3";
    };
  };
}
