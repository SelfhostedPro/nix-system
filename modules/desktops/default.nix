{
  pkgs,
  config,
  lib,
  vars,
  ...
}: let
  xdg-config = ''
    [preferred]
    # use xdg-desktop-portal-gtk for every portal interface
    default=hyprland,gtk
  '';
in
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
      home-manager.users.${vars.user}.home.file = {
        ".config/xdg-desktop-portal/hyprland-portals.conf".text = xdg-config;
        ".config/resources" = {
          enable = true;
          recursive = true;
          source = ./resources;
        };
      };

      systemd.user.units.xdg-desktop-portal-hyprland.enable = true;
      systemd.user.units.xdg-desktop-portal-gtk.enable = true;
      
      environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox-wayland}/bin/firefox";
      environment.sessionVariables.BROWSER = "firefox";

      environment.systemPackages = with pkgs; [
        inputs.hyprland.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];

      xdg = {
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          #needed to prevent gnome from adding xdg-desktop-portal-gnome
          extraPortals = with pkgs;
            mkForce [
              inputs.hyprland.xdg-desktop-portal-hyprland
              xdg-desktop-portal-gtk
            ];
        };
      };
    };
  }
