{ inputs, lib, pkgs, config, outputs, ... }:
{
  # Feature Imports
  imports = [
    ../features/display/hyprland
    ../features/dev

    ./packages.nix
  ];

  # Non-Free Setup
  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Flake Setup
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  # Restart systemd
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
  manual.manpages.enable = false;
}
