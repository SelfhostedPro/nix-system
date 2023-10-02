{ config, pkgs, ... }:

## Used for setting up all development related configuration.
{
  # Package Installation
  imports = [
    "${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; 
      sha256="0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829";}
      }/modules/vscode-server/home.nix"
  ];
  home.packages = [
    pkgs.vscode
  ];

  # Programs and Settings
  programs.vscode.enable = true;
  programs.git = {
      enable = true;
      userName = "SelfhostedPro";
      userEmail = "info@selfhosted.pro";
  };

  # VSCode Server
  services.vscode-server.enable = true;
}
