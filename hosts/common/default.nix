{
  inputs,
  outputs,
  pkgs,
  vars,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {inherit inputs outputs;};
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        users.${vars.user} = import ../../modules/home;
      };
    }
    ../../modules/home
    ../../modules/system/nix
  ];
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
  system = {
    # NixOS Settings
    stateVersion = "23.11";
  };
}
