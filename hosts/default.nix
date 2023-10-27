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
}
