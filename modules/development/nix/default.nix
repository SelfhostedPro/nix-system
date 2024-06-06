{ configs
, pkgs
, vars
, inputs
, ...
}: {
  home-manager.users.${vars.user} =
    { pkgs, ... }: {
      home.packages = with pkgs; [
        unstable.nixd
        nixpkgs-fmt
        # alejandra
        direnv
      ];
      programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions;[
          # bbenoist.nix
          jnoortheen.nix-ide
        ];
      };
    };

}
