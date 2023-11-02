#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ macbook.nix *
#       └─ ./modules
#           └─ default.nix
#
{
  config,
  pkgs,
  vars,
  inputs,
  outputs,
  ...
}: {
  imports = import ./modules ++ import ../modules/dev;

  users.users.${vars.macuser} = {
    # MacOS User
    home = "/Users/${vars.macuser}";
    shell = pkgs.zsh; # Default Shell
  };

  networking = {
    computerName = "MacBook"; # Host Name
    hostName = "MacBook";
  };

  skhd.enable = false; # Hotkeys
  yabai.enable = false; # Window Manager

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
    ];
  };

  environment = {
    shells = with pkgs; [zsh]; # Default Shell
    variables = {
      # Environment Variables
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      # System-Wide Packages
      # Terminal
      ansible
      git
      pfetch
      ranger
      nixpkgs-fmt
      alejandra

      # Doom Emacs
      emacs
      fd
      ripgrep
    ];
  };

  programs = {
    zsh.enable = true; # Shell
    zsh.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };

  services = {
    nix-daemon.enable = true; # Auto-Upgrade Daemon
    spacebar.enable = true;
    spacebar.package = pkgs.spacebar;
    spacebar.config = {
      clock_format = "%R";
      background_color = "0xff202020";
      foreground_color = "0xffa8a8a8";
    };
  };

  homebrew = {
    # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "tailscale"
    ];
    casks = [
      "discord"
    ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage Collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    # Global macOS System Settings
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = false;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Set Default Shell
    stateVersion = 4;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${vars.macuser} = {
      home.stateVersion = "23.05";
      programs = {
        zsh = {
          # Shell
          enable = true;
          enableAutosuggestions = true;
          enableSyntaxHighlighting = true;
          history.size = 10000;
          shellAliases = {
            update = "darwin-rebuild build --flake ~/system/#macbook && ${pkgs.nvd}/bin/nvd diff /run/current-system ./result";
            upgrade = "darwin-rebuild switch --flake ~/system/#macbook";
          };
        };
        nix-index.enable = true;
        ssh.enable = true;
        ssh.extraConfig = ''
          UseKeychain yes
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_rsa
        '';
        ssh.matchBlocks."10.0.100.253" = {
          hostname = "10.0.100.253";
          user = "user";
          extraOptions = {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
            IdentityFile = "~/.ssh/id_rsa";
          };
        };
      };
    };
  };
}
