{ inputs, lib, pkgs, config, outputs, ... }:
{
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };
  systemd.user.startServices = "sd-switch";
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "23.05";
  };
}
