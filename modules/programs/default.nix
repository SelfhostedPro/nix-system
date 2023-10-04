{ config, lib, pkgs, inputs, vars, ... }:
{
  imports = [ ./firefox.nix ];

  # Utility Packages
  environment.systemPackages = with pkgs; [
    # System-Wide Packages
    # Terminal
    btop # Resource Manager
    coreutils # GNU Utilities
    git # Version Control
    killall # Process Killer
    nano # Text Editor
    pciutils # Manage PCI
    tldr # Helper
    usbutils # Manage USB
    wget # Retriever
    nixpkgs-fmt
    nano
    python3
    psmisc
    pciutils

    # Video/Audio
    alsa-utils # Audio Control
    pavucontrol # Audio Control
    pipewire # Audio Server/Control
    pulseaudio # Audio Server/Control
    wireplumber # Audio Server
    # File Management
    p7zip # Zip Encryption
    unzip # Zip Files
    unrar # Rar Files
    zip # Zip

    # Apps
    appimage-run # Runs AppImages on NixOS
    google-chrome # Browser
    kitty # Terminal
    # File Management
    gnome.file-roller # Archive Manager
    okular # PDF Viewer
    pcmanfm # File Browser

    opera
    microsoft-edge
    w3m
  ];


  # Default Program Configs
  programs = {
    dconf.enable = true;
  };

  home-manager.users.${vars.user} = {
    programs = {
      git.enable = true;
      kitty = {
        enable = true;
        font = {
          name = "SauceCodePro Nerd Font Mono";
        };
      };
    };
  };
}