# Lenovo Legion R9000K 2021
# This is nvidia config. Not a hybrid config.

{ config, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-legion-16achg6-nvidia
  ];

  # hostname
  networking.hostName = "legionix";

  # Use beta driver
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  boot.kernelParams = [
    # fix nvme drive missing on reboot
    "reboot=pci"
  ];

  # enable cuda
  nixpkgs.config.cudaSupport = true;
  hardware.nvidia-container-toolkit.enable = true;
}
