{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, doom-emacs, hyprland, plasma-manager, vars, ... }:
let
  system = "x86_64-linux"; # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  base = lib.nixosSystem {
    # Desktop Profile
    inherit system;
    specialArgs = {
      # Pass Flake Variable
      inherit inputs system unstable hyprland vars;
      host = {
        hostName = "nix-desktop";
      };
    };
    modules = [
      # Modules Used
      nur.nixosModules.nur
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
