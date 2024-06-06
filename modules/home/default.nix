{ inputs
, outputs
, config
, vars
, ...
}: {
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.user = {
      systemd.user.startServices = "sd-switch";
      home = {
        stateVersion = "24.05";
        username = "user";
        homeDirectory = "/home/user";
      };
      programs = {
        home-manager.enable = true;
      };
    };
  };
}
