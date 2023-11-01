{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # Master configuration for desktops. Put all options here or else.
  options = {
    security.sandboxing = mkOption {
      description = "List of desktops to enable.";
      default = true;
      type = with types; bool;
    };
  };
  imports = [
    ./firejail.nix
    ./common.nix
  ];
}
