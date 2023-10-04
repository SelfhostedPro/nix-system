{ config, pkgs, vars, ... }:
{
  imports = [ ./hardware-configuration.nix ./packages.nix ];

  hyprland.enable = true; # Window Manager
  services.xserver.videoDrivers = [ "nvidia" ];
  services.dbus.enable = true;


  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
    kernelParams = [ "nvidia-drm.modeset=1" ];
    blacklistedKernelModules = [ "nouveau" ];
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
  };
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # networking.hostName = "nix-desktop"; # Define your hostname.

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/43fd432d-2a9d-46a5-8367-52684163e64f";
      fsType = "ext4";
    };
}
