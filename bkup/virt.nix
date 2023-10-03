{ configs, pkgs, ... }: {
  users.users.user.extraGroups = [ "libvirtd" ];
  # Utilities to use with VFIO guest
  environment.systemPackages = with pkgs; [
    virtmanager
  ];
  programs.dconf.enable = true;
  # Basic QEMU gui setup
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = true;
    };
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
}
