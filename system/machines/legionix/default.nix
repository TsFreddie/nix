# Lenovo Legion R9000K 2021
# This is nvidia config. Not a hybrid config.

{ pkgs, config, ... }:

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

      # free performance?
      "mitigations=off"
    ];
  };

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libglvnd
      nvidia-vaapi-driver
    ];
  };
  hardware.amdgpu.initrd.enable = false;
  services.tlp.enable = !config.services.power-profiles-daemon.enable;
  services.fstrim.enable = true;

  # Use beta driver
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    firmware = with pkgs; [
      linux-firmware
    ];
  };

  hardware.nvidia-container-toolkit.enable = true;

  services.ollama = {
    acceleration = "cuda";
  };

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    lenovo-legion-module
  ];
}
