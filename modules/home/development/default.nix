{
  configs,
  pkgs,
  vars,
  inputs,
  ...
}: let
  marketplace-extensions = with pkgs.vscode-marketplace; [
    github.copilot
  ];
in {
  packages = with pkgs; [
    unstable.nixd
    alejandra
    gnome.seahorse
    direnv
  ];
  # vs-code-server fixes
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "1mrc6a1qjixaqkv1zqphgnjjcz9jpsdfs1vq45l1pszs9lbiqfvd";
      }
    }/modules/vscode-server/home.nix"
  ];
  services.vscode-server.enable = true;
  programs.password-store = {enable = true;};

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        tyriar.sort-lines
        redhat.vscode-yaml
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
      "window.titleBarStyle" = "custom";
    };
  };

  programs.git = {
    enable = true;
    userName = "SelfhostedPro";
    userEmail = "info@selfhosted.pro";
  };
}
