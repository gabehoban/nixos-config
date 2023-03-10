{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "zroot/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/var" =
    {
      device = "zroot/var";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "zroot/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/246F-0E36";
      fsType = "vfat";
    };

  fileSystems."/var/keys" =
    {
      device = "/dev/disk/by-uuid/C671-35BA";
      fsType = "vfat";
    };

  fileSystems."/nas/docker" =
    {
      device = "homelab/docker";
      fsType = "zfs";
    };

  fileSystems."/nas/media" =
    {
      device = "homelab/media";
      fsType = "zfs";
    };

  fileSystems."/nas/downloads" =
    {
      device = "homelab/downloads";
      fsType = "zfs";
    };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
