{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.vfio; # Setup options to be available at vfio.enable and vfio.gpuIDs
in
{
  options.vfio = {
    enable = mkEnableOption "Configure machine for VFIO"; # Boolean to enable
    gpuIDs = mkOption {
      # List of gpu ids 
      type = types.listOf types.str;
      description = "use https://gist.github.com/n1snt/b0bd972af8adc73240cdb0abff71cf7b to get your IDs.";
    };
  };

  config = mkIf cfg.enable {
    # Setup kernel modules and params
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      kernelParams = [
        "amd_iommu=on"
      ] ++ optional (!(builtins.typeOf cfg.gpuIDs == null)) ## Add VFIO IDs if the gpuIDs config setting is set.
        ("vfio-pci.ids=" + concatStringsSep "," cfg.gpuIDs);
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    # Utilities to use with VFIO guest
    environment.systemPackages = with pkgs; [
      looking-glass-client
      scream
    ];
  };
}
