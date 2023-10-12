{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}: let
  # regreetconf = pkgs.writeText "regreet.conf" ''
  #   exec-once = GTK_THEME=Adwaita:dark ${pkgs.greetd.regreet}/bin/regreet; ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch exit
  #   bind = SUPER, T, exec, kitty
  # '';
in {
  # environment.systemPackages = with pkgs; [
  #   greetd.greetd
  #   greetd.gtkgreet
  #   greetd.regreet
  # ];

  ## New
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland --config ${regreetconf}";
  #     };
  #   };
  # };

  # programs.regreet = {
  #   package = pkgs.greetd.regreet;
  #   enable = true;
  #   settings = {
  #     gtk = {
  #       application_prefer_dark_theme = true;
  #     };
  #   };
  # };

  ## Old
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --user-menu --cmd dbus-run-session Hyprland";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
