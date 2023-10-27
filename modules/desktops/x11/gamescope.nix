{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  home,
  ...
}: let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
        mangohud
      ];
  };
  steam-session = pkgs.writeTextDir "share/wayland-sessions/steam-sesson.desktop" ''
    [Desktop Entry]
    Name=Gamescope Session
    Exec=${pkgs.gamescope}/bin/gamescope -e -d -- steam -gamepadui
    Type=Application
  '';
in
  with lib; {
    imports = [
      ../greetd.nix
    ];
    config = mkIf (builtins.elem "gamescope" config.desktop.environments) {
      # home.home.packages = with pkgs; [
      #   steam-with-pkgs
      #   steam-session
      #   gamescope
      #   mangohud
      #   protontrickse
      # ];
      home-manager.users.${vars.user} = {
        home.packages = with pkgs; [
          steam-with-pkgs
          steam-session
          gamescope
          mangohud
          protontricks
        ];
      };
    };
  }
