{
  pkgs,
  config,
  ...
}: {
  # boot = {
  #
  #   blacklistedKernelModules = [ "nouveau" ];
  #   initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  #   extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # };

  boot = {
    kernelParams = ["nvidia-drm.modeset=1"];
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
    # extraPackages32 = with pkgs; [
    #   libva
    # ];
  };
  # hardware.cpu.amd.updateMicrocode = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
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
      libva
      libva-utils
      wayland-utils
      nvitop
      nvtop-nvidia
    ];
    sessionVariables = {
      # Mostly pulled from https://wiki.hyprland.org/Configuring/Environment-variables/

      # Nvidia Specific https://wiki.hyprland.org/Configuring/Environment-variables/#nvidia-specific
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # Nvidia - VA-API and VDPAU https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuring_VA-API
      LIBVA_DRIVER_NAME = "nvidia";
      VDPAU_DRIVER = "va_gl"; # https://github.com/elFarto/nvidia-vaapi-driver#direct-backend

      # GTK
      GDK_BACKEND = "wayland,x11"; #GTK: Use wayland if available, fall back to x11 if not.

      # QT Variables
      QT_QPA_PLATFORM = "wayland;xcb"; #Qt: Use wayland if available, fall back to x11 if not.
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      # Mozilla Applications
      MOZ_DRM_DEVICE = "/dev/dri/renderD128";
      MOZ_DISABLE_RDD_SANDBOX = "1"; # https://github.com/elFarto/nvidia-vaapi-driver#firefox
    };
  };
}
