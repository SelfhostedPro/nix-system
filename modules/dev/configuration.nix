{
  configs,
  pkgs,
  vars,
  inputs,
  ...
}: let
  marketplace-extensions = with pkgs.vscode-marketplace; [
    hediet.vscode-drawio
    vue.volar
    # evilz.vscode-reveal
    # antfu.slidev
    github.copilot
    astro-build.astro-vscode
  ];
in {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];

  home-manager.users.${vars.user} = {pkgs, ...}: {
    home-manager.users.${
      if pkgs.stdenv.isLinux == true
      then vars.user
      else vars.macuser
    } = {pkgs, ...}: {
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
        extensions = with pkgs.vscode-extensions;
          [
            hashicorp.terraform
            jnoortheen.nix-ide
            tyriar.sort-lines
            marp-team.marp-vscode
            redhat.vscode-yaml
            ms-kubernetes-tools.vscode-kubernetes-tools
            marp-team.marp-vscode
            # kamadorueda.alejandra
          ]
          ++ marketplace-extensions;
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
          "godot_tools.gdscript_lsp_server_port" = 6008;
          "markdown.marp.enableHtml" = true;
          "window.titleBarStyle" = "custom";
        };
      };

      programs.git = {
        enable = true;
        userName = "SelfhostedPro";
        userEmail = "info@selfhosted.pro";
      };
    };
  };
}
