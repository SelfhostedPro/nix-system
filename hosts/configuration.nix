{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = (import ../modules/desktops ++
    import ../modules/dev ++
    import ../modules/shell);

  users.users.${vars.user} = {
    # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "kvm" "libvirtd" ];
  };

  time.timeZone = "America/Los_Angeles"; # Time zone and Internationalisation
  services.automatic-timezoned.enable = true;


  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts.fonts = with pkgs; [
    # Fonts
    nerdfonts
  ];

  environment = {
    variables = {
      # Environment Variables
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
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
      wireplumber

      # Apps
      appimage-run # Runs AppImages on NixOS
      firefox # Browser
      firefox-wayland # Browser
      google-chrome # Browser

      # File Management
      gnome.file-roller # Archive Manager
      okular # PDF Viewer
      pcmanfm # File Browser
      p7zip # Zip Encryption
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip

      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ];
  };

  programs = {
    dconf.enable = true;
  };
  sound.enable = true;

  services = {
    printing = {
      # CUPS
      enable = true;
    };
    mpd = {
      enable = true;
      startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    pipewire = {
      # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      # SSH
      enable = true;
      allowSFTP = true; # SFTP
    };
  };

  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable; # Enable Flakes
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow Proprietary Software.

  system = {
    # NixOS Settings
    #autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  channel = "https://nixos.org/channels/nixos-unstable";
    #};
    stateVersion = "23.05";
  };

  home-manager.users.${vars.user} = {
    systemd.user.startServices = "sd-switch";
    programs.git.enable = true;

    # Home-Manager Settings
    home = {
      stateVersion = "23.05";
      username = "${vars.user}";
      homeDirectory = "/home/${vars.user}";
    };
    programs = {
      home-manager.enable = true;
    };

  };
}
