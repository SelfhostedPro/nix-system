{
  pkgs,
  config,
  lib,
  vars,
  ...
}:
with lib; {
  imports = [./greetd.nix ./wayland/hyprland.nix];

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
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
}
