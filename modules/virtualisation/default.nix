{
  config,
  pkgs,
  vars,
  ...
}: {
  users.users.${vars.user}.extraGroups = ["docker"];

  virtualisation = {
    docker = {
      enable = true;
    };
  };
}
