{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options = {
    plasma = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  imports = [
    ../greetd.nix
  ];

  config = mkIf (config.plasma.enable) {
    environment.systemPackages = with pkgs; [
      xorg.xinit
    ];

    services.xserver.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    services.xserver.desktopManager.plasma5.enable = true;

    ## Ensure greetd has a plasma entry
    environment.etc."greetd/environments".text = ''
      Plasma
    '';
  };
}
