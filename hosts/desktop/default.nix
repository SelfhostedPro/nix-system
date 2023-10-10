{
  pkgs,
  inputs,
  ...
}: {
  imports = [../common ./hardware-configuration.nix] ++ import ../../modules/graphics;

  hyprland.enable = true; # Window Manager

  # desktop = {
  #   hyprland.enable = true;
  #   nvidia.enable = true;
  # };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  networking = {
    hostName = "nix-desktop";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/43fd432d-2a9d-46a5-8367-52684163e64f";
    fsType = "ext4";
  };
}
