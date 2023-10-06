{ lib, configs, pkgs, unstable, vars, ... }:
let
  launcher = pkgs.writeShellScript "launcher.sh"
    ''
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
      theme="$HOME/.config/rofi/launcher_theme.rasi"
      ${pkgs.rofi-wayland}/bin/rofi -no-lazy-grab -show drun -modi drun -theme $finaltheme
    '';
in
{
  imports = [ ./rofi ];
  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [
      pavucontrol
    ];
    programs = {
      waybar = {
        package = unstable.waybar;
        systemd.enable = true;
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            modules-left = [
              "custom/launcher"
              "hyprland/workspaces"
              "hyprland/submap"
              "cpu"
              "memory"
              "temperature"
            ];
            modules-center = [ "hyprland/window" ];
            modules-right = [
              "mpd"
              "idle_inhibitor"
              "pulseaudio"
              "network"
              "clock"
              "tray"
            ];
            "hyprland/workspaces" = {
              all-outputs = true;
              format = "{name}: {icon}";
              format-icons = {
                "1" = "";
                "2" = "";
                "3" = "";
                "4" = "";
                "5" = "";
                urgent = "";
                focused = "";
                default = "";
              };
            };
            "hyprland/submap" = {
              "format" = "{}";
            };
            mpd = {
              format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
              format-disconnected = "Disconnected ";
              format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon} Stopped ";
              unknown-tag = "N/A";
              interval = 2;
              consume-icons = {
                on = " ";
              };
              random-icons = {
                off = "<span color=\"#f53c3c\"></span> ";
                on = " ";
              };
              repeat-icons = {
                on = " ";
              };
              single-icons = {
                on = "1 ";
              };
              state-icons = {
                paused = "";
                playing = "";
              };
              tooltip-format = "MPD (connected)";
              tooltip-format-disconnected = "MPD (disconnected)";
            };
            idle_inhibitor = {
              "format" = "{icon}";
              "format-icons" = {
                "activated" = "";
                "deactivated" = "";
              };
            };
            tray = {
              # "icon-size= 21,
              spacing = 10;
            };
            clock = {
              format = "{:%OI:%M %p}";
              timezone = "America/Los_Angeles";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
            };
            cpu = {
              format = "{usage}% ";
              tooltip = false;
            };
            memory = {
              format = "{}% ";
            };
            temperature = {
              # "thermal-zone"= 2,
              # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input",
              critical-threshold = 80;
              ## "format-critical"= "{temperatureC}°C {icon}",
              format = "{temperatureC}°C {icon}";
              format-icons = [
                ""
                ""
                ""
              ];
            };
            network = {
              # "interface= "wlp2*", // (Optional) To force the use of this interface
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };
            pulseaudio = {
              # "scroll-step= 1, // %, can be a float
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            };
            "custom/launcher" = {
              format = " ";
              on-click = "${pkgs.killall}/bin/pkill rofi || $HOME/.config/rofi/launcher.sh";
              tooltip = false;
            };
          };
        };
      };
    };

    # home.file.".config/waybar/config" = {
    #   source = ../configs/waybar.json;
    #   onChange = ''systemctl restart --user waybar'';
    # };
    home.file.".config/waybar/style.css" = {
      source = ../configs/waybar.css;
      onChange = ''systemctl restart --user waybar'';
    };
  };
}

