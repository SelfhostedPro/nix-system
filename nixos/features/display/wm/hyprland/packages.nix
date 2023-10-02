{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #hyprland-protocols
    swww # Wallpaper
    wl-clipboard # Clipboard
    wlr-randr # xrandr alternative
    #xdg-utils
    #xdg-desktop-portal
    wofi # launcher
    hyprland-share-picker
    qt6.qtwayland
    qt5.qtwayland
    dunst
    libnotify
    waypipe
    wayvnc
    kitty
    firefox-wayland
  ];
}
