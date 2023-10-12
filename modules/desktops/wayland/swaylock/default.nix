{
  config,
  pkgs,
  vars,
  inputs,
  ...
}: let
  swaylockcmd = pkgs.writeShellScriptBin "swaylockcmd" ''
    ${pkgs.swaylock-effects}/bin/swaylock  \
           --screenshots \
           --clock \
           --indicator \
           --indicator-radius 100 \
           --indicator-thickness 7 \
           --effect-blur 7x5 \
           --effect-vignette 0.5:0.5 \
           --ring-color 3b4252 \
           --key-hl-color 880033 \
           --line-color 00000000 \
           --inside-color 00000088 \
           --separator-color 00000000 \
           --ignore-empty-password \
           --show-failed-attempts \
           --daemonize
          #  --grace 2 \
          #  --fade-in 0.1
  '';
in {
  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [
      swayidle
      swaylock-effects
    ];
    services = {
      swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = "${swaylockcmd}/bin/swaylockcmd";
          }
          {
            event = "lock";
            command = "${swaylockcmd}/bin/swaylockcmd";
          }
        ];
        timeouts = [
          # {
          #   timeout = 10;
          #   command = "if pgrep -x swaylock; then ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off; fi";
          #   resumeCommand = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          # }
          {
            timeout = 300;
            command = "${swaylockcmd}/bin/swaylockcmd";
          }
          # {
          #   timeout = 930;
          #   command = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
          #   resumeCommand = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          # }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
}
