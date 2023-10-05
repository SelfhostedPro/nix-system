{ config, pkgs, vars, ... }:
{
  imports = [ ./hardware-configuration.nix ./packages.nix ] ++ import (../../modules/graphics);

  hyprland.enable = true; # Window Manager

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 2;
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
