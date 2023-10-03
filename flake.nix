{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    emacs-overlay = {
      # Emacs Overlays
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
    nixgl = {
      # Fixes OpenGL With Other Distros.
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-emacs = {
      # Nix-Community Doom Emacs
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
    hyprland = {
      # Official Hyprland Flake
      url = "github:hyprwm/Hyprland"; # Requires "hyprland.nixosModules.default" to be added the host modules
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    plasma-manager = {
      # KDE Plasma User Settings Generator
      url = "github:pjones/plasma-manager"; # Requires "inputs.plasma-manager.homeManagerModules.plasma-manager" to be added to the home-manager.users.${user}.imports
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, nur, nixgl, doom-emacs, hyprland, plasma-manager, ... }:
    let
      vars = {
        # Variables Used In Flake
        user = "user";
        macuser = "stephen";
        location = "$HOME/system";
        terminal = "kitty";
        editor = "nano";
      };
    in
    {
      nixosConfigurations = (
        # NixOS Configurations
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nur doom-emacs hyprland plasma-manager vars; # Inherit inputs
        }
      );

      darwinConfigurations = (
        # Darwin Configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager darwin vars;
        }
      );

      homeConfigurations = (
        # Nix Configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nixgl vars;
        }
      );
    };
}
