{
  configs,
  pkgs,
  vars,
  ...
}: {
  home-manager.users.${vars.user} = {pkgs, ...}: {
    home.packages = with pkgs; [
      unstable.nixd
      # Formatters
      # nixpkgs-fmt
      alejandra
      deploy-rs
    ];
    # vs-code-server fixes
    imports = [
      "${
        fetchTarball {
          url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
          sha256 = "0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829";
        }
      }/modules/vscode-server/home.nix"
    ];
    services.vscode-server.enable = true;
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        hashicorp.terraform
        jnoortheen.nix-ide
        tyriar.sort-lines
        marp-team.marp-vscode
        # kamadorueda.alejandra
      ];
      userSettings = {
        "editor.fontFamily" = "SauceCodePro Nerd Font Mono";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {"command" = "${pkgs.alejandra}/bin/alejandra";};
            "options" = {"enable" = true;};
          };
        };
      };
    };

    programs.git = {
      enable = true;
      userName = "SelfhostedPro";
      userEmail = "info@selfhosted.pro";
    };
  };
}
