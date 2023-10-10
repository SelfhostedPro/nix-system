{config, pkgs, vars}: {
  users.users.${vars.users}.extraGroups = ["docker"];

  virtualization = {
    docker = {
      enable = true;
    };
  };
}