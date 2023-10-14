{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}: {

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    libinput.enable = true;
  };

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = ''
  #         ${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --user-menu --cmd "dbus-run-session Hyprland";
  #       '';
  #       user = "greeter";
  #     };
  #   };
  # };
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };
}
