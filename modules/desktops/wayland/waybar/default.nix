{
  lib,
  configs,
  pkgs,
  vars,
  ...
}: let
  waybar-with-mp = pkgs.unstable.waybar.override {
    withMediaPlayer = true;
  };
  cava-internal = pkgs.writeShellScriptBin "cava-internal" ''
    cava -p ~/.config/cava/config_internal | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';
in {
  programs.nm-applet.enable = true;
  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [
      waybar-with-mp
      pavucontrol
      playerctl
      cava
    ];
    services = {
      playerctld.enable = true;
    };
    programs = {
      waybar = {
        package = pkgs.unstable.waybar.override {
          withMediaPlayer = true;
        };
        systemd.enable = false;
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
            modules-center = ["hyprland/window"];
            modules-right = [
              "custom/spotify"
              "idle_inhibitor"
              "pulseaudio"
              "network"
              "clock"
              "tray"
              "custom/powermenu"
            ];
            "hyprland/workspaces" = {
              all-outputs = false;
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
            "hyprland/window" = {
              separate-outputs = true;
            };
            "hyprland/submap" = {
              "format" = "{}";
            };
            "custom/spotify" = {
              exec = "${waybar-with-mp}/bin/waybar-mediaplayer.py --player spotify";
              format = "{}  ";
              return-type = "json";
              on-click-middle = "playerctl play-pause";
              on-click = "playerctl previous";
              on-click-right = "playerctl next";
              exec-if = "pgrep spotify";
              interval = 10;
            };
            mpd = {
              max-length = 25;
              format = "<span foreground='#bb9af7'></span> {title}";
              format-paused = " {title}";
              format-stopped = "<span foreground='#bb9af7'></span>";
              format-disconnected = "";
              on-click = "mpc --quiet toggle";
              on-click-right = "mpc update; mpc ls | mpc add";
              on-click-middle = "kitty --class='ncmpcpp' ncmpcpp";
              on-scroll-up = "mpc --quiet prev";
              on-scroll-down = "mpc --quiet next";
              smooth-scrolling-threshold = 5;
              tooltip-format = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
            };
            "custom/cava-internal" = {
              "exec" = "sleep 1s && ${cava-internal}/bin/cava-internal";
              "tooltip" = false;
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
              on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-right-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            };
            "custom/launcher" = {
              format = " ";
              on-click = "${pkgs.killall}/bin/killall rofi || $HOME/.config/rofi/launcher.sh";
              tooltip = false;
            };
            "custom/powermenu" = {
              format = "";
              on-click = "${pkgs.killall}/bin/killall rofi || $HOME/.config/rofi/powermenu.sh";
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
    home.file = {
      ".config/waybar/style.css" = {
        source = ./configs/waybar.css;
        onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
      };
      ".config/cava/config".source = ./configs/cava_config;
      ".config/cava/config_internal".source = ./configs/cava_config_internal;
    };
  };
}
