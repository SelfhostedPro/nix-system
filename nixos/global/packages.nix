{ pkgs, ... }:
{
  programs.zsh.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    nano
    wget
    psmisc
    nixpkgs-fmt
    home-manager
    qt6.qtwayland
    qt5.qtwayland
    pciutils
    wireplumber
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];
}
