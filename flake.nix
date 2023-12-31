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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      # inputs.flake-compat.follows = "flake-compat";
      # inputs.flake-utils.follows = "flake-utils";
      # inputs.nixpkgs.follows = "nixpkgs";
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
    sops-nix.url = "github:Mic92/sops-nix";
    plasma-manager = {
      # KDE Plasma User Settings Generator
      url = "github:pjones/plasma-manager"; # Requires "inputs.plasma-manager.homeManagerModules.plasma-manager" to be added to the home-manager.users.${user}.imports
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    darwin,
    nur,
    nixgl,
    doom-emacs,
    hyprland,
    plasma-manager,
    nix-vscode-extensions,
    ...
  }: let
    inherit (self) outputs;
    vars = {
      # Variables Used In Flake
      user = "user";
      hostname = "nix-desktop";
      macuser = "stephen";
      location = "$HOME/system";
      terminal = "kitty";
      editor = "nano";
    };
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib;
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs outputs;};

    nixosConfigurations = (
      # Import list of NixOS Configurations from ./hosts
      import ./hosts {
        inherit inputs outputs lib vars; # Inherit inputs
      }
    );

    darwinConfigurations = (
      # Darwin Configurations
      import ./darwin {
        inherit inputs nixpkgs nixpkgs-unstable home-manager darwin outputs lib vars;
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
