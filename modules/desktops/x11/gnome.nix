{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}:
with lib; {
  imports = [
    ../greetd.nix
  ];

  config = mkIf (builtins.elem "gnome" config.desktop.environments) {
    desktop.wayland = true;
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    services.xserver.desktopManager.gnome.enable = true;

    services.gnome.core-os-services.enable = true;
    services.gnome.core-shell.enable = true;
    services.gnome.core-utilities.enable = true;
    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    environment.systemPackages = with pkgs; [
      xorg.xinit
      gnomecast
      gnome.gnome-tweaks
      gnomeExtensions.forge
    ];
  };
}
