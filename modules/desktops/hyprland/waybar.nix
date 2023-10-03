{ lib, configs, pkgs, vars, ... }:
{
  home-manager.users.${vars.user}.programs = {
    waybar = {
      systemd.enable = true;
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;
          modules-left = [ "hyprland/workspaces" "custom/media" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "clock" "tray" ];
          "hyprland/workspaces" = {
            active-only = true;
            format = "{name}: {icon}";
            format-icons = {
              "2" = "";
              "1" = "";
            };
          };
          # "keyboard-state" = {
          #   numlock = true;
          #   capslock = true;
          #   format = "{name} {icon}";
          #   format-icons = {
          #     locked = "";
          #     unlocked = "";
          #   };
          # };
          mpd = {
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            format-disconnected = "Disconnected ";
            format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
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
          pulseaudio = {
            # // "scroll-step": 1, // %, can be a float
            format = "{icon} {volume}% {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          tray = {
            spacing = 10;
          };
          clock = {
            format = "{:%H:%M %m-%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
        };
      };
    };
  };
}
