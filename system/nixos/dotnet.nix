{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnet-sdk_10
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
  };
}
