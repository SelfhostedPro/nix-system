#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  darwin,
  outputs,
  lib,
  vars,
  ...
}: let
  system = "aarch64-darwin"; # System Architecture
in {
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {inherit inputs outputs vars;};
    modules = [
      # Modules Used
      ./macbook.nix
      home-manager.darwinModules.home-manager
      {
        # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
