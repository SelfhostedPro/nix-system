{
  config,
  pkgs,
  vars,
  inputs,
  ...
}: {
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
            command = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --ignore-empty-password --show-failed-attempts --indicator-caps-lock --indicator-radius 100 --indicator-thickness 7  --effect-blur 8x4 --font-size 24";
          }
          {
            event = "lock";
            command = "lock";
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
            command = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --ignore-empty-password --show-failed-attempts --indicator-caps-lock --indicator-radius 100 --indicator-thickness 7  --effect-blur 8x4 --font-size 24";
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
