{ pkgs, config, ... }: {

  # boot = {
  #   
  #   blacklistedKernelModules = [ "nouveau" ];
  #   initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  #   extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # };

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" ];
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  services.dbus.enable = true;
  services.upower.enable = true;

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      xdg-utils
      ffmpeg-full
      vdpauinfo
      libva-utils
      wayland-utils
      nvitop
      nvtop-nvidia

    ];
    sessionVariables =
      {
        # Mostly pulled from https://wiki.hyprland.org/Configuring/Environment-variables/

        # Nvidia Specific https://wiki.hyprland.org/Configuring/Environment-variables/#nvidia-specific
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # Nvidia - VA-API Driver Specific
        NVD_BACKEND = "egl"; # https://github.com/elFarto/nvidia-vaapi-driver#environment-variables

        # Nvidia - VA-API and VDPAU https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuring_VA-API
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_DRIVER = "va_gl"; # https://github.com/elFarto/nvidia-vaapi-driver#direct-backend
        EGL_PLATFORM = "wayland"; # https://github.com/TLATER/dotfiles/blob/tlater/fix-firefox-nvidia/nixos-config/yui/nvidia.nix

        # GTK
        GDK_BACKEND = "wayland,x11"; #GTK: Use wayland if available, fall back to x11 if not.

        # QT Variables
        QT_QPA_PLATFORM = "wayland;xcb"; #Qt: Use wayland if available, fall back to x11 if not.
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        # WLRoots https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md?ref_type=heads
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_BACKEND = "drm,wayland,libinput,headless";
        WLR_RENDERER = "vulkan";

        WLR_RENDER_DRM_DEVICE = "/dev/dri/renderD128";

        # XDG Portal Specifications
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";

        # Mozilla Applications
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_DRM_DEVICE = "/dev/dri/renderD128";
        MOZ_DISABLE_RDD_SANDBOX = "1"; # https://github.com/elFarto/nvidia-vaapi-driver#firefox

        # NixOS Chromium Flags
        NIXOS_OZONE_WL = "1";
      };
  };
}
