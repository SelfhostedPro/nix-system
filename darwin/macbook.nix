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
  ...
}: {
  imports = import ./modules;

  users.users.${vars.macuser} = {
    # MacOS User
    home = "/Users/${vars.macuser}";
    shell = pkgs.zsh; # Default Shell
  };

  networking = {
    computerName = "MacBook"; # Host Name
    hostName = "MacBook";
  };

  skhd.enable = true; # Window Manager
  yabai.enable = true; # Hotkeys

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

  home-manager.users.${vars.macuser} = {
    home = {
      stateVersion = "23.05";
    };

    programs = {
      zsh = {
        # Shell
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        history.size = 10000;
        shellAliases = {
          update = "darwin-rebuild switch --flake ~/system/#macbook";
        };
      };
      nix-index.enable = true;
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          # Syntax
          vim-nix
          vim-markdown

          # Quality of life
          vim-lastplace # Opens document where you left it
          auto-pairs # Print double quotes/brackets/etc.
          vim-gitgutter # See uncommitted changes of file :GitGutterEnable

          # File Tree
          nerdtree # File Manager - set in extraConfig to F6

          # Customization
          wombat256-vim # Color scheme for lightline
          srcery-vim # Color scheme for text

          lightline-vim # Info bar at bottom
          indent-blankline-nvim # Indentation lines
        ];

        extraConfig = ''
          syntax enable                             " Syntax highlighting
          colorscheme srcery                        " Color scheme text

          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }                                     " Color scheme lightline

          highlight Comment cterm=italic gui=italic " Comments become italic
          hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

          set number                                " Set numbers

          nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
        '';
      };
    };
  };
}
