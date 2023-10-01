{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    #    SDL_VIDEODRIVER = "wayland";
    #    _JAVA_AWT_WM_NONREPARENTING = "1";
    #    CLUTTER_BACKEND = "wayland";
    #    WLR_RENDERER = "vulkan";
    #    XDG_CURRENT_DESKTOP = "Hyprland";
    #    XDG_SESSION_DESKTOP = "Hyprland";
    #    GTK_USE_PORTAL = "1";
    #    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd Hyprland
      '';
    };
  };

  environment.etc."greetd/environments".text = ''
    hyprland
  '';
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
    };
    waybar = {
      enable = true;
    };
    thunar = {
      enable = true;
    };
  };
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
