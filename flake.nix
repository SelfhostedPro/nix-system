{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # hardware.url = "github:nixos/nixos-hardware";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      # pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      #   inherit system;
      #   config.allowUnfree = true;
      # });
    in
    {
      # nixosModules = import ./modules/nixos;
      homeManagerModules = import ./home-manager/modules;
      # templates = import ./templates;

      # overlays = import ./overlays { inherit inputs outputs; };

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations = {
        # Main desktop
        base = nixpkgs.lib.nixosSystem {
          modules = [ ./nixos/configuration.nix ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        # Desktops
        "user" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home-manager/home.nix ];
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
