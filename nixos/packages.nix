{ pkgs, ... }:
{
  programs.zsh.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    nano
    wget
    kitty
    firefox-wayland
    #hyprpaper
    #hyprland-protocols
    #hyprpicker
    wl-clipboard
    wlr-randr
    #xdg-utils
    #xdg-desktop-portal
    wofi
    psmisc
    nixpkgs-fmt
    home-manager
    #hyprland-share-picker
    #xdg-desktop-portal-hyprland
    #nomachine-client
    sunshine
    qt6.qtwayland
    qt5.qtwayland
    pciutils
    dunst
    libnotify
    wireplumber
    waypipe
    wayvnc
    libsForQt5.krdc
    remmina
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];
}
