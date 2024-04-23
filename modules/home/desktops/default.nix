{...}: let
  xdg-config = ''
    [preferred]
    # use xdg-desktop-portal-gtk for every portal interface
    default=hyprland,gtk
  '';
in {
  imports = [./wayland];

  home.file = {
    ".config/xdg-desktop-portal/hyprland-portals.conf".text = xdg-config;
    ".config/resources" = {
      enable = true;
      recursive = true;
      source = ./resources;
    };
  };
}
