{
  config,
  pkgs,
  vars,
  ...
}: {
  users.users.${vars.user}.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation = {
    docker = {
      enable = true;
    };
  };
}
