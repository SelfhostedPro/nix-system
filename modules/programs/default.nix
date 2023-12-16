{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [./firefox.nix ./thunar.nix ./rgb.nix ./music.nix];

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
      nix-tree

      nano
      python3
      psmisc
      pciutils
      nix-index # Messaging
      # unstable.vesktop
      # unstable.webcord
      networkmanagerapplet
      spotify
      libcamera

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
      kitty # Terminal
      # File Management
      gnome.file-roller # Archive Manager
      okular # PDF Viewer
      pcmanfm # File Browser
      yubioath-flutter
      yubikey-personalization-gui
      # Work Browser

      unstable.rambox

      # Office Alternative
      wpsoffice
      spice-up
      softmaker-office
      freeoffice
      unstable.marp-cli

      # Conferencing
      zoom-us
      # Testing out browsers
      google-chrome
      thorium

      firefox-wayland
      
      shared-mime-info
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
