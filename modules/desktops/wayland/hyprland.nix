#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#
{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  vars,
  ...
}:
with lib; {
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  imports = [
    ../greetd.nix
    ./waybar
    ./rofi
    ./swaylock
  ];

  config = mkIf (config.hyprland.enable) {
    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        nvidiaPatches = true;
      };
    };
    environment = {
      systemPackages = with pkgs; [
        neatvnc
        kitty
        qt5.qtwayland
        qt6.qtwayland
        wlr-randr # Monitor Settings
      ];
    };
    home-manager.users.${vars.user} = {
      pkgs,
      inputs,
      ...
    }: {
      imports = [inputs.hyprland.homeManagerModules.default];
      home.packages = with pkgs; [
        unstable.grimblast
        # grim # Grab Images
        # slurp # Region Selector
        hyprland-share-picker
        wayland-protocols
        libinput
        libnotify
        swappy # Snapshot Editor
        libnotify
        fnott
        dunst
        swww
        wl-clipboard

        # Remote Desktops https://github.com/bbusse/swayvnc/blob/main/Containerfile
        wayvnc
        neatvnc
        unstable.rustdesk
        unstable.rustdesk-server
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor=,preferred,auto,auto
          # Network manager applet
          exec-once = nm-applet --indicator
          exec-once = swww init
          # Execute your favorite apps at launch
          exec-once = swww img ~/.config/nixpapers/dracula.png hyprpaper & firefox & slack


          # Some default env vars.
          env = XCURSOR_SIZE,24
          # XDG Portal Specifications
          env = XDG_CURRENT_DESKTOP,Hyprland
          env = XDG_SESSION_DESKTOP,Hyprland
          env = XDG_SESSION_TYPE,wayland

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
              kb_layout = us
              kb_variant =
              kb_model =
              kb_options =
              kb_rules =
              follow_mouse = 1
              touchpad {
                  natural_scroll = no
              }
              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          }

          general {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more

              gaps_in = 5
              gaps_out = 20
              border_size = 2
              col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
              col.inactive_border = rgba(595959aa)

              layout = dwindle
          }

          decoration {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more

              rounding = 10
              #drop_shadow = yes
              #shadow_range = 4
              #shadow_render_power = 3
              #col.shadow = rgba(1a1a1aee)
          }

          animations {
              enabled = yes

              # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = myBezier, 0.05, 0.9, 0.1, 1.05

              animation = windows, 1, 7, myBezier
              animation = windowsOut, 1, 7, default, popin 80%
              animation = border, 1, 10, default
              animation = borderangle, 1, 8, default
              animation = fade, 1, 7, default
              animation = workspaces, 1, 6, default
          }

          dwindle {
              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = yes # you probably want this
          }

          master {
              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              new_is_master = true
          }

          gestures {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = off
          }

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
          device:epic-mouse-v1 {
              sensitivity = -0.5
          }

          $mod = SUPER
          $altmod = SUPER_SHIFT

          # Launcher Shortcuts
          bind = $mod, T, exec, kitty
          bind = $mod, k, killactive,
          bind = $mod, R, exec, rofi -show drun -show-icons
          bind = $altmod, R, exec, rofi -show run -show-icons
          bind = $mod, V, togglefloating,
          bind = $mod, L, exec, loginctl lock-session $XDG_SESSION_ID
          bind = $altmod, P, exec, grimblast copy area

          # workspaces

          # binds $mod + [shift +] {left, right} to [move] the application one workspace in that direction
          bind = SUPER_SHIFT, left, movewindow, l
          bind = SUPER_SHIFT, right, movewindow, r
          bind = SUPER_SHIFT, up, movewindow, u
          bind = SUPER_SHIFT, down, movewindow, d

          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          ${builtins.concatStringsSep "" (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in ''
                bind = $mod, ${ws}, workspace, ${toString (x + 1)}
                bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
              ''
            )
            10)}

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mod, mouse:272, movewindow
          bindm = $mod, mouse:273, resizewindow
          bind = $mod, mouse:274, togglefloating,
          exec-once = waybar
          # ...
        '';
      };
      home.file.".config/nixpapers" = {
        recursive = true;
        source = ./resources/images/nixpapers;
      };
      services = {
        fnott.enable = true;
      };
    };
    xdg = {
      portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
    };
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=no
    ''; # Clamshell Mode

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    }; # Cache
    ## Ensure greetd has a hyprland entry
    environment.etc."greetd/environments".text = ''
      Hyprland
    '';
  };
}
