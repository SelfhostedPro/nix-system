{
  description = "NixOS System Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR
    nur = {
      url = "github:nix-community/NUR";
    };
    # VSCode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
    hyprland = {
      # Official Hyprland Flake
      url = "github:hyprwm/Hyprland/fe7b748eb668136dd0558b7c8279bfcd7ab4d759"; # pinned due to build errors
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    nix-vscode-extensions,
    hyprland,
  }: let
    inherit (self) outputs;

    vars = {
      user = {
        name = "none";
      };
      hostname = "undefined-nix-desktop";
      terminal = "kitty";
      editor = "nano";
    };

    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    # Set lib to nixpkgs.lib
    lib = nixpkgs.lib;

    # Generate a list of packages for each system (set default to allowUnfree)
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    # Generate Attrs for all systems
    allSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
  in {
    # Easier access to lib (rather than nixpkgs.lib)
    inherit lib;

    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = allSystems (pkgs: import ./pkgs {inherit pkgs;});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = allSystems (pkgs: pkgs.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs outputs;};

    nixosConfigurations = (
      # Import list of NixOS Configurations from ./hosts
      import ./hosts {
        inherit inputs outputs lib vars; # Inherit inputs
      }
    );
  };
}
