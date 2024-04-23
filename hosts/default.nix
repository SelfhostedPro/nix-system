{
  inputs,
  outputs,
  lib,
  vars,
  ...
}: {
  base = lib.nixosSystem {
    specialArgs = {inherit inputs outputs vars;};
    modules = [
      ./desktop # Base Desktop Configuration
    ];
  };
  live = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs vars;};
      modules = [
        (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        ./desktop
      ];
    };
}
