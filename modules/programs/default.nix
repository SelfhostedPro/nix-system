{ config, lib, pkgs, inputs, vars, ... }:
let
  brave = pkgs.brave.override { vulkanSupport = true; };
in
{
  imports = [ ./firefox.nix ];

  # Configure what apps open by default
  xdg.mime.defaultApplications = { };


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
    nix-index

    gnome.gnome-remote-desktop
    gnome.gnome-keyring
    gnome.seahorse
    remmina

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
    xfce.thunar # GUI File Manager

    # Apps
    appimage-run # Runs AppImages on NixOS
    google-chrome # Browser
    kitty # Terminal
    # File Management
    gnome.file-roller # Archive Manager
    okular # PDF Viewer
    pcmanfm # File Browser

    opera
    microsoft-edge-beta
    brave
    w3m
    webcord
  ];


  # Default Program Configs
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };

  home-manager.users.${vars.user} = {
    # Default Applications by filetype.
    xdg = {
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
        };
      };
    };
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
