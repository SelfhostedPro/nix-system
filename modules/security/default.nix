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
      description = "Enable or disable sandboxing.";
      default = true;
      type = with types; bool;
    };
  };
  imports = [
    ./firejail.nix
    ./common.nix
    ./tools.nix
  ];
}
