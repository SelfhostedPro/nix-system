{ config, pkgs, ... }:
{
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
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
}
