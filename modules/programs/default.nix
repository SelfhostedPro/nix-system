{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [./firefox.nix ./thorium.nix ./thunar.nix];

  # Utility Packages
  environment.systemPackages = with pkgs; # (import ./global.nix) ++
  
    [
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
      nvd # Check for version differences between running system and build result.

      nano
      python3
      psmisc
      pciutils
      nix-index
      discord # Messaging
      networkmanagerapplet
      spotify
      slack

      gnome.gnome-remote-desktop
      gnome.gnome-keyring
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
      ranger # CLI File Manager

      # Apps
      appimage-run # Runs AppImages on NixOS
      google-chrome # Browser
      kitty # Terminal
      # File Management
      gnome.file-roller # Archive Manager
      okular # PDF Viewer
      pcmanfm # File Browser
      yubioath-flutter
      yubikey-personalization-gui
      # Work Browser
      google-chrome

      # Office Alternative
      wpsoffice
      spice-up
      softmaker-office
      freeoffice
      unstable.marp-cli

      # Conferencing
      zoom-us
      # Testing out browsers
      opera
      microsoft-edge-beta
      brave
      w3m
    ];

  nixpkgs.overlays = [
    # Overlay pulls latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: {
          src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "0yzgkzb0200w9qigigmb84q4icnpm2hj4jg400payz7igxk95kqk";
          };
        }
      );
    })
  ];

  # Default Program Configs
  programs = {
    dconf.enable = true;
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
