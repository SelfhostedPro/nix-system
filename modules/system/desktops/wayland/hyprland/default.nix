{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [];

  # Cache
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  ''; # Clamshell Mode
}
