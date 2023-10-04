{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [ ../modules/programs  ../modules/services ] ++ (import ../modules/desktops ++
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


  # Home-Manager Config
  home-manager.users.${vars.user} = {
    systemd.user.startServices = "sd-switch";
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
