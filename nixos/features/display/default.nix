{ config, pkgs, ... }:
{
  imports = [
    ./drivers
    ./wm/hyprland
  ];
}
