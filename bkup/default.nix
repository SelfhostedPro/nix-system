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
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "23.05";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/system/#base";
      hupdate = "home-manager switch --flake ~/system/#user";
      waybarr = "systemctl restart --user waybar";
    };
  };
  manual.manpages.enable = false;
}
