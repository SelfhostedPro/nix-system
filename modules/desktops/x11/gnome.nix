{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}:
with lib; {
  options = {
    gnome = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  imports = [
    ../greetd.nix
  ];

  config = mkIf (config.gnome.enable) {
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    environment.systemPackages = with pkgs; [
      xorg.xinit
    ];
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        gnome.gnome-session
        gnome.gnome-screenshot
      ];

      xsession = {
        enable = true;
        windowManager.command = "gnome-session";
      };
    };
    ## Ensure greetd has a gnome entry
    environment.etc."greetd/environments".text = ''
      Gnome
    '';
  };
}
