{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    hardware.url = "github:nixos/nixos-hardware";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      inherit lib;
      # nixosModules = import ./modules/nixos;
      homeManagerModules = import ./home-manager/modules;
      # templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # Main desktop
        base = lib.nixosSystem {
          modules = [ ./nixos/configuration.nix ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        # Desktops
        "user" = lib.homeManagerConfiguration {
          modules = [ ./home-manager/home.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@atlas" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/atlas.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@maia" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/maia.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@pleione" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/pleione.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@electra" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/electra.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@alcyone" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/alcyone.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@merope" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/merope.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@celaeno" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/celaeno.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "misterio@generic" = lib.homeManagerConfiguration {
          modules = [ ./home/misterio/generic.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
