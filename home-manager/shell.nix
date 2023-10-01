{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/system/#OS";
      hupdate = "home-manager switch --flake ~/system/#user";
      waybarr = "systemctl restart --user waybar";
    };
  };
}
