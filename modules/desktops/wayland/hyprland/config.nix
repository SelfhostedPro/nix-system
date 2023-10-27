{
  pkgs,
  config,
  vars,
  lib,
  ...
}:
with lib; {
  config = mkIf (builtins.elem "hyprland" config.desktop.environments) {
    home-manager.users.${vars.user} = {
      pkgs,
      inputs,
      ...
    }: {
      imports = [inputs.hyprland.homeManagerModules.default];

      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland.override {
          enableXWayland = true;
          enableNvidiaPatches = true;
        };
        extraConfig = ''
                 exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
                 # See https://wiki.hyprland.org/Configuring/Monitors/
                 monitor=,preferred,auto,auto
                 # Network manager applet
                 exec-once = nm-applet --indicator
                 exec-once = swww init
                 # Execute your favorite apps at launch
                 exec-once = swww img /etc/nixpapers/dracula.png & firefox & slack


                 # Some default env vars.
                 env = XCURSOR_SIZE,24
                 # XDG Portal Specifications
                 env = XDG_CURRENT_DESKTOP,Hyprland
                 env = XDG_SESSION_DESKTOP,Hyprland
                 env = XDG_SESSION_TYPE,wayland
          env = MOZ_ENABLE_WAYLAND,1
                 # NixOS Chromium Flags
          	  env = NIXOS_OZONE_WL,1
                 env = MOZ_ENABLE_WAYLAND,1
          env = EGL_PLATFORM,wayland
          env = NVD_BACKEND,egl
          env = WLR_NO_HARDWARE_CURSORS,1
          env = WLR_BACKEND,"drm,wayland,libinput,headless"
          env = WLR_RENDERER,vulkan
          env = WLR_RENDER_DRM_DEVICE,"/dev/dri/renderD128"

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
                     #shadow_render_power = 3F
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
                 $altaltmod = SUPER_CTRL

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
                 bind = $altmod, left, movewindow, l
                 bind = $altmod, right, movewindow, r
                 bind = $altmod, up, movewindow, u
                 bind = $altmod, down, movewindow, d

                 # binds $mod + [shift +] {left, right} to [move] the application one workspace in that direction
                 bind = $altaltmod, left, workspace, m-1
                 bind = $altaltmod, right, workspace, m+1

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
    };
  };
}
