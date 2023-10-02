{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #hyprpaper
    #hyprland-protocols
    #hyprpicker
    wl-clipboard
    wlr-randr
    #xdg-utils
    #xdg-desktop-portal
    wofi
    hyprland-share-picker
    qt6.qtwayland
    qt5.qtwayland
    dunst
    libnotify
    waypipe
    wayvnc
    libsForQt5.krdc
    remmina
  ];
}
