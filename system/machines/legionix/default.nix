# Lenovo Legion R9000K 2021
# This is nvidia config. Not a hybrid config.

{ config, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # hostname
  networking.hostName = "legionix";

  # hardware
  boot = {
    kernelParams = [
      # fix nvme drive missing on reboot
      "reboot=cold"

      # pstate
      "amd_pstate=active"
    ];
  };

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = false;
  services.tlp.enable = !config.services.power-profiles-daemon.enable;
  services.fstrim.enable = true;

  # Use beta driver
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  services.ollama = {
    acceleration = "cuda";
  };

  services.tabby = {
    acceleration = "cuda";
  };
}
