{
  vars,
  pkgs,
  inputs,
  outputs,
  ...
}: {

  imports = [
    ./defaults
  ];

  systemd.user.startServices = "sd-switch";
  home = {
    stateVersion = "23.05";
    username = "${vars.user}";
  };
  programs = {
    home-manager.enable = true;
  };
}
