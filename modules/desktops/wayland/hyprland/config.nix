{
  pkgs,
  config,
  vars,
  lib,
  ...
}:
with lib; {
  config = mkIf (builtins.elem "hyprland" config.desktop.environments) {

    environment.systemPackages = with pkgs; [
      inputs.hyprland.hyprland-protocols
    ];

    programs.xwayland.enable = true;

    home-manager.users.${vars.user} = {
      pkgs,
      inputs,
      ...
    }: {
      imports = [inputs.hyprland.homeManagerModules.default];
      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.inputs.hyprland.hyprland.override {
          enableXWayland = true;
          enableNvidiaPatches = true;
        };
        xwayland.enable = true;

        extraConfig = ''
           exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
           # See https://wiki.hyprland.org/Configuring/Monitors/
           monitor=DP-3,2560x1440@143.97301,1920x0,1,bitdepth,10
           monitor=HDMI-A-1,1920x1080@119.98200,0x0,1
           # Set default monitor
           xrandr --output DP-3 --primary
           # Network manager applet
           exec-once = nm-applet --indicator & wl-clipboard & waybar -c ~/.config/waybar/config
           # Wallpaper config
           exec-once = ${pkgs.swaybg}/bin/swaybg -i ~/.config/resources/nixpapers/dracula.png
           # StartUp Applications
           exec-once = firefox & slack


           # Some default env vars.
           env = XCURSOR_SIZE,24
           # XDG Portal Specifications
           env = XDG_CURRENT_DESKTOP,Hyprland
           env = XDG_SESSION_DESKTOP,Hyprland
           env = XDG_SESSION_TYPE,wayland
           env = MOZ_ENABLE_WAYLAND,1
           env = MOZ_DBUS_REMOTE,1
           env = SDL_VIDEODRIVER,wayland
           # NixOS Chromium Flags
           env = NIXOS_OZONE_WL,1
           env = EGL_PLATFORM,wayland
           env = NVD_BACKEND,egl
           env = WLR_NO_HARDWARE_CURSORS,1
           env = WLR_BACKEND,"drm,wayland,libinput,headless"
           env = WLR_RENDERER,vulkan
           env = WLR_RENDER_DRM_DEVICE,"/dev/dri/renderD128"

           env = HYPRLAND_LOG_WLR,1

           # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
           input {
               kb_layout = us
               kb_variant =
               kb_model =
               kb_options =
               kb_rules =
               follow_mouse = 0
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

           # Window Rules
           windowrule = float, nm-connection-editor|pavucontrol|Rofi
           windowrule = workspace special:discord silent, Electron
           windowrulev2 = workspace special:steam, class:^(steam)$, title:^(Sign in to Steam)$
           windowrulev2 = workspace special:steam, class:^(steam)$, title:^(Steam)$

           # for xwaylandvideobridge
           windowrulev2 = opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$
           windowrulev2 = noanim, class:^(xwaylandvideobridge)$
           windowrulev2 = nofocus, class:^(xwaylandvideobridge)$
           windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$

           ### Workspace Rules
           workspace = special:steam, on-created-empty:steam
           workspace = special:discord, on-created-empty:discord
           
           ### Launcher Shortcuts
           bind = $mod, T, exec, kitty
           bind = $mod, k, killactive,
           bind = $mod, R, exec, rofi -show drun -show-icons
           bind = $mod, b, exec, firefox
           bind = $altmod, R, exec, rofi -show run -show-icons
           bind = $mod, L, exec, loginctl lock-session $XDG_SESSION_ID
           bind = $altmod, P, exec, grimblast copy area

           ### Window Shortcuts
           bind = $mod, V, togglefloating,
           bind = $altmod, V, fullscreen,
           bind = $mod, Tab_L, cyclenext,
          
           # move windows with $altmod and an arrow key
           # move focus with $mod and an arrow key
           ${lib.strings.concatMapStrings (x: 
            ''
              bind = $mod, ${x}, movefocus, ${ builtins.substring 0 1 x}
              bind = $altmod, ${x}, movewindow, ${ builtins.substring 0 1 x}
            ''
           ) ["left" "right" "up" "down"] }

           ### Workspace Shortcuts:
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
           # ...
        '';
      };
    };
  };
}
