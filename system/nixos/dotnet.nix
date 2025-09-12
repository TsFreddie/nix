{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnet-sdk_9
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
  };
}
