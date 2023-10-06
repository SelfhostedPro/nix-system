{ config, pkgs, vars, ... }:
{
  home-manager.users.${vars.user} = { pkgs, unstable, ... }: {
    home.packages = with pkgs; [
      # Rofi
      rofi-wayland
    ];
    programs = {
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = "Arc-Dark";
      };
    };

    home.file.".config/rofi/off.sh".source = ./off.sh;
    home.file.".config/rofi/launcher.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env /run/current-system/sw/bin/bash
        ALPHA="#00000000"
        BG="#3B4253"
        FG="#BF616A"
        SELECT="#343a46"
        ACCENT="#3B4252"
        ${pkgs.coreutils}/bin/cat > $dir/colors.rasi <<- EOF
                /* colors */

                * {
                  al:  $ALPHA;
                  bg:  $BG;
                  se:  $SELECT;
                  fg:  $FG;
                  ac:  $ACCENT;
                }
        EOF
        # finaltheme="$HOME/.config/rofi/launcher_theme.rasi"
        ${pkgs.rofi}/bin/rofi -no-lazy-grab -show drun -modi drun -theme $HOME/.config/rofi/launcher_theme.rasi
      '';
    };

    home.file.".config/rofi/off.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env /run/current-system/sw/bin/bash

      '';
    };

    home.file.".config/rofi/launcher_theme.rasi".source = ./launcher_theme.rasi;
    home.file.".config/rofi/powermenu.sh".source = ./powermenu.sh;
    home.file.".config/rofi/powermenu_theme.rasi".source = ./powermenu_theme.rasi;
  };

}
