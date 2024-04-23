{
  inputs,
  outputs,
  config,
  vars,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ../../modules/programs
      ../../modules/services
      ../../modules/gaming
      ../../modules/desktops
      ../../modules/security
      ./nix.nix
    ]
    ++ (
      import ../../modules/dev
      ++ import ../../modules/shell
    );

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  users.users.${vars.user} = {
    # System User
    isNormalUser = true;
    extraGroups = ["wheel" "video" "input" "audio" "camera" "networkmanager" "lp" "kvm" "libvirtd" "docker"];
  };
  users.groups.input.gid = 174;

  time.timeZone = "America/Los_Angeles"; # Time zone and Internationalisation

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

  boot.plymouth.enable = true;

  environment = {
    variables = {
      # Environment Variables
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${vars.user} = {
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
  };

  system = {
    # NixOS Settings
    #autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  channel = "https://nixos.org/channels/nixos-unstable";
    #};
    stateVersion = "23.05";
  };
}
