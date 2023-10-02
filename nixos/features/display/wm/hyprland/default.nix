{ config, pkgs, ... }:
{
  imports = [ ./packages.nix ];
  programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
    };
    waybar = {
      enable = true;
    };
    thunar = {
      enable = true;
    };
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd Hyprland
      '';
    };
  };
  ### Ensure greetd has a hyprland entry
  environment.etc."greetd/environments".text = ''
    hyprland
  '';

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
