{
  pkgs,
  inputs,
  ...
}: {
  imports = [../common ./hardware-configuration.nix ../../modules/virtualisation ../../modules/work] ++ import ../../modules/graphics;

  desktop.environments = [
    "hyprland"
    "gnome"
    # "gamescope" WiP, doesn't boot into DE
    # "plasma" Disabled for testing.
  ];

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
    kernelPackages = pkgs.linuxPackages_6_5;
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];
  environment.systemPackages = with pkgs; [
    blueman
    bluez
    xboxdrv
    linuxKernel.packages.linux_6_5.xone
    zenstates
  ];

  services = {
    blueman.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
  };

  networking = {
    hostName = "nix-desktop";
    networkmanager.enable = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/43fd432d-2a9d-46a5-8367-52684163e64f";
    fsType = "ext4";
  };
}
