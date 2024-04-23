{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: let
  core-utils = with pkgs; [
    btop # Better top
    coreutils # GNU Utilities
    git # Version Control
    killall # Kill processes by name
    nano # Editor
    wget # Downloader
    tldr # Simplified Man Pages
    python3 # Programming Language
  ];
  hardware-utils = with pkgs; [
    pciutils # Manage PCI Devices
    usbutils # Manage USB Devices
    psmisc # Process Utilities
    libcamera # Camera Utilities
  ];
  nix-utils = with pkgs; [
    nvd # Check for version differences between running system and build result.
    nix-tree
    nix-index
  ];
  file-management = with pkgs; [
    fd # Find files
    fzf # Fuzzy Finder
    ripgrep # Search files
    tree # Display directory tree
    ncdu # Disk Usage
    exa # ls replacement
    mc # Midnight Commander
    ranger # File Manager
    shared-mime-info # File Types
    nnn # File Manager
    # Archives
    p7zip # Zip Encryption
    unzip # Zip Files
    unrar # Rar Files
    zip # Zip
  ];
  audio = with pkgs; [
    alsa-utils # Audio Control
    pavucontrol # Audio Control
    pipewire # Audio Server/Control
    pulseaudio # Audio Server/Control
    wireplumber # Audio Server
  ];
  communication = with pkgs; [
    slack
    zoom-us
  ];
  entertainment = with pkgs; [
    spotify
  ];
  browsing = with pkgs; [
    firefox-wayland
    google-chrome
  ];
  utilities = with pkgs; [
    zsh
    remmina
    kitty
    yubioath-flutter
    yubikey-personalization-gui
    pcmanfm # File Browser
    okular # PDF Viewer
  ];
in {
  environment.systemPackages = [
    core-utils
    hardware-utils
    nix-utils
    file-management
    audio
    communication
    entertainment
    browsing
    utilities
  ];

  users.users.${vars.user}.shell = pkgs.zsh;

  # Default Program Configs
  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

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
}
