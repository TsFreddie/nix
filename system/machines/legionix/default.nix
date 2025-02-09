# Lenovo Legion R9000K 2021
# This is nvidia config. Not a hybrid config.

{ config, hardware, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    hardware.lenovo-legion-16achg6-nvidia
  ];

  # hostname
  networking.hostName = "legionix";

  # Use beta driver
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.open = false;
  hardware.nvidia.powerManagement.enable = true;

  boot.kernelParams = [
    # reduce stuttering
    "nvidia.NVreg_EnableGpuFirmware=0"

    # fix nvme drive missing on reboot
    "reboot=pci"
  ];
}
