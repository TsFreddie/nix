# Lenovo Legion R9000K 2021
# This is a AMD only config with nvidia GPU setting through passthrough

{
  config,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # hostname
  networking.hostName = "legionix";

  boot = {
    kernelParams = [
      # fix nvme drive missing on reboot
      "reboot=cold"

      # pstate
      "amd_pstate=active"
    ];
  };

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = true;
  services.tlp.enable = !config.services.power-profiles-daemon.enable;
  services.fstrim.enable = true;
}
