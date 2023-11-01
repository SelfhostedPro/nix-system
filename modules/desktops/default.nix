{
  pkgs,
  config,
  lib,
  vars,
  ...
}:
with lib; {
  # Master configuration for desktops. Put all options here or else.
  options = {
    desktop.environments = mkOption {
      description = "List of desktops to enable.";
      default = ["gnome"];
      type = with types; listOf str;
    };
    desktop.wayland = mkOption {
      description = "Weather wayland environments are in use. (this should be set by the desktops that are enabled)";
      default = false;
      type = with types; bool;
    };
  };

  imports = [./greetd.nix] ++ (import ./wayland ++ import ./x11);

  config = {
    home-manager.users.${vars.user}.home.file.".config/resources" = {
      enable = true;
      recursive = true;
      source = ./resources;
    };

    systemd.user.units.xdg-desktop-portal-hyprland.enable = true;
    systemd.user.units.xdg-desktop-portal-gtk.enable = true;

    xdg = {
      portal = {
        enable = true;
        wlr.enable = false;
        #needed to prevent gnome from adding xdg-desktop-portal-gnome
        extraPortals = with pkgs;
          mkForce [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
          ];
      };
    };
  };
}
