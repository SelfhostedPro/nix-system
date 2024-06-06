{ inputs
, pkgs
, vars
, ...
}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    mqttx
    kubectl
  ];
  home-manager.users.${vars.user} =
    { pkgs, ... }: {
      home.packages = with pkgs; [
        direnv
        bun
        nodePackages.pnpm
      ];
      programs.git = {
        enable = true;
        userName = "SelfhostedPro";
        userEmail = "info@selfhosted.pro";
      };
      programs.password-store.enable = true;
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        extensions = with pkgs.vscode-extensions;
          [
            tyriar.sort-lines
            redhat.vscode-yaml
            hashicorp.terraform
            ms-kubernetes-tools.vscode-kubernetes-tools
          ];
        userSettings = {
          "editor.fontFamily" = "SauceCodePro Nerd Font Mono";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = { "command" = "${pkgs.alejandra}/bin/alejandra"; };
              "options" = { "enable" = true; };
            };
          };
          "godot_tools.gdscript_lsp_server_port" = 6008;
          "markdown.marp.enableHtml" = true;
          "window.titleBarStyle" = "custom";
        };
      };
    };
}
