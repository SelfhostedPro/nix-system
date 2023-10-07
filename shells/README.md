## Nix Shells
Shells for different kinds of work. You can use them after cloning by cding into the directory and running `nix develop` or by running `nix develop github:selfhostedpro/nix-system/?dir=shells/work`.

### Pinning old version of things
Packages installed in the shell will be used over ones installed on the host. Host environments will still be available though.
```nix
{
  outputs = {
    ...
  } @ inputs: (
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        # Example of how to pin a specific version of an application
        oldpkgs = import (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/a054d7450768069084142fe597ed2da367813a4a.tar.gz";
            sha256 = "1wlbz6glkzrl3y7pprw1v4sgkwwzi26qlxqfjzxghdlnny91l3cj";
        }) { inherit system; };
        #... other stuff here
        packages = [
          # Pinning an old version of terraform.
          oldpkgs.terraform_0_8_5
        ];
      in {
        # Reference the old package in the shellhook for an example. terraform -v will output the same thing.
        devShells.default = (
          pkgs.mkShell {
            inherit packages;
            shellHook = ''
              echo Welcome to the devshell
              ${oldpkgs.terraform_0_8_5} -v # will output version 0.8.5.
            '';
          }
        );
      }
    )
  );
  nixConfig.bash-prompt = "\[nix-develop\]$ ";
}
```