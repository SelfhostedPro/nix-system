{
  inputs,
  outputs,
  lib,
  vars,
  ...
}: let
  defaultImports = [
    ../../modules/system/defaults
  ];
in {
  base = lib.nixosSystem {
    specialArgs = {inherit inputs outputs vars;};
    modules =
      defaultImports
      ++ [
        ./desktop
      ];
  };
}
