#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#
{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  vars,
  ...
}:
with lib; {
  imports = [
    ./config.nix
    ../waybar
    ../rofi
    ../swaylock
  ];

  config = mkIf (builtins.elem "hyprland" config.desktop.environments) {
    desktop.wayland = true;

    # Cache
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs = {
      hyprland = {
        enable = true;
        package = (inputs.hyprland.packages.${pkgs.system}.hyprland.override {
          enableXWayland = true;
          enableNvidiaPatches = true;
        });
      };
    };
    environment = {
      systemPackages = with pkgs; [
        neatvnc
        kitty
        qt5.qtwayland
        qt6.qtwayland
        wlr-randr # Monitor Settings
      ];
    };
    home-manager.users.${vars.user} = {
      pkgs,
      inputs,
      ...
    }: {
      home.packages = with pkgs; [
        unstable.grimblast
        # grim # Grab Images
        # slurp # Region Selector
        hyprland-share-picker
        wayland-protocols
        libinput
        libnotify
        swappy # Snapshot Editor
        libnotify
        fnott
        dunst
        swww
        wl-clipboard

        # Remote Desktops https://github.com/bbusse/swayvnc/blob/main/Containerfile
        wayvnc
        neatvnc
        unstable.rustdesk
        unstable.rustdesk-server
      ];
      services = {
        fnott.enable = true;
      };
    };
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=no
    ''; # Clamshell Mode
  };
}
